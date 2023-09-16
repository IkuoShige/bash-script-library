# bash-script-library

## OverView
色々なbashのスクリプトファイルをまとめました。

* raspicat_slam_toolboxを用いてrosbagから地図生成までを行うスクリプト
* 複数のコマンドをTerminatorで分割して実行するスクリプト
* ROS 2のすべてのノードをkillするスクリプト
* 複数のコマンドをtmuxで分割して実行するスクリプト

## Directory Configuration

```
.
├── LICENSE
├── README.md
├── generate-map.sh
├── kill_ros_node.sh
├── mapping_script.sh
├── sample_script_via_terminator.sh
├── terminator_window.sh
└── tmux_multi_command.sh
```

## Usage

### raspicat_slam_toolboxを用いてrosbagから地図生成

```
./generate-map --rosbag /path/to/your/rosbag.bag --map /path/to/your/map_name
```

### 複数のコマンドをTerminatorで分割して実行
最大4つのコマンドを実行できる。

以下のパッケージをインストールする必要がある

```
$ sudo apt install -y terminator xdotool
```

`sample_script_via_terminator.sh`の1行目以降を必要に応じて変更する。


```
./sample_script_via_terminator.sh
```

### ROS 2のすべてのノードをkill

```
./kill_ros_node.sh
```

### 複数のコマンドをtmuxで分割して実行
以下のパッケージをインストールする必要がある

```
$ sudo apt install -y tmux
```

実行
- 引数なし：画面を3つに分割したレイアウトにする
    ```bash
    ./tmux_multi_command.sh
    ```
- 縦横に分割
    ```bash
    ./tmux_multi_command.sh square
    ```
- 縦に分割
    ```bash
    ./tmux_multi_command.sh tate
    ```
## Extra

### mapping_script.sh
* raspicatで地図作成のためのrosbagを取得するコマンドをまとめたもの
* **複数のコマンドをTerminatorで分割** を応用

### terminator_window.sh
* Terminatorでのショートカットの一部（画面の分割・移動）をbashで行うためのスクリプト
