# Installing dual-boot Debian 10.10.0 Stable and Win10 (UEFI + Secure Boot) on Dell XPS 15 9550

- 1/1/2016 (approx): file created when installing Debian 8.6.0 Stable / Win10
- 4/3/2017 update: BIOS ver 1.2.21 released. Did not fix Windows sleep issues.
- 7/13/2021: updated guide during reinstall of debian partition with Debian 10.10 stable. Enabled secure boot.
- 7/13/2021 update: BIOS ver 1.14.0 released.

#### General notes on xps 9550
- Backlight power draw (need more samples, very variable. Samples taken with powertop 2.12)
  - 2.90 3.00 1.70 1.71 3.24 3.25 3.25 3.97 3.88 W at 100% brightness
  - 1.65 1.54 1.56 1.84 1.87 1.97 2.10 2.84 2.88 W at 90% brightness
  - 1.44 2.10 2.09 2.15 2.17 2.16 2.15 2.73 2.80 W at 80% brightness
  - 1.40 1.52 1.51 1.51 1.58 1.59 1.60 2.23 2.24 W at 70% brightness
  - 1.65 1.65 1.66 1.64 1.63 2.09 2.12 2.20 2.21 W at 60% brightness
  - 1.00 1.20 1.64 1.68 1.66 1.66 1.65 2.19 2.19 W at 50% brightness
  - 1.65 1.66 1.65 1.66 2.13 2.13 2.11 2.13 W at 40% brightness
  - 1.51 1.51 1.49 1.28 1.43 1.43 1.47 W at 30% brightness
  - 1.53 1.46 1.43 1.29 1.42 1.43 W at 20% brightness
  - 1.35 1.34 1.34 1.27 1.24 1.33 1.42 1.42 W at 10% brightness
  - 1.19 1.20 1.22 1.24 1.25 1.31 1.44 1.45 W at 0% brightness (actually 1/1500 or 0.07%)

## First, configure BIOS
- ACHI Mode: OFF
- Performance
  - C-state: OFF
- Virt. support: Disabled both
- Sys config
  - USB/Thunder
    - Always allow
    - Dell docks: uncheck
  - Drives
    - SATA0: uncheck
    - SATA1: uncheck
- Webcam: disabled
- Auto OS recovery threshold: OFF
- BIOS recover from HD & downgrade: both uncheck
- Fastboot: minimal
- Disable dell SupportAssist

## Next: Install Windows

