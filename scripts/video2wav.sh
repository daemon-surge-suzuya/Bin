#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 input_video [output_audio]"
    exit 1
fi

input_video=$1
output_audio=${2:-output.wav}

ffmpeg -i "$input_video" -vn -acodec pcm_s16le -ar 44100 -ac 2 "$output_audio"

