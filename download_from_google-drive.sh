#!/bin/bash
# リンクを知っている全員に設定したときの共有リンクを参照する
# https://drive.google.com/file/d/<FILE_ID>/view?usp=sharing
FILE_ID="<FILE_ID>"
FILE_NAME="<FILE_NAME>"

CONFIRM=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate "https://drive.google.com/uc?export=download&id=$FILE_ID" -O- | sed -En 's/.*confirm=([0-9A-Za-z_]+).*/\1/p');

#wget "https://drive.google.com/uc?export=view&id=$FILE_ID" -O "$FILE_NAME"
wget --load-cookies /tmp/cookies.txt "https://drive.google.com/uc?export=download&confirm=$CONFIRM&id=$FILE_ID" -O $FILE_NAME;

rm -f /tmp/cookies.txt