#### Re-install windows to remove all crapware (taken/modified from https://www.reddit.com/r/Dell/comments/3sr1jh/windows_10_clean_install_guide/)
1.  Get yourself a USB flash drive with at least 8.0GB of storage space. I used a USB 3.0 flash drive, but any others should work fine.
2.  Create a Windows Recovery Media on your USB flash drive. To do this, download the [64-bit Media Creation Tool here]( http://www.microsoft.com/en-us/software-download/windows10) and save it to your desktop, for convenience. Run it --> choose "Create installation media for another PC" ; then click "Next" --> Choose your language, "Windows 10 Home", and "64-bit (x64)" Architecture ; then click "Next" --> select "USB flash drive" ; then click "Next" --> select your USB 3.0 flash drive ; then click "Next". The tool will then download and install the program on your USB. This will take a while, so get up and stretch your legs. Maybe do some cleaning, or use the time for **Step 3**. When the tool is done, it will show you a window that says "Your USB flash drive is ready". Click "Finish".
3.  Make sure to back up all your files that you need to an external drive of some sort, probably something other than USB flash drive with the Windows Recovery Media. Re-installing Windows 10 will completely erase your hard drive, so back up all those embarrassing snapshots of you at that Christmas party.
4.  After the Windows Recovery Media tool has completely finished in step #2, create a new folder on the flash drive and call it something like "Drivers" for convenience. The Media Creation tool may have renamed the flash drive "ESD-USB"
5.  Download the x64 version (currently called "f6flpy-x64.zip") of the [driver for the PCIe SSD here]( https://downloadcenter.intel.com/download/25165/Intel-Rapid-Storage-Technology-Intel-RST-RAID-Driver) and save it to the "Drivers" folder you just made on the flash drive. This is the driver for the XPS’s hard drive (storage).
6.  Unzip the the driver file within the "Drivers" folder you just created.
7.  Download the [driver for the WiFi module here]( http://www.dell.com/support/home/us/en/19/product-support/product/xps-13-9350-laptop/drivers) under the "Network" tab - it’s currently called "Dell Wireless 1820A WiFi Driver". Save it to the "Drivers" folder on the flash drive.
8.  Now comes the fun part. Keep the USB drive plugged in. We are going to boot from the USB flash drive. So - Restart your computer, but be prepared and press the f12 key over and over once you see the Dell logo appear. You can stop pressing f12 once you see the words "Preparing one-time boot menu" in the upper right corner of the screen. The boot menu will then launch.
9.  Once in the boot menu again, use the arrow key to navigate to where the USB is listed, and hit the Enter key to launch from the flash drive.
10. A window for the Windows 10 installer will pop up against a blue screen. If you have the QHD, 3200x1800 resolution screen model of the XPS 13 you better go get your reading glasses because the text will be small as shit.  Click "Install Now" <sup><sup>if you can see it ;P</sup></sup>.
11. Accept the software license agreement by and clicking the checkbox, then click "Next"
12. Of the two options now shown, click "Custom Install Windows only (advanced)".
13. If your computer is like mine, you should be greeted with a window that is searching for a hard drive to install Windows 10 to, but no hard drive will be listed. Click the icon/button that says "Load Driver"
14. There will be a popup window that says something like "To install the device driver…". You’ll now want to *Browse* the flash drive, find the "Drivers" folder, select the driver for the PCIe SSD you saved in the folder (it is probably the only thing listed). Click "Next".
15. I can’t remember if there are any intermediary popups or windows here, but just click "Ok" or "Next" through them until the driver starts installing. This will take a few minutes.
16. After the driver has been installed you will be brought back to the "Where do you want to install Windows" window. In the box that was empty before, there should now be several drive partitions listed. Select each partition and click the "Delete" icon/button. This will create a "Drive 1 Unallocated Space" partition in the box thing. Continue selecting all the other partitions that are not "Drive 1 Unallocated Space" and delete them. When you are done, there should only be the "Drive 1 Unallocated Space" with a size indicative of the SSD of your system (I have a 256GB SSD so had a "Drive 1 Unallocated Space" size of 238.5GB). 
17. Select the "Drive 1 Unallocated Space" and click "New". Leave the MB size the same (mine was 244197). Click "Apply", then on the next window click "OK", then click "Next". (Windows has created a special partition for itself, leave it be).
18. Windows 10 will now start reinstalling. This process took about 7 minutes for me. When done, you can choose or "Customize settings" (or whatever the button is) to set up Windows 10. Then there’s about another minute’s worth of waiting.
19. Congrats! You should now be back in a vanilla form of Windows 10 without any of that useless Dell bloatware! The next thing to do is to navigate to the "Drivers" folder and launch the .exe to install the driver for the Wifi module.
20. Once you are connected to your WiFi network, open Windows Update and install all the updates it finds. You may need to restart several times. After each restart, go back to Windows Update and "check for updates" again until it comes back with "Your device is up to date". **You may experience screen freezing after the computer restarts. This is a problem I am currently investigating.** If you don’t know how to access Windows Update, click the Start menu button and type "updates", for example. Then click the "Check for updates" option that appears from the search results to open the utility.  
21. This would be a good opportunity to *create a restore point*, in case something happens in the future. Type "restore" in the start menu to quickly find the program. 
22. In the System Properties window for the system restore click "Configure" --> select "Turn on system protection" --> set the slider to something like 5% --> click "Apply" --> back at the previous window click "Create" and name it something.
23. Reboot your computer, then go to the device manager and make sure all devices look OK. In my case, windows update seems to have taken care of all drivers. If not OK, head over to [Dell’s driver download page]( http://www.dell.com/support/home/us/en/19/product-support/product/xps-13-9350-laptop/drivers). Install drivers for any devices with a yellow (!) symbol.
24. You made it! This is all I have to offer now it terms of help. Windows is unable to sleep correctly on my XPS 9550, and I doubt it ever will. (It always wakes up with an unresponsive keyboard). There used to be screen freezing that I have not seen in a while so it may be fixed - it only occurs after the computer has been restarted, but doesn’t occur when the computer has been started from a completely off state. Happy XPS’ing!!!

#### Install some tools
 - GOW (GNU-on-windows) - a set of unix tools that takes up 10MB vs cygwin's 100MB ([link](https://github.com/bmatzelle/gow))
 - Chocolatey - package manager for windows ([link](https://chocolatey.org/install)). Then run these commands to install some apps:
 - `choco install 7zip`
 - `choco install autoruns`
 - `choco install cdburnerxp`
 - `choco install cpu-z`
 - `choco install crystaldiskmark`
 - `choco install defraggler`
 - `choco install dotnet4.5.1`
 - `choco install filezilla`
 - `choco install git`
 - `choco install googlechrome`
 - `choco install hashcheck`
 - `choco install libreoffice`
 - `choco install miktex`
 - `choco install nmap`
 - `choco install paint.net`
 - `choco install pdfcreator`
 - `choco install putty`
 - `choco install python`
 - `choco install qbittorrent`
 - `choco install sublimetext3`
 - `choco install sumatrapdf`
 - `choco install teamviewer`
 - `choco install tightvnc`
 - `choco install vcredist2013`
 - `choco install vim`
 - `choco install virtualbox.extensionpack`
 - `choco install virtualbox`
 - `choco install vlc`
 - `choco install windirstat`
 - `choco install xnview`
 - `choco install youtube-dl`

Install these too, but check online first as they are not moderated
 - `choco install hg`
 - `choco install synctrayzor`
Install these if you feel like it
 - `choco install cmder`
 - `choco install evernote`
 - `choco install tor-browser`
Install games if the comp can take it
 - `choco install steam`
 - manual install furmark
 - manual install kerbal space
 - manual install league of legends


#### Fix problems in windows
 - fix fastboot-related issues (keyboard and/or backlight not working after poweroff + poweron cycle):
   - Power Options -> Choose what the power buttons do -> Change settings that are currently unavailable
   - Uncheck 'Turn on fast startup (recommended)'

 - (NOT WORKING / need more testing) keyboard not working on resume (from http://www.tomsguide.com/answers/id-2636299/keyboard-working-sleep.html):
   - Power Options -> Change plan settings -> Change advanced power settings -> PCI Express -> Link State Power Management
     - On battery: Off
     - Plugged in: Off


#### Notes for windows:
 - Find newest file(s) in directory (requires GOW):
   - `gfind . -type f -printf "%T@ %p\n" | gsort -n`


## Prepare BIOS for linux
 - Configure SATA controller by rebooting into BIOS (F12 at boot DELL logo)
 - Set SATA operation to DISABLED (not AHCI or SATA)
 - Now windows is broken and won't boot anymore. Next, lets fix that in the "Fix broken windows boot" section


## Fix broken windows boot:
 - Reboot... bluescreen (BOOT_DISK_ERROR or something similar)
 - Reboot... another bluescreen (BOOT_DISK_ERROR or something similar)
 - Reboot... another bluescreen (BOOT_DISK_ERROR or something similar)
 - Reboot... should say "It looks like windows didn't load correctly" and drop you into Advanced Startup
 - In Advanced startup, hit "Troubleshoot", then "Advanced Options", then "Startup Settings", then "Restart"
 - After restart, it will present 9 boot options. Pick option 4/5 (I used 5) to boot into safe mode.
 - System will now boot into safe mode and land you at the login screen. I logged in and waited at the desktop for ~30 seconds just in case.
 - Reboot, windows should boot fine from now on. (FYI, I have not experienced any Windows crashes/issues since, booting into safe mode was an adequate fix. However, some users online report occasional crashes after this step


## Prepare the SSD freespace for linux:
 - fix any disk errors
   - Run checkdisk just in case (In windows, open cmd prompt as admin, run `chkdsk C: /F`) 
   - In my case, this scheduled a disk check on the next boot. Reboot to start the check.
 - shrink windows partition
   - Go to Computer Managenent->Disk Management, right-click your Windows partition (probably C:), hit 'shrink volume'
   - Enter a shrink size based on how large you want your linux partition(s)
   - In my case, I couldn't enter a value that was as large as I wanted. This is because it can't shrink past so-called 'unmovable files'. If this happens to you, you have a few options:
     - Use gparted on a liveUSB to resize the partition
     - Use some boot-time defrag software to consolidate all the data to the front of the drive.
     - Figure out what file is causing the problem (i did this, so I have instructions for it).
       1. Download Defraggler portable (https://www.piriform.com/defraggler/download/portable), run it.
       2. Hit analyze, select the file out in the middle of the drive.
       3. If it's the System Volume Information, then follow these steps to disable it. If not, google how to remove your particular file.
       4. Disable System Protection: Win+R and type SystemPropertiesProtection.exe, press Enter.
       5. Hit configure, disable, apply
       6. Back in Defraggler, if you hit Analyze, the file should be gone.
       7. Shrink your partition.
       8. Re-enable System Protection.



## Install Debian
 - Create your linux install USB. I picked Debian 10.10 stable.
   - Reccomended to use a full install image (one labeled CD1 or DVD1, not netinstall) so you don't have to worry about wifi drivers just yet.
   - (optional; I skipped this) - If you want wifi, follow a guide like [this](https://www.linux.com/training-tutorials/how-install-firmware-debian-enable-wireless-video-or-sound/) and add the intel wireless firmware (or other device firmware) to a separate USB drive first.
 - Boot to the USB, I picked "graphical install"
 - Verify Debian booted into UEFI mode: Use alternate TTY (Ctrl+Alt+F2) to check if /etc/firmware/efi folder exists. You can also check dmesg for a message like "efi: EFI v2.40 by American Megatrends..."
 - Verify Debian booted with Secure boot enabled by checking dmesg for a message like "secureboot: Secure boot enabled"
 - Go back to install (Ctrl+Alt+F5)
 - Setting up encrypted LVM: (instructions from https://forums.kali.org/showthread.php?22237-(Guide)-Dual-boot-Windows-and-Encrypted-Kali-1-08-LVM-Install)
   - when you get to the Partition Disks section, choose manual install. 
     - NOTE: if reinstalling, here you should delete the old 1.0GB boot partition and delete the 349.5GB partition after it
   - Select free space, choose 'create new partition', 1GB (overkill), beginning, Use As: 'ext2', Mount point: /boot, Label: boot, Done setting up partiton.
   - Select 'Configure encrypted volumes', yes, 'Create encrypted volumes', fill checkbox next to free space, hit Continue.
   - Select 'Done setting up partition', yes, Done, Finish
   - Select 'Yes' to erase free space on the drive. My SSD took ~18 mins to overwrite the 330GB partition.
   - Select 'Configure the Logical Volume Manager', yes, 'Create Volume Group', enter 'debian', select encrypted volume (/dev/mapper/xxxx), yes
   - Select 'Create Logical Volume', select 'debian', enter 'swap' as new name, 20GB (reccomended for 16gb ram with hibernation enabled, but change if needed), use 'swap' as new name
   - Select 'Create Logical Volume', select 'debian', enter 'root' as new name, 50GB (or whatever)
   - Select 'Create Logical Volume', select 'debian', enter 'home' as new name, remaining
   - Select Finish
   - Set mount points:
     - Select #1 under LVM VC debian LV home; Use as: Ext4, Mount point: /home, Done
     - Select #1 under LVM VC debian LV root; Use as: Ext4, Mount point: /, Done
     - Select #1 under LVM VC debian LV swap; Use as: swap area, Done
   - At bottom of Partition Disks screen, hit 'Finish partitioning and write changes to disk', confirm
 - Finish up the install normally. when choosing what software to install, only select:
   - Debian desktop environment
     - NOTE: This will install gnome 3 - this is optional as later steps will install xmonad anyways. But I tried this method for my Debian 10 install.
   - print server
   - standard system utilities
 - If you get a message that says 'An installation step failed: Install the GRUB boot loader on a hard disk', then follow these steps: (from http://unix.stackexchange.com/questions/280440/grub-and-lilo-both-fail-to-install-to-nvme-hard-disk-when-installing-debian)
   1. At the installation stage where GRUB fails to install, Use alternate TTY (Ctrl+Alt+F2) and run the following commands:

        ```
        mount --bind /dev /target/dev
        mount --bind /dev/pts /target/dev/pts
        mount --bind /proc /target/proc
        mount --bind /sys /target/sys
        cp /etc/resolv.conf /target/etc # not needed
        chroot /target /bin/bash
        aptitude update # not needed
        aptitude install grub-efi-amd64
        update-grub
        grub-install --target=x86_64-efi /dev/nvme0n1
        ```

   2. Go back to install (Ctrl+Alt+F5) and select "Continue without installing a bootloader." 
   3. Once the installation completes, re-boot into debian. Add "nvme" to /etc/initramfs-tools/modules, then run update-initramfs -u as root.
 - If Windows is not present in GRUB menu, boot into debian and run 'update-grub'
 - At this point, I re-booted into debian twice to make sure I didn't have the boot issues referenced in http://unix.stackexchange.com/questions/280440/grub-and-lilo-both-fail-to-install-to-nvme-hard-disk-when-installing-debian.


## Fix WIFI (for intel wireless NICs)
   - obtain the intel firmware package (firmware-iwlwifi) on another pc and put on usb drive. Latest version at time of writing was firmware-iwlwifi_20190114-2_all.deb
   - boot; run `sudo dpkg -i firmware-iwlwifi_20190114-2_all.deb`; reboot. Wifi should be 


## Fix WIFI (for broadcom wireless NICs)
 - dpkg -i firmware-brcm80211_0.43_all.deb, rebooted: no effect.
 - dpkg -i firmware-linux-nonfree_0.43_all.deb, rebooted: no effect.
 - dpkg -i libnl-3-200_3.2.24-2_amd64.deb, dpkg -i libnl-genl-3-200_3.2.24-2_amd64.deb, dpkg -i iw_3.17-1_amd64.deb, rebooted: no effect.
 - cp brcmfmac43602-pcie.bin /lib/firmware/brcm/; rebooted: no effect
 - Doh, need to upgrade kernel: (slight nodifications from http://unix.stackexchange.com/questions/27100/how-to-install-kernel-on-debian-with-no-internet-connection)
   - On a debian install with internet:
     1. Add backports to /etc/apt/sources.list: deb http://mirror.one.com/debian/ jessie-backports main contrib non-free
     1. run `apt-get update`
     2. run `apt-get install -qq --reinstall --print-urls -t jessie-backports linux-image linux-image-amd64`
     3. The download urls (3 of them for me) will print to screen, manually download them and stick on a USB drive.
   - Go back to the XPS, add backports to /etc/apt/sources.list before we forget (deb http://mirror.one.com/debian/ jessie-backports main contrib non-free)
   - Plug in the usb drive, go to the folder, run sudo dpkg -i *.deb to install the kernel.
   - Reboot
   - In my case, wifi is still not working. `dmesg | grep firmware` reports "failed to load firmware brcm/brcmfmac43602-pcie.txt"
     - add brcmfmac to /etc/modules, reboot: works!


## Config wifi
   - Try running `wicd-curses` and configure all network settings there. If that does not work correctly, try the following steps to configure manually:
   - useful commands: (from https://wireless.wiki.kernel.org/en/users/documentation/iw)
     - enable: `sudo ip link set wlan0 up`
     - scan for networks: `sudo iw dev wlan0 scan | less`
     - wifi status: `sudo iw dev wlan0 link`
   - connect to a wpa2-psk network: (from https://wiki.debian.org/WiFi/HowToUse#WPA-PSK_and_WPA2-PSK)
     - add wpa2 support
       - `sudo dpkg -i libpcsclite1_1.8.13-1_amd64.deb` (wpasupplicant dependency)
       - `sudo dpkg -i wpasupplicant_2.3-1+deb8u4_amd64.deb`
     - `chmod 0600 /etc/network/interfaces` (prevents psk leaks if you're going to store them there)
     - run `sudo iw dev wlan0 scan | less`, we care about SSID / freq / and RSN (commonly referred to as WPA2)
     - connect to network
       - `sudo -s` (opens a root shell)
       - `wpa_passphrase "SSID_NAME"`, type passphrase when prompted
       - copy the psk=XXXX line from the output
       - open /etc/network/interfaces, add entry like the following (this is an example)
           ```
           # start WIFI at boot
           auto wlan0
           iface wlan0 inet dhcp
                   wpa-ssid myssid
                   wpa-psk ccb290fd4fe6b22935cbae31449e050edd02ad44627b16ce0151668f5f53c01b
            ```
       - run `exit` to drop out of root shell
       - `sudo ip link set wlan0 down`
       - `sudo ip link set wlan0 up`
       - `sudo ifup wlan0`
       - WIFI is connected!


## (Optional / skipped for Debian 10) disable bluetooth to help with battery:
[NOTE: disabling more kernel modules may help, but btusb was reported as a problem with iotop. For example, the bluetooth module is still installed/loaded]
- `sudo touch /etc/modprobe.d/btusb.conf`
- `echo 'blacklist btusb' >> /etc/modprobe.d/btusb.conf`


## continue to README.md for debian setup notes
