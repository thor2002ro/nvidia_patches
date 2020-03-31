#!/bin/bash

TOR_VERSION="9.5a2"

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
  echo "Failed to find getopt"
  exit 1
fi

SHORT=dxnv
LONG=debug,nocheck,noupdate,verbose

PARSED=$(getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
  exit 2
fi

eval set -- "$PARSED"

while true; do
    case "$1" in
        -d|--debug)
            do_debug=y
            shift
            ;;
        -v|--verbose)
            do_verbose=y
            shift
            ;;
        -x|--no-check)
          do_check=n
          shift
          ;;
        -n|--no-update)
            do_noupdate=y
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "error"
            exit 3
            ;;
    esac
done

extra_cmd=""
if [ "$do_verbose" == "y" ]; then
  extra_cmd="$extra_cmd -v"
fi

function downloadFile() {
  URL=$1
  FILE=$2

  HOST="$(echo $URL | pcregrep -o1 'https?://(.*\.[a-zA-Z]+)/.*')"
  REFERER="$HOST"

  if [ "$do_debug" == "y" ]; then
    echo "Fetching: '$URL'"
    echo "File: '$FILE'"
    echo "Host: '$HOST'"
    echo "Referer: '$REFERER'"
  fi

  curl "$URL" \
    -H "Host: $HOST" \
    -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101 Firefox/60.0' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
    -H 'Accept-Language: en-US,en;q=0.5' \
    -H "Referer: http://$REFERER/" \
    -H 'Connection: keep-alive' \
    $extra_cmd \
    -o "$FILE"

  if [[ $? -ne 0 ]]; then
    echo "cURL failed with status: $?"
  fi
}

if [ "$do_check" != "n" ]; then
  echo -n "Checking for latest version... "

  API_URL="https://www.torproject.org/projects/torbrowser/RecommendedTBBVersions/"
  API_VERSIONS=$(curl -s "$API_URL")
  if [[ $? -ne 0 ]]; then
    echo "cURL failed with status: $?"
  fi

  TOR_VERSION_CHECK=$(echo "$API_VERSIONS" | pcregrep -o1 '"([[:alnum:]\.]+)-Linux"' | tail -n1)

  TOR_VERSION_MISSMATCH=""
  [[ "x$TOR_VERSION" != "x$TOR_VERSION_CHECK" ]] && TOR_VERSION_MISSMATCH=" !!! UPDATE AVAILIBLE !!!"

  echo "$TOR_VERSION_CHECK. (Internal: $TOR_VERSION)$TOR_VERSION_MISSMATCH"

  TOR_VERSION=$TOR_VERSION_CHECK

  if [ "$do_debug" == "y" ]; then
    echo "Availible versions: $API_VERSIONS"
  fi
fi

if [ "$do_noupdate" == "y" ]; then
  exit
fi

TOR_FILE="tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz"
TOR_URL="https://dist.torproject.org/torbrowser/$TOR_VERSION"

if [ ! -f "$TOR_FILE" ]; then
  downloadFile "$TOR_URL/$TOR_FILE" "$TOR_FILE"
  downloadFile "$TOR_URL/$TOR_FILE.asc" "$TOR_FILE.asc"
fi

gpg $extra_cmd --verify "$TOR_FILE.asc"

if [[ $? -ne 0 ]]; then
  echo "Warning: GPG check failed with status: $?"
fi

if [ -d "bin" ]; then
  rm $extra_cmd -r bin
fi

mkdir $extra_cmd bin
pushd bin

tar $extra_cmd --strip-components=1 -xf "../$TOR_FILE"

if [[ $? -ne 0 ]]; then
  echo "tar failed with status: $?"
fi

type -P "paxctl-ng" > /dev/null && paxctl-ng -em "Browser/firefox"

popd

if [ -f "start.sh" ]; then
  rm $extra_cmd -f start.sh
fi

echo -e '#!/bin/bash -e
cd bin/Browser
./start-tor-browser --class Tor\ Browser "${args[@]}" &
disown -h $!' > start.sh
chmod $extra_cmd 0500 start.sh
