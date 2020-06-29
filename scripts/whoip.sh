#!/bin/bash

_domain=$1

if [[ "$_domain" == "" ]]; then
  echo "Usage: whoip [SUB.]DOMAIN.TLD" 1>&2
  exit 1 
fi

_domain=${_domain##*//}
_domain=${_domain///*}
_domain=${_domain//:*}

ips=$(dig "${@:2}" +short "$_domain")
if [[ "$ips" == "" ]]; then
  echo "Error: Domain has no route" 1>&2
  exit 1
fi

while read -r line; do
  echo "> whois: $line"
  whois "$line"
done <<< "$ips"
