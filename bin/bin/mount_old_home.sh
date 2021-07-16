#!/usr/bin/env bash

set -eEuo pipefail

cd /media/$USER/18c5ba11-ee56-4032-90e8-303e6ba1ad66

echo "mounting partition at offset 162657206272"
sudo losetup -o 162657206272 /dev/loop27 bxpsd_full_drive_image_210711.img

echo "decrypting LUKS volume as 'my_encrypted_volume'"
sudo cryptsetup luksOpen /dev/loop27 my_encrypted_volume

echo "importing VG on 'my_encrypted_volume' as clone 'debian_clone'"
sudo vgimportclone -n debian_clone /dev/mapper/my_encrypted_volume

drive_name=`sudo vgs | grep debian_clone | xargs | cut -d " " -f 1`
echo "mounting VG '${drive_name}'"
sudo vgchange --activate y "${drive_name}"

echo "mounting ext4 partition to /mnt/decrypted_drive"
sudo mkdir -p /mnt/decrypted_drive
sudo mount -o ro "/dev/mapper/${drive_name}-home" /mnt/decrypted_drive

echo "drive mounted! changing to directory /mnt/decrypted_drive ..."
cd /mnt/decrypted_drive

