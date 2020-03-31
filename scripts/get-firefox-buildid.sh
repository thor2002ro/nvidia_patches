#!/bin/bash -e

ZV=$(7za --help)

FILE=$1

_tmp_folder=$(mktemp -d)

if [ "$FILE" == "--fetch" ]; then
  _location=$(curl -sI 'https://download.mozilla.org/?product=firefox-esr-latest&os=win64&lang=en-US' | pcregrep -o1 'Location:\s+(https?.+\.exe)')
  _version=$(echo "$_location" | pcregrep -o1 '\/([\d\.]+esr)\/')

  curl -qLo "$_tmp_folder/Firefox Setup $_version.exe" \
    "$_location"
  FILE="$_tmp_folder/Firefox Setup $_version.exe"

  echo -n "$_version: "
elif [ ! -e "$FILE" ]; then
  curl -qLo "$_tmp_folder/Firefox Setup $FILE.exe" \
    "https://ftp.mozilla.org/pub/firefox/releases/$FILE/win64/en-US/Firefox%20Setup%20$FILE.exe"
  FILE="$_tmp_folder/Firefox Setup $FILE.exe"
fi

7za e "$FILE" -bb0 -bd -bso0 -bsp0 -o"$_tmp_folder" "core/platform.ini"

pcregrep -o1 'BuildID=([0-9]+)' "$_tmp_folder/platform.ini"

rm -r "$_tmp_folder"
