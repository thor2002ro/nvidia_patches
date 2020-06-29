#!/bin/bash

apath=$1

[[ "x$apath" == "x" ]] && apath=.

shopt -s nullglob
for file in "$apath"/*.{bmp,jpg,jpeg,png};
do
  aspect=$(convert "$file" -format "%[fx:w/h>1?1:0]" info: 2>/dev/null)
  if [ $? -ne 0 ]; then
    continue
  fi

  if [ $aspect -eq 1 ]; then
    echo "$file"
  fi
done
shopt -u nullglob
