#!/bin/bash

export LD_LIBRARY_PATH=/usr/local/lib

echo $SRT_RELAY_SERVER

/usr/local/bin/ffmpeg -i rtmp://localhost:1935/live/$1 -vcodec copy -pkt_size 1316 -f mpegts srt://${SRT_RELAY_SERVER}?streamid=input/live/$1 >> /dev/stdout 2>> /dev/stderr