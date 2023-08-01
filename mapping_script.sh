./terminator_window.sh \
    "ros2 launch raspicat raspicat.launch.py" \
    "ros2 service call /motor_power std_srvs/SetBool '{data: true}'" \
    "ros2 launch raspicat_bringup teleop.launch.py teleop:=joy" \
    "ros2 launch raspicat_bringup rosbag_record.launch.py rosbag_path:=$HOME/rosbag_mapping"
