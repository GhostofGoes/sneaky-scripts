#!/usr/bin/env bash

FOLDER=$1

for i in "$FOLDER"/*.flac ; do
    ffmpeg -y -i "$i" -codec:a libmp3lame -q:a 0 -map_metadata 0 -id3v2_version 3 -write_id3v1 1 "$(basename "${i/.flac}").mp3"
done
