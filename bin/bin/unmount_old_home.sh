#!/usr/bin/env bash

set -eEuo pipefail

echo "unmounting LVM volume..."
sudo umount /mnt/decrypted_drive

drive_name=`sudo vgs | grep debian_clone | xargs | cut -d " " -f 1`
echo "closing decrypted VG ${drive_name}-home"
sudo cryptsetup luksClose ${drive_name}-home
echo "closing decrypted VG ${drive_name}-swap"
sudo cryptsetup luksClose ${drive_name}-swap
echo "closing decrypted VG ${drive_name}-root"
sudo cryptsetup luksClose ${drive_name}-root

echo "closing parent VG 'my_encrypted_volume'"
sudo cryptsetup luksClose my_encrypted_volume

echo "closing loop device '/dev/loop27'"
sudo losetup -d /dev/loop27

echo "drive unmounted!"

