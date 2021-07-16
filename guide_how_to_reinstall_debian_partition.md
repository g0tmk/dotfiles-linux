# How to reinstall / upgrade debian partition

- clone entire drive image to a usb hdd with ddrescue
- verify it works with the guide "guide_how_to_mount_cloned_encrypted_linux_partition.md"
- while the clone is open, copy a few files out that will help with the new install:

    mkdir dest
    cp ~/.ssh/id_rsa dest
    cp ~/.ssh/id_rsa.pub dest
    cp /etc/openvpn/client/*.ovpn dest
    cp /etc/openvpn/client/*.up dest
    cp /etc/fstab dest
    cp ~/.zsh_history dest

    # later, on the new install:
    mkdir -p ~/.ssh
    cp dest/id_rsa ~/.ssh
    cp dest/id_rsa.pub ~/.ssh
    cp dest/*.ovpn /etc/openvpn/client/
    cp dest/*.up /etc/openvpn/client/
    # double-check the permissions of the files in "/etc/openvpn/client/" are 600 root:root
    cat dest/.zsh_history > dest/combined_history
    cat ~/.zsh_history >> dest/combined_history
    mv dest/combined_history ~/.zsh_history
    less dest/fstab
    # look at old fstab and add entries as needed to /etc/fstab

## notes from 210713 (replaced debian 9 with fresh debian 10.10)
- enable secure boot in bios
- reboot, grub will probably fail and it will fall back on 'windows boot manager' which will boot windows 10
- check "system information" in windows and verify "secure boot mode" is enabled
- plug in debian 10.10 dvd image burned to usb drive (image inside ventoy mutiboot usb did not work)
- reboot, use F12 to boot to debian installer
- follow 'notes.txt'

