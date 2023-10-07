#!/bin/bash
# Apache License
# Version 2.0, January 2004
# http://www.apache.org/licenses/

# Parse command line arguments
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        --rosbag)
        rosbag_path="$2"
        shift
        shift
        ;;
        --map)
        map_name="$2"
        shift
        shift
        ;;
        *)
        # Unknown option, show usage
        echo "Usage: $0 --rosbag <参照するrosbagのパス> --mapname <saveするmapの名前>"
        exit 1
        ;;
    esac
done

# Check if the required arguments are provided
if [ -z "$rosbag_path" ] || [ -z "$map_name" ]; then
    echo "Usage: $0 --rosbag <参照するrosbagのパス> --mapname <saveするmapの絶対パス>"
    exit 1
fi

# change map file name
# ファイルのパス
file_path="$HOME/ros2_ws/src/FAST_LIO/config/mid360.yaml"

# 新しい行の内容
#new_line='        map_file_path: "${map_name}"'
new_line="        map_file_path: \"$map_name\""

# 一時ファイルを作成して新しい行を追加
tmp_file="tmp.yaml"
awk -v new_line="$new_line" 'NR==3{$0=new_line} 1' "$file_path" > "$tmp_file"

# 一時ファイルを元のファイルに移動
mv "$tmp_file" "$file_path"

# Launch raspicat_slam_toolbox
# ros2 launch raspicat_slam raspicat_slam_toolbox.launch.py &
ros2 launch fast_lio mapping.launch.py config_path:=$HOME/ros2_ws/src/FAST_LIO/config/mid360.yaml &

# Wait for a few seconds to make sure the launch is complete (adjust the sleep time if needed)
sleep 5

# Get the duration of the rosbag
duration=$(ros2 bag info $rosbag_path | grep "Duration" | awk '{print $2}')

# Play the rosbag with adjusted playback rate and clock
ros2 bag play -r 1 --clock 100 $rosbag_path &

# Wait for the duration of the rosbag
sleep $duration

# Run map_saver_cli to save the map
# ros2 run nav2_map_server map_saver_cli -f $map_name
ros2 service call /map_save std_srvs/srv/Trigger

# Wait for the map saving process to complete (adjust the sleep time if needed)
sleep 5

# Terminate the running nodes
./kill_ros_node.sh

