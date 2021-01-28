#!/bin/bash

FILENAME=$1
CHUNKS=$2
LIST_OF_CHUNKS=""

for i in $(seq 1 $(($CHUNKS-1)));
do
	LIST_OF_CHUNKS="${LIST_OF_CHUNKS}output${i}|"
	echo "file output${i}.mp4" >> list-of-chunks.txt
done

LIST_OF_CHUNKS="${LIST_OF_CHUNKS}output${CHUNKS}"

ffmpeg -f concat -i list-of-chunks.txt -c copy final-${FILENAME}.mp4 || true

rm -f output*.mp4

rm -f list-of-chunks.txt
