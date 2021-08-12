# How to reinstall / upgrade debian partition

- get data out of programs that are difficult to extract from an image:
  - firefox: export bookmarks
  - sublime text: save all open but unsaved files
- clone entire drive image to a usb hdd with ddrescue
- verify it works with the guide "guide_how_to_mount_cloned_encrypted_linux_partition.md"
- while the clone is open, copy a few files out that will help with the new install:

    ```bash
    # assumes the decrypted backup image partitions are mounted to /mnt/clonedrive_*
    mkdir dest
    cp /mnt/clonedrive_home/g0tmk/.ssh/id_rsa dest
    cp /mnt/clonedrive_home/g0tmk/.ssh/id_rsa.pub dest
    cp /mnt/clonedrive_home/g0tmk/.zsh_history dest
    sudo cp /mnt/clonedrive_root/etc/openvpn/client/*.ovpn dest
    sudo cp /mnt/clonedrive_root/etc/openvpn/client/*.up dest
    sudo cp /mnt/clonedrive_root/etc/fstab dest
    sudo cp /mnt/clonedrive_root/etc/hosts dest

    # later, on the new install:
    mkdir -p ~/.ssh
    cp dest/id_rsa ~/.ssh
    cp dest/id_rsa.pub ~/.ssh
    sudo mkdir -p /etc/openvpn/client/
    sudo cp dest/*.ovpn /etc/openvpn/client/
    sudo chmod 600 /etc/openvpn/client/*.ovpn
    sudo chown root:root /etc/openvpn/client/*.ovpn
    sudo cp dest/*.up /etc/openvpn/client/
    sudo chmod 600 /etc/openvpn/client/*.up
    sudo chown root:root /etc/openvpn/client/*.up
    cat dest/.zsh_history > dest/combined_history
    cat ~/.zsh_history >> dest/combined_history
    mv dest/combined_history ~/.zsh_history
    less dest/fstab
    # look at old fstab and add entries as needed to /etc/fstab
    less dest/hosts
    # look at old hosts file and add entries as needed to /etc/hosts
    ```

## notes from 210713 (replaced debian 9 with fresh debian 10.10)
- enable secure boot in bios
- reboot, grub will probably fail and it will fall back on 'windows boot manager' which will boot windows 10
- check "system information" in windows and verify "secure boot mode" is enabled
- plug in debian 10.10 dvd image burned to usb drive (image inside ventoy mutiboot usb did not work because of secure boot)
- reboot, use F12 to boot to debian installer
- follow 'notes.txt'

