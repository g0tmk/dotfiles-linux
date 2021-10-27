    # how to recreate grub using a live debian usb
    # boot into live usb and run these commands:

    # assumes:
    # /dev/nvme0n1 - boot drive
    # /dev/nvme0n1p2 - EFI partition
    # /dev/nvme0n1p6 - boot partition
    # /dev/nvme0n1p7 - luks-encrypted lvm volume
    #

    # mount root+home partitions; replace /dev/nvme0n1p7 with the partition containing your linux install
    sudo cryptsetup luksOpen /dev/nvme0n1p7 my_encrypted_volume
    sudo mkdir -p /mnt/decrypted_drive
    sudo mount /dev/mapper/debian-root /mnt/decrypted_drive/
    sudo mount /dev/mapper/debian-home /mnt/decrypted_drive/home
    # mount boot partition; replace /dev/nvme0n1p6 with your boot partition (prob ext2 and 1gb)
    sudo mount /dev/nvme0n1p6 /mnt/decrypted_drive/boot
    # mount efi partition; replace with your efi partition (prob 100MB w label "EFI System")
    sudo mount /dev/nvme0n1p2 /mnt/decrypted_drive/boot/efi

    # mount virtual filesystems
    for i in /dev /dev/pts /proc /sys /sys/firmware/efi/efivars /run; do sudo mount -B $i /mnt/decrypted_drive$i; done

    sudo chroot /mnt/decrypted_drive
    sudo grub-install /dev/nvme0n1
    sudo update-grub

    # exit the chroot with ctrl+d
    
    # unmount everything
    sudo umount /mnt/decrypted_drive/boot/efi
    sudo umount /mnt/decrypted_drive/boot
    sudo umount /mnt/decrypted_drive/home
    sudo umount /mnt/decrypted_drive
    sudo cryptsetup luksClose debian-home
    sudo cryptsetup luksClose debian-swap
    sudo cryptsetup luksClose debian-root
    sudo cryptsetup luksClose my_encrypted_volume
    
    # NOTE: after rebooting, some drivers failed to load for me (like wifi). A second reboot fixed the issue.


