#!/bin/bash

# sudo apt-get install sshpass

remote_user="ubuntu"
remote_host="192.168.12.1"
ssh_password="hogehoge"
# リモートサーバーで実行したいコマンド
remote_command="./play_controller_raspicat.sh"
#remote_command="./play_controller_raspicat.sh"
# SSH接続
sshpass -p "$ssh_password" ssh -t "$remote_user@$remote_host" "$remote_command"
