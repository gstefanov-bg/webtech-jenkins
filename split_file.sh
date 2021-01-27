#!/bin/bash

#DURATION=$1
FILE_NAME=$1
CHUNKS=$2
COUNTER=0
NAME=1

SEPARATORS=$(($CHUNKS - 1))

#SECONDS=$(echo $DURATION | awk '{ split($1, A, ":"); split(A[3], B, "."); print 3600*A[1] + 60*A[2] + B[1] }')
SECONDS=$(ffmpeg -i $FILE_NAME 2>&1 | grep "Duration" | cut -d ' ' -f 4 | sed s/,// | sed 's@\..*@@g' | awk '{ split($1, A, ":"); split(A[3], B, "."); print 3600*A[1] + 60*A[2] + B[1] }')

h=$(bc <<< "$SECONDS / 3600")
m=$(bc <<< "($SECONDS % 3600) / 60")
s=$(bc <<< "$SECONDS % 60")

MINUTES=$(bc <<< "($h * 60 + $m)")
CHUNKS_SECONDS=$(bc <<< "$SECONDS / $SEPARATORS")
EQUAL_CHUNKS_SECONDS=$(($SECONDS-$CHUNKS_SECONDS)) # sum of the seconds of the chunks that are equal in duration

echo $SECONDS
for i in $(seq 0 $CHUNKS_SECONDS $EQUAL_CHUNKS_SECONDS);
do
  ffmpeg -i $1 -ss $COUNTER -t $CHUNKS_SECONDS -vcodec copy -acodec copy output$NAME.mp4
  COUNTER=$(($COUNTER+$CHUNKS_SECONDS))
  NAME=$(($NAME+1))
done

ffmpeg -i $1 -ss $COUNTER -vcodec copy -acodec copy output$NAME.mp4
