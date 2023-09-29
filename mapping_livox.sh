#!/bin/bash/
# Apache License
# Version 2.0, January 2004
# http://www.apache.org/licenses/

# ペイン1
#tmux split-window -h
tmux send-keys "ros2 launch livox_ros_driver2 msg_MID360_launch.py" C-m
#tmux send-keys "ls" C-m

# ペイン2
clear
tmux split-window -v
#tmux send-keys "cd" C-m
#tmux send-keys "ros2 launch fast_lio mapping.launch.py" C-m
tmux send-keys "ros2 launch raspicat_bringup rosbag_record.launch.py rosbag_path:=$HOME/rosbag_mapping" C-m

# ペイン3
#tmux split-window -v
#tmux send-keys "lsb_release -a" C-m
#tmux send-keys "ros2 launch raspicat_bringup rosbag_record.launch.py rosbag_path:=$HOME/rosbag_mapping" C-m

# ペイン4
#tmux split-window -v
#tmux send-keys "lsusb" C-m
#tmux send-keys "ros2 launch raspicat_bringup rosbag_record.launch.py rosbag_path:=$HOME/rosbag_mapping" C-m

# レイアウトを整える：ペイン4つの場合
tmux select-layout tiled # 上下左右1つずつ
