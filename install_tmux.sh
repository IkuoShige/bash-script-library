#!/bin/bash

# 引数からバージョンを取得
tmux_version="$1"

# 引数が指定されていない場合、デフォルトのバージョンを使用
if [ -z "$tmux_version" ]; then
    tmux_version="3.3a"
fi

tmux_url="https://github.com/tmux/tmux/releases/download/${tmux_version}/tmux-${tmux_version}.tar.gz"

wget "$tmux_url"
tar -zxf "tmux-${tmux_version}.tar.gz"
cd "tmux-${tmux_version}/"
sudo apt install -y libevent-dev ncurses-dev build-essential bison pkg-config
./configure 
make && sudo make install

cd ../ && rm -rf "tmux-${tmux_version}/" "tmux-${tmux_version}.tar.gz"
