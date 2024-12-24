#!/bin/bash

# Directory to save recordings
output_dir=~/OBS

# Ensure the output directory exists
mkdir -p "$output_dir"

# Get the current date and time for the filename
timestamp=$(date +%Y-%m-%d_%H-%M-%S)

# Determine the screen dimensions
screen_dimensions=$(xdpyinfo | awk '/dimensions/{print $2}')

# Parse flags
while getopts "sab" flag; do
    case "${flag}" in
        s)
            dunstify 'Screen Recording has started...'
            # ffmpeg -f x11grab -video_size "$screen_dimensions" -framerate 60 -i :0.0+0,0 -c:v libx264 -preset ultrafast -c:a aac "$output_dir/${timestamp}_screen.mp4"
            ffmpeg -f x11grab -video_size "$screen_dimensions" -framerate 60 -i :0.0+0,0 -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p "$output_dir/${timestamp}_screen.mp4"
            ;;
        a)
            dunstify 'Sound Recording has Started...'
            ffmpeg -f pulse -i alsa_output.pci-0000_00_1f.3.analog-stereo.monitor -ac 2 "$output_dir/${timestamp}_audio.mp3"
            ;;
        b)
            dunstify 'Screen and Sound Recording has started...'
            # ffmpeg -f x11grab -video_size "$screen_dimensions" -framerate 60 -i :0.0+0,0 -f pulse -i alsa_output.pci-0000_00_1f.3.analog-stereo.monitor -c:v libx264 -preset ultrafast -c:a aac "$output_dir/${timestamp}_screen_sound.mp4"
            ffmpeg -f x11grab -video_size "$screen_dimensions" -framerate 60 -i :0.0+0,0 -f pulse -i alsa_output.pci-0000_00_1f.3.analog-stereo.monitor -c:v libx264 -preset veryfast -crf 23 -pix_fmt yuv420p "$output_dir/${timestamp}_screen_sound.mp4"
            ;;
        l) 
            dunstify 'Mic recording has started...'
            fmpeg -f alsa -i hw:0,0 "$output_dir/${timestamp}_mic.wav"
            ;;
        *)
            echo "Usage: $0 [-s] [-a] [-b]"
            exit 1
            ;;
    esac
done

# If no flags were passed, show usage
if [ $OPTIND -eq 1 ]; then
    echo "Usage: $0 [-s] [-a] [-b]"
    exit 1
fi

