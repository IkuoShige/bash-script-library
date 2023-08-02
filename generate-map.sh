#!/bin/bash

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
    echo "Usage: $0 --rosbag <参照するrosbagのパス> --mapname <saveするmapの名前>"
    exit 1
fi

# Launch raspicat_slam_toolbox
ros2 launch raspicat_slam raspicat_slam_toolbox.launch.py &

# Wait for a few seconds to make sure the launch is complete (adjust the sleep time if needed)
sleep 5

# Get the duration of the rosbag
duration=$(ros2 bag info $rosbag_path | grep "Duration" | awk '{print $2}')

# Play the rosbag with adjusted playback rate and clock
ros2 bag play -r 1 --clock 100 $rosbag_path &

# Wait for the duration of the rosbag
sleep $duration

# Run map_saver_cli to save the map
ros2 run nav2_map_server map_saver_cli -f $map_name

# Wait for the map saving process to complete (adjust the sleep time if needed)
sleep 5

# Terminate the running nodes
./kill_ros_node.sh

