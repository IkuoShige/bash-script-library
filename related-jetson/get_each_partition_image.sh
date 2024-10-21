#!/bin/bash

# sudo apt-get install -y sshpass

#sudo dd if=/dev/mmcblk0p1 bs=4M | ssh user@hostpc 'gzip -c > ~/dd_backup_jetson/231009_APP_backup_image.img.gz'

#sshpass -p 'ikuo' scp -o StrictHostKeyChecking=no <localfile-path> user@host:/path-to-copy

user="ikuo"
hostpc="192.168.10.115"
ssh_password="ikuo"

sudo parted /dev/mmcblk0 -s unit s print > structure_jetson_disk
sshpass -p $ssh_password mkdir -p "$user@$hostpc:/home/$user/dd_backup_jetson/$(date +%y%m%d)/"
sshpass -p $ssh_password scp -o StrictHostKeyChecking=no structure_jetson_disk "$user@$hostpc:/home/$user/dd_backup_jetson/$(date +%y%m%d)/"

for partition in {2..44}; do
    partition_number=$(printf "%02d" $partition)
    source_partition="/dev/mmcblk0p$partition"
    destination_file="~/dd_backup_jetson/$(date +%y%m%d)/$(date +%y%m%d)_0p${partition_number}_backup_image.img.gz"

    sudo dd if="$source_partition" bs=4M | sshpass -p "$ssh_password" ssh "$user@$hostpc" "gzip -c > $destination_file"

done

# パーティション1のバックアップ
partition=1
partition_number=$(printf "%02d" $partition)
source_partition="/dev/mmcblk0p$partition"
destination_file="~/dd_backup_jetson/$(date +%y%m%d)/$(date +%y%m%d)_0p${partition_number}_backup_image.img.gz"

sudo dd if="$source_partition" bs=4M | sshpass -p "$ssh_password" ssh "$user@$hostpc" "gzip -c > $destination_file"
