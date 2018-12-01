#!/bin/bash

fdisk_result="$(fdisk -l $1)"
disk_info="$(echo "${fdisk_result}" | grep HFS | head -1)"
sector_size="$(echo "${fdisk_result}" | grep "Sector\ size" | awk '{print $4}')"
size="$(echo "${disk_info}" | awk '{print $4}')"
offset="$(echo "${disk_info}" | awk '{print $2}')"

echo "Disk Info:${disk_info}\n"
echo "sector_size:${sector_size},offset:$((${offset}*${sector_size})),size:$((${size}*${sector_size}))"

mount -t hfsplus -o ro,offset=$((${offset}*${sector_size})),sizelimit=$((${size}*${sector_size})) $1 $2
