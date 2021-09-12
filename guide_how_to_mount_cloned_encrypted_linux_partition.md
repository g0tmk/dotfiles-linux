# How to mount an encrypted linux partition inside of a backup disk image.

- install required packages

    sudo apt install cryptsetup


- get partition layout

        sudo fdisk -lu bxpsd_full_drive_image_210711.img

        # will output this:
        Disk bxpsd_full_drive_image_210711.img: 476.94 GiB, 512110190592 bytes, 1000215216 sectors
        Units: sectors of 1 * 512 = 512 bytes
        Sector size (logical/physical): 512 bytes / 512 bytes
        I/O size (minimum/optimal): 512 bytes / 512 bytes
        Disklabel type: gpt
        Disk identifier: DEC48F07-28E9-4BB8-945B-522C925DAD7D

        Device                                 Start        End   Sectors   Size Type
        bxpsd_full_drive_image_210711.img1      2048     923647    921600   450M Windows recovery environment
        bxpsd_full_drive_image_210711.img2    923648    1128447    204800   100M EFI System
        bxpsd_full_drive_image_210711.img3   1128448    1161215     32768    16M Microsoft reserved
        bxpsd_full_drive_image_210711.img4   1161216  314120293 312959078 149.2G Microsoft basic data
        bxpsd_full_drive_image_210711.img5 314122240  315734015   1611776   787M Windows recovery environment
        bxpsd_full_drive_image_210711.img6 315736064  317689855   1953792   954M Linux filesystem
        bxpsd_full_drive_image_210711.img7 317689856 1000214527 682524672 325.5G Linux filesystem

- calculate the offset from the start of the image to the start of the partition

    sector size * start = (in this case) 512 * 317689856 = 162657206272
    
- mount on /dev/loop using the offset (i use loop27 because live images sometimes use the first 10 loop numbers)

        sudo losetup -o 162657206272 /dev/loop27 bxpsd_full_drive_image_210711.img

- now mount it as an encrypted drive with LUKS
- NOTE: if this partition were not encrypted, we could simply mount it now with `sudo mount -o ro /dev/loop27 /mnt/decrypted_drive`

        # decrypt
        sudo cryptsetup luksOpen /dev/loop27 my_encrypted_volume

- If you are on a system where the LVM volume group name is the same as the newly decrypted volume (very likely), then you will need to run these commands to mount the LV using a unique name. If not, skip to the "mount" command

        sudo vgscan; sudo lvdisplay

- check the output of the lvdisplay command and determine which volume you would like to mount. In my case, the correct volume has LVName:home and VGName:debian and has the lowest LVCreation time.
- rename the VG

        sudo vgimportclone -n debian_clone /dev/mapper/my_encrypted_volume
        sudo vgscan; sudo lvdisplay
        # should show the new VG name on each LV
        sudo vgchange --activate y debian_clone
        ls /dev/mapper
        # should list mapped partitions

- mount

        sudo mkdir /mnt/decrypted_drive
        # the name 'debian_clone-home' may differ, use `sudo fdisk -l` to list discovered decrypted partitions
        sudo mount -o ro /dev/mapper/debian_clone-home /mnt/decrypted_drive/
    
- done! after using the partition, be sure to unmount it

        sudo umount /mnt/decrypted_drive
        # unmap decrypted partitions (optional, partition names may differ - see `sudo fdisk -l`)
        sudo cryptsetup luksClose debian_clone-home
        sudo cryptsetup luksClose debian_clone-swap
        sudo cryptsetup luksClose debian_clone-root
        sudo cryptsetup luksClose my_encrypted_volume
        sudo losetup -d /dev/loop27

