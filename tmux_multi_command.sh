#!/bin/bash

#tmux new-session -d -s "ros_commands"
#while [[ $# -gt 0 ]];do
if [ "$#" -eq 0 ]; then
  tmux split-window -v
  tmux split-window -h
  tmux resize-pane -D 15
  tmux select-pane -t 1
else
  case "$1" in
    square)
        # ペイン1
        #tmux split-window -h
        #tmux send-keys "ros2 launch raspicat raspicat.launch.py" C-m
        tmux send-keys "ls" C-m
        clear

        # ペイン2
        tmux split-window -h
        tmux select-pane -t 2
        #tmux send-keys "ros2 service call /motor_power std_srvs/SetBool '{data: true}'" C-m
        tmux send-keys "cd" C-m

        # ペイン3
        tmux select-pane -t 1
        tmux split-window -v
        #tmux send-keys "ros2 launch raspicat_bringup teleop.launch.py teleop:=joy" C-m
        tmux send-keys "lsb_release -a" C-m

        # ペイン4
        tmux select-pane -t 3
        tmux split-window -v
        #tmux send-keys "ros2 launch raspicat_bringup rosbag_record.launch.py rosbag_path:=$HOME/rosbag_mapping" C-m
        tmux send-keys "lsusb" C-m
        ;;
    tate)
        # ペイン1
        #tmux split-window -h
        #tmux send-keys "ros2 launch raspicat raspicat.launch.py" C-m
        tmux send-keys "ls" C-m
        
        # ペイン2
        #tmux select-pane -t 1
        clear
        tmux split-window -v
        tmux send-keys "cd" C-m
        #tmux send-keys "ros2 service call /motor_power std_srvs/SetBool '{data: true}'" C-m
        
        # ペイン3
        #tmux select-pane -t 1
        tmux split-window -v
        tmux send-keys "lsb_release -a" C-m
        #tmux send-keys "ros2 launch raspicat_bringup teleop.launch.py teleop:=joy" C-m
        
        # ペイン4
        #tmux select-pane -t 1
        tmux split-window -v
        tmux send-keys "lsusb" C-m
        #tmux send-keys "ros2 launch raspicat_bringup rosbag_record.launch.py rosbag_path:=$HOME/rosbag_mapping" C-m
        
        # レイアウトを整える：ペイン4つの場合
        #tmux select-layout main-horizontal # 上1つ下3つ
        #tmux select-layout main-vertical # 左1つ右3つ
        tmux select-layout tiled # 上下左右1つずつ
        #tmux select-layout even-horizontal # 横4つ
        #tmux select-layout even-vertical # 縦4つ
        ;;
    #*)
    #    exit 1
    #    ;;
  esac
fi
#done

# ペイン1にフォーカスを戻す
tmux select-pane -t 1

# セッションをアタッチ
#tmux attach -t "ros_commands"

