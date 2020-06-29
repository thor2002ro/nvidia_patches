#!/bin/bash

ffmpeg -i "$1" -c copy -bsf:a aac_adtstoasc -flags +global_header "$2"
