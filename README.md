# bash-script-library

## OverView
色々なbashのスクリプトファイルをまとめました。

* rosbagから地図生成までを行うスクリプト
* 複数のコマンドをTerminatorで分割して実行するスクリプト
* ROS 2のすべてのノードをkillするスクリプト

## Directory Configuration

```
.
├── LICENSE
├── README.md
├── generate-map.sh
├── kill_ros_node.sh
├── mapping_script.sh
├── sample_script_via_terminator.sh
└── terminator_window.sh
```

## Usage

### rosbagから地図生成

```
./generate-map --rosbag /path/to/your/rosbag.bag --map /path/to/your/map_name
```

### 複数のコマンドをTerminatorで分割
最大4つのコマンドを実行できる。

`sample_script_via_terminator.sh`の1行目以降を必要に応じて変更する。


```
./sample_script_via_terminator.sh
```

### ROS 2のすべてのノードをkill

```
./kill_ros_node.sh
```
