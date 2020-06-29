#!/bin/bash

_path=$1
_threshold=50

find "$_path" -xdev -type f -print0 | while IFS= read -r -d $'\0' f; do
  _extents=$(LC_ALL=C filefrag "$f" | pcregrep -o1 '([0-9]+) extents? found$')
  if [[ $_extents -gt $_threshold ]]; then
    echo "$f: $_extents"
  fi
done
