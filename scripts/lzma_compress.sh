#!/bin/bash

XZ_OPT=-9 tar -cf "$1" --lzma --owner=0 --group=0 "${@:2}"
