#!/bin/bash

# 引数からデバイスのパスを取得
#input_device_path="$1"
device_path="/dev/mmcblk0"

# デバイスのパスが指定されていない場合、エラーメッセージを表示して終了
if [ -z "$device_path" ]; then
  echo "デバイスのパスを指定してください。"
  exit 1
fi

# get last sector
# 言語設定を英語に設定
export LC_ALL=C
export LANG=C

# SDカードのデバイスファイル
#device="/dev/sdb"

# セクタ数を取得
#max_sectors=$(sudo fdisk -l "$device_path" | awk '/^Disk/ {print $7}')
max_sectors=$(sudo fdisk -l "/dev/mmcblk0" | awk '/^Disk/ {print $7}')
echo "max sector: $max_sectors"

# 言語設定を元に戻す
unset LC_ALL
unset LANG

#echo "SDカードのセクタ数: $sectors セクタ"

# パーティション情報を配列に抽出
#mapfile -t partition_info < <(sudo parted "$device_path" -s unit s print | awk '/^ *[0-9]+/ {gsub(/,/, "", $7); print $1, $2, $3, $7, $6, $5}')
# import by structure_jetson_disk
mapfile -t partition_info < <(cat ~/backup_jetson_dd/240901/structure_jetson_disk | awk '/^ *[0-9]+/ {gsub(/,/, "", $7); print $1, $2, $3, $4, $7, $6, $5}')

# 配列の要素を表示
total_size=0
mergin_size=1024+40  # マージンサイズ
for ((i = 1; i < ${#partition_info[@]}; i++)); do  # 0番目をスキップするために i=1 から開始
  info="${partition_info[i]}"
  IFS=" " read -r number start end size flags name filesystem <<< "$info"
  size=${size%s}  # 's' を削除して数値のみを抽出
  total_size=$((total_size + size + mergin_size))  # size を合計に加算

  # ... 既存の出力コード ...
done

echo "0番目を除くパーティションのサイズ合計: $total_size"  # 合計値を出力
echo "max_sectors - total_size: $(($max_sectors - $total_size))s"

origin_APP_size=0
# 配列の要素を表示
#for info in "${partition_info[@]}"; do
for ((i = 0; i < ${#partition_info[@]}; i++)); do
  info="${partition_info[i]}"
  IFS=" " read -r number start end size flags name filesystem <<< "$info"

  # 名前が空白の場合、適当なメッセージを表示
  if [ -z "$name" ]; then
    name="名前なし"
  fi

  echo "パーティション番号: $number"
  echo "開始セクタ: $start"
  echo "終了セクタ: $end"
  echo "size: $size"
  echo "ファイルシステム: $filesystem"
  echo "名前: $name"
  echo "フラグ: $flags"
  echo "path: ${device_path}p${number}"
  echo "-------------------------"
  if [ "$i" -eq 0 ]; then
    origin_APP_size=${size%s}
    echo "origin_APP_size: $origin_APP_size"
    sudo parted "$device_path" mktable gpt
    wait
    #sudo parted "$device_path" mkpart $name $filesystem $start $end -a none
    sudo parted "$device_path" mkpart $name $filesystem $start "$(($max_sectors - $total_size -41))s"
    wait
    sudo mkfs.ext4 /dev/mmcblk0p1
    #sudo e2image -ra -p -f "$input_device_path$number" "$device_path$number"
    partition_number=$(printf "%02d" $number)
    gunzip -c 240901_0p${partition_number}_backup_image.img.gz | sudo dd of="${device_path}p${number}" bs=16M status=progress
    wait
    e2fsck -f -y -v "${device_path}p${number}"
    wait
    sudo parted "$device_path" set $number $flags on
  else
    #sudo parted "$device_path" mkpart $name ext2 $start $end -a none
    diff=$(($max_sectors - $total_size - $origin_APP_size))
    start=${start%s}  # 's' を削除して数値のみを抽出
    end=${end%s}  # 's' を削除して数値のみを抽出
    start="$((start + $diff))s"
    end="$((end + $diff))s"
    echo "start: $start"
    echo "end: $end"
    sudo parted "$device_path" mkpart $name ext2 $start $end -a none
    wait
    #sudo dd if="$input_device_path$number" of="$device_path$number" bs=1M status=progress
    partition_number=$(printf "%02d" $number)
    gunzip -c 240901_0p${partition_number}_backup_image.img.gz | sudo dd of="${device_path}p${number}" bs=16M status=progress
    wait
    sudo parted "$device_path" set $number msftdata on
    wait
  fi
done

echo "finish."
# 33s (マージン持って34s)後ろに開けないとpartedコマンドで怒られる
