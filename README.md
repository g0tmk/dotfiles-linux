## g0tmk's dotfiles

#### Useful resources
 - Dell XPS 15 (9550)
   - [XPS 15 Service Manual](http://topics-cdn.dell.com/pdf/xps-15-9550-laptop_Service-Manual_en-us.pdf)
   - [Notes about installing a Debian Stretch on a Dell XPS 15](http://wiki.yobi.be/wiki/Laptop_Dell_XPS_15)
   - [Dell XPS 15 - ArchWiki](https://wiki.archlinux.org/index.php/Dell_XPS_15)
   - [Dell XPS 15 9550 - ArchWiki](https://wiki.archlinux.org/index.php/Dell_XPS_15_(9550))
   - 2015-09-11 [Ubuntu 15.10 on Dell XPS 15 9550](https://ubuntuforums.org/showthread.php?t=2301071&p=13382949#post13382949)
   - 2016-01-13 [Arch on XPS 15 (late 2015)](https://bbs.archlinux.org/viewtopic.php?id=204739)
   - 2016-05-16 [Ubuntu 16.04 on Dell XPS 15 9550](https://ubuntuforums.org/showthread.php?t=2317843)
   - 2017-12-01 [Installing Kali Linux on a Dell XPS 9550](https://www.rafaelhart.com/2017/12/installing-kali-linux-on-a-dell-xps-9550/)

#### Custom commands
 - `barrier` starts barrier to allow control from another computer's keyboard/mouse
 - `battery` shows battery stats
 - `brightness [set | increase | decrease] percent` to set backlight levels
 - `clipboard` to handle terminal I/O (`ls | clipboard` or `clipboard > pasted.txt`)
 - `colortable` shows all terminal color text/background combinations and their codes
 - `colortable256` shows all 256 terminal colors
 - `pc` runs a python-compatible cli calculator
 - `qrcode` to display text from the terminal as a qrcode
 - `remap` applies keyboard remappings. sometimes needed after a wake from suspend
 - `setup_external_monitor` to handle enabling/disabling of secondary monitors
 - `show_osd_message "message"` shows a message onscreen. Used for shortcut feedback
 - `ssht` to connect to ssh clients and auto-tmux
 - `start_syncthing` starts the syncthing user service
 - `time_shell_command` runs a shell command 1000 times and shows its average runtime
 - `volume [set | increase | decrease] percent` or `volume toggle` to set volume
 - some more niche ones
   - `desktop_log` outputs a list of system issues/things that need action. used by conky
   - `dwarf_fortress` to launch dwarf fortress with some basic command line options
   - `game_on_bpc` to wake up my desktop and log in remotely via parsec once it is up
   - `wake_bpc` tells the router to send a WoL packet to my desktop. used by game_on_bpc
   - `parsec` starts parsecd correctly (killing it first if running). used by game_on_bpc
   - `parsec-browser` is the same as above, but also opens a browser to config if needed
   - `garbage` shows files in home directory that I can probably delete
   - `generate-tray-padding` is used by xmobar to detect trayer size
   - `hostname_colorized` generates a different colored name per-host. used in terminal PS1
   - `xmobar_battery.py` is used by xmobar to show battery info
   - `xmobar_wireless.py` is used by xmobar to show wireless info
   - `umount_cifs_lazy` will unmount a cifs mount regardless of its state (ie timed out)

#### Install steps on a fresh Debian (Stable) machine

0. Install Debian minimal system, install only "Standard System Utilities"

0. Install base software

    ```bash
    # Install the absolute minimum manually
    sudo apt update
    sudo apt install git apt-transport-https
    sudo sed -i 's/http:/https:/g' /etc/apt/sources.list

    # Install apps and link dotfiles. See install.sh for details.
    git clone git://github.com/g0tmk/dotfiles-linux.git ~/dotfiles
    cd ~/dotfiles
    ./install.sh
    ```

0. Configure sound (optional)

    - Run `alsamixer` 
    - Hit F6 and select sound card (probably "HDA Intel PCH")
    - set all channels to 0db. Unmute channels with 'm'. I left all muted except
      "Master" and "Speaker". ("OO" is enabled, "MM" is muted).

0. Reverse touchpad scroll direction + enable tap-to-click

    - First, check if this is needed for you. Scroll with your touchpad and if the
      direction is fine (and you don't care about tapping), skip this section.
    - Run `xinput --list` to see all input devices. On the xps9550 I saw two touchpads,
      "DLL06E4:01 06CB:7A13 Touchpad" and "SynPS/2 Synaptics TouchPad". I just ignored
      the synaptics one. 
    - Run `xinput --list-props "<device name>"`, you should see many lines starting
      with "libinput". If they start with "Synaptics" instead, run this to switch to
      libinput:

    ```bash
    sudo mkdir /etc/X11/xorg.conf.d
    # force libinput instead of synaptics by copying the default config to /etc
    # not sure why this is needed, but on the xps9550 it used synaptics occasionally
    sudo cp /usr/share/X11/xorg.conf.d/40-libinput.conf /etc/X11/xorg.conf.d/40-libinput.conf
    ```

    - Run these commands to configure libinput:

    ```bash
    sudo mkdir /etc/X11/xorg.conf.d
    sudo vi /etc/X11/xorg.conf.d/50-touchpad-custom.conf
    # add the following:
    ```

    ```
    Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"

        Option "Tapping" "True"
        Option "TappingDrag" "True"
        Option "Natural Scrolling" "True"
    EndSection
    ```

0. Setup brightness control (not needed on x220). Add to /etc/sudoers with `sudo visudo`:

    - First try brightness controls (Fn+F11 on xps9550). If it works, skip this section.

    ```bash
    Cmnd_Alias    PLUS = /home/<your_username>/bin/brightness
    <your_username> ALL = NOPASSWD: PLUS
    # try brightness controls (Fn+F11 on xps9550)
    ```

0. Allow power commands without sudo password. Add to /etc/sudoers with `sudo visudo`:

    ```bash
    Cmnd_Alias    POWERCMDS = /sbin/shutdown, /sbin/reboot
    <your_username> ALL = NOPASSWD: POWERCMDS
    ```

0. Install pywal to enable colorschemes based on the wallpaper

    ```bash
    pip3 install --user pywal
    # install extra backends (optional)
    pip3 install --user haishoku colorthief colorz

    ```

0. Enable sensors (xps9550 only)

    - First run `sensors`. If you see fan RPMs, skip this section.

    ```bash
    # verify dell kernel module is present:
    modinfo dell-smm-hwmon | grep '^description'
    # temporarily enable module; ignore_dmi because xps9550 is not a supported system (works anyways)
    modprobe dell-smm-hwmon ignore_dmi=1
    # verify module is running (you should see "dell_smm_hwmon: vendor=Dell Inc., ..."
    sudo dmesg | grep dell_smm_hwmon
    # verify new sensors are visible (you should see fan RPMs now)
    sudo sensors
    # make ignore_dmi=1 permanent:
    sudo bash -c "echo 'options dell-smm-hwmon ignore_dmi=1' >> /etc/modprobe.d/dell.conf"
    # configure module to load at boot:
    sudo bash -c "echo 'dell_smm_hwmon' >> /etc/modules-load.d/dell_smm_hwmon.conf"
    # tell lm_sensors to load the new module
    sudo mkdir -p /etc/lm_sensors/conf.d
    sudo bash -c "echo 'HWMON_MODULES=\"coretemp dell-smm-hwmon\"' >> /etc/lm_sensors/conf.d/dell"
    # probably a good idea to reboot and verify `sudo sensors` still shows fan RPMs
    # probably ALSO a good idea to run sensors-detect afterwards, not sure if it is necessary
    ```

0. Set grub for short (2 second) timeout and less blinding colorscheme

    - Edit /etc/default/grub:
      - change GRUB_TIMEOUT to 2
    - Edit /boot/grub/custom.cfg and add the following lines:

    ```bash
    # colors: https://help.ubuntu.com/community/Grub2/Displays#GRUB_2_Colors
    # normal foreground and background terminal colors
    set color_normal=light-gray/black
    # highlight foreground and background terminal colors
    set color_highlight=light-blue/black
    # the foreground and background colors to be used for non-highlighted menu entries
    set menu_color_normal=light-gray/black
    # the foreground and background colors to be used for the highlighted menu entry
    set menu_color_highlight=yellow/black
    ```

    - Run `sudo update-grub` to commit changes

0. Quiet boot errors. Probably only useful on xps955 since it has such buggy bios firmware (AE_NOT_FOUND errors)
    - Might want to run the system for a week or so before doing this so you have a chance to see intermittent errors.
    - Note you can always run `journalctl -b -p warning` and `journalctl -b -p err` to check for issues

    ```bash
    sudo vi /etc/default/grub
    # edit GRUB_CMDLINE_LINUX_DEFAULT and add `loglevel=3` to the end
    # ie         GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3"
    ```

    - Run `sudo update-grub` to commit changes

0. Install Powertop to monitor/maximize battery life (laptop only) (check for latest version [here](https://01.org/powertop))

    ```bash
    sudo apt install libnl-3-dev libnl-genl-3-dev gettext libgettextpo-dev autopoint libncurses5-dev libncursesw5-dev libtool-bin dh-autoreconf
    wget https://01.org/sites/default/files/downloads//powertop-v2.10.tar.gz
    tar xvf powertop-v2.10.tar.gz
    cd powertop-v2.10
    ./autogen.sh
    ./configure
    make
    sudo make install
    # you can now run `sudo powertop`
    ```

0. Install tlp for decent power management (laptop only) from guide [here](https://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html#installation)

    - Option 1: install from backports. This is the easiest way to get a fairly recent
      version - but see option 2 for xps9550.

    ```bash
    sudo bash -c "echo 'deb https://deb.debian.org/debian stretch-backports main' >> /etc/apt/sources.list"
    sudo apt update
    sudo apt-get install -t stretch-backports tlp tlp-rdw 
    sudo vi /etc/default/tlp
    sudo tlp start
    # make sure tlp is running
    sudo tlp-stat -s
    ```

    - Option 2: install latest tarball from github. Necessary for XPS9550/60 since it has
      a BIOS bug that was worked-around in TLP 1.2 (<3 you linrunner) see [here](https://github.com/linrunner/TLP/issues/362)

    ```bash
    # notes here https://linrunner.de/en/tlp/docs/tlp-faq.html#install-config
    # and more here https://linrunner.de/en/tlp/docs/tlp-developer-documentation.html

    sudo apt install smartmontools network-manager
    cd /tmp
    # check for the latest version first
    wget https://github.com/linrunner/TLP/archive/1.2.2.tar.gz
    tar xvf 1.2.2.tar.gz
    cd TLP-1.2.2/

    # install (as root)
    sudo make install TLP_WITH_SYSTEMD=1
    sudo make install-man
    sudo make install-man-rdw

    # Enable the services, i.e. (as root)
    sudo systemctl enable tlp.service
    sudo systemctl enable tlp-sleep.service 
    sudo systemctl mask systemd-rfkill.service
    sudo systemctl mask systemd-rfkill.socket
    sudo tlp start
    # make sure tlp is running
    sudo tlp-stat -s
    ```

0. Setup Thermald to help with thermals (Intel only, probably only useful on laptops)

    ```bash
    # Check for the latest version in github releases first
    # Uses install instructions for ubuntu in README.txt in release:
    cd /tmp
    wget https://github.com/intel/thermal_daemon/archive/v1.8.tar.gz
    tar xvf v1.8.tar.gz
    cd thermal_daemon-1.8
    sudo apt install autoconf g++ libglib2.0-dev libdbus-1-dev libdbus-glib-1-dev libxml2-dev
    ./autogen.sh
    ./configure prefix=/usr
    make
    sudo make install
    sudo systemctl enable --now thermald.service
    sudo systemctl status thermald.service
    ```

0. Install virtualbox

    - Original guide [here](https://wiki.debian.org/VirtualBox#Debian_9_.22Stretch.22))
    - Info on integration with tiling WM [here](http://kissmyarch.blogspot.com/2012/01/hiding-menu-and-statusbar-of-virtualbox.html)

    ```bash
    # install virtualbox using their apt source:
    echo "deb https://download.virtualbox.org/virtualbox/debian stretch contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
    wget -q -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add
    sudo apt update
    sudo apt search virtualbox | grep ^virtualbox  # install the newest available
    sudo apt install virtualbox-6.x

    # you can now run `virtualbox`
    # NOTE: On first run it will prompt to install an extension pack. This will probably
    #       fail unless you run virtualbox with sudo. Once installed, you can run it
    #       normally again (without sudo).

    # configure virtualbox to allow tiling WM hotkeys
    # see https://askubuntu.com/questions/144905/virtualbox-windows-key-pass-through-to-gnome
    # - in VirtualBox go to File->Preferences
    # - Under "Input" uncheck "Auto Capture Keyboard"
    # - (Optional) View -> Status Bar -> Hide
    # - (Optional, show with Host+Home) View -> Menu Bar -> Hide
    ```

0. Install sublime text & sublime merge (from [here](https://www.sublimetext.com/docs/3/linux_repositories.html))

    ```bash
    # install using their apt source:
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    wget -q -O- https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add
    sudo apt update
    sudo apt install sublime-text sublime-merge
    # you can now run `subl` and `smerge`
    ```

0. Install firefox stable (from [here](https://wiki.debian.org/Firefox#Firefox_Stable.2C_Beta_and_Nightly))

    - Note: If you don't care about having the most modern firefox, skip all this and
      run `sudo apt install firefox-esr` instead.

    ```bash
    # download firefox from website and extract to a directory in home:
    # TODO: this doesn't work but should: wget https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US
    wget https://download-installer.cdn.mozilla.net/pub/firefox/releases/66.0.5/linux-x86_64/en-US/firefox-66.0.5.tar.bz2
    mkdir ~/bin ~/.mozilla
    tar -xf ./firefox* -C ~/.mozilla
    ln -s ~/.mozilla/firefox/firefox ~/bin/firefox
    sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser ~/bin/firefox 200
    # you can now run `firefox`
    ```

0. Install barrier (instructions from [here](https://github.com/debauchee/barrier/releases/tag/v2.1.2))

    ```bash
    sudo apt install flatpak
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install --user flathub com.github.debauchee.barrier
    barrier
    ```

    - In GUI:
      - Barrier > Change Settings > Set Screen Name
      - Barrier > Change Settings > Check "Minimize to System Tray"
      - Barrier > Change Settings > Check "Hide on Startup"
      - Barrier > Change Settings > Port: 25827
      - Barrier > Change Settings > Check "Enable SSL"
      - In main window, Client section, Check "Client" mode
      - In main window, Client section, type Server IP
      - Barrier > Save Configuration
    - For some reason, barrier hangs for me when I run "Save Configuration", so if that
      happens run `sudo killall barrier` here. Otherwise just close it normally.
    - Add server IP to config manually because it doesn't stick when set in GUI:
      - `vi ~/.var/app/com.github.debauchee.barrier/config/Debauchee/Barrier.conf`
      - Add IP of server after "serverHostname="
      - Save and exit
    - Run `barrier` again - this time, the window will not appear but it should
      immediately connect to the server and the icon will show up in the taskbar.

0. Install discord

    ```bash
    # Download latest deb from https://discordapp.com/download
    wget https://dl.discordapp.net/apps/linux/0.0.9/discord-0.0.9.deb
    sudo dpkg -i discord-0.0.9.deb
    sudo apt install -f
    # you can now run `discord`
    ```

0. Install Parsec

    ```bash
    # Download latest 'parsec for ubuntu' from parsecs site
    # NOTE: it segfaulted the first (and maybe second) time I ran it - eventually it became stable /shrug
    sudo dpkg -i parsec-linux.deb
    # you can now run `parsec` (a launcher in ~/bin/)
    ```

0. Setup dwarf fortress

    ```bash
    # Install requirements (listed here http://dwarffortresswiki.org/index.php/DF2014:Installation)
    sudo dpkg --add-architecture i386
    sudo apt install libgtk2.0-0 libsdl1.2debian libsdl-image1.2 libglu1-mesa libopenal1 libsdl-ttf2.0-0
    # Download latest version from [here](http://www.bay12games.com/dwarves/)
    wget http://www.bay12games.com/dwarves/df_44_12_linux.tar.bz2
    tar xf df_*
    # you can now run `dwarf_fortress --large` (a launcher in ~/bin/)
    # TODO: include tilesets in repo
    # TODO: symlink df_linux/data/saves into syncthing
    # TODO: include instructions for adding dfhack (download latest version, extract over df_linux)
    ```

0. Install syncthing [from guide here](https://apt.syncthing.net/)

    ```bash
    # Add the release PGP keys:
    curl -s https://syncthing.net/release-key.txt | sudo apt-key add -

    # Add the "stable" channel to your APT sources:
    echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

    # Update and install syncthing:
    sudo apt-get update
    sudo apt-get install syncthing
    # you can now run `start_syncthing` (a launcher in ~/bin/)
    ```

0. Install picom, yshui's compton fork [github](https://github.com/yshui/picom)

    - NOTE: This branch of compton is much newer, and actually maintained, but may have
      bugs. If you are not interested in helping develop compton, simply run
      `sudo apt install compton` to get the (4+yr old) mainstream version. If you use
      the mainstream version you will likely need to modify .xsessionrc.
      Another option is to install a recent release from yshui's github (v6.2 when this
      was written).
    - NOTE: during the "ninja -C build" step, I got an error like "FAILED: needed xcb-render ['>=1.12.0'] found 1.12"
      To fix, edit src/meson.build and change this: "'>=1.12.0'" with this: "'>=1.12'"

    ```bash
    # from guide in README.md
    sudo apt install meson ninja-build libx11-dev libx11-xcb-dev libxext-dev x11proto-core-dev xcb libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libxdg-basedir-dev libpcre2-dev libev-dev uthash-dev
    cd ~/repos
    git clone https://github.com/yshui/picom.git
    cd picom
    git submodule update --init --recursive
    meson --buildtype=release . build
    ninja -C build
    sudo ninja -C build install
    ```

0. Setup Franz (messenger)

    - Download .deb from [here](https://www.meetfranz.com/download?platform=linux&type=deb)
    - `sudo dpkg -i file.deb`
    - you can now run `franz`

0. Setup Dell Command | Configure (Dell hardware only)

    - This allows for control over some BIOS settings from the OS, ie keyboard
      backlight timeout.
    - Check for latest version [here](https://www.dell.com/support/article/us/en/04/sln311302/dell-command-configure?lang=en)

    ```bash
    cd /tmp
    wget https://downloads.dell.com/FOLDER05519670M/1/command-configure_4.2.0-553.ubuntu16_amd64.tar.gz
    tar xvf command-configure_4.2.0-553.ubuntu16_amd64.tar.gz
    sudo dpkg -i srvadmin-hapi_9.3.0_amd64.deb
    sudo dpkg -i command-configure_4.2.0-553.ubuntu16_amd64.deb
    # NOTE: the cctk application only works after a fresh boot, not wake-from-sleep. If
    #       you get a "Error communicating with BIOS..." error, reboot and try again.
    sudo /opt/dell/dcc/cctk
    
    # configure some settings (customize to your preferences)

    # set battery to sit between 50-70%
    sudo /opt/dell/dcc/cctk --PrimaryBattChargeCfg=Custom:50-70
    sudo /opt/dell/dcc/cctk --Camera=Disabled

    # charge up battery if you want 100% capacity for something
    sudo /opt/dell/dcc/cctk --PrimaryBattChargeCfg=Express

    # how to remove:
    sudo apt remove command-configure srvadmin-hapi
    ```

    - Options which work on the xps9550:

    ```bash
    --AdvBatteryChargeCfg
    --Camera [Enabled,Disabled]
    --Microphone [Enabled,Disabled]
    --PrimaryBattChargeCfg [Standard, Express, PrimAcUse, Adaptive, Custom:<percent>-<percent>]
            Default: Adaptive
    ```

0. Install OpenVPN client and configure a VPN

    ```bash
    # For proXPN, Download config files from http://www.proxpn.com/updater/locations.html
    # check connectivity to server first, if desired
    nc -vu <public_ip_address> 443
    sudo apt install openvpn
    sudo cp myconfigfile.ovpn /etc/openvpn/client/ 
    sudo chmod go-rwx /etc/openvpn/client/myconfigfile.ovpn
    sudo openvpn --client --config /etc/openvpn/client/myconfigfile.ovpn 
    # should output a lot of text ending with "Initialization Sequence Completed"

    # test connectivity by pinging the VPN server's gateway IP
    ping 10.8.0.1
    # verify route through VPN server exists
    ip route
    # verify this outputs the public IP of the VPN server
    dig TXT +short o-o.myaddr.l.google.com @ns1.google.com 
    ```

0. Install pptp client to connect to pptp VPNs

    - [Debian setup guide](http://pptpclient.sourceforge.net/howto-debian.phtml)
    - [Arch setup guide](https://wiki.archlinux.org/index.php/PPTP_Client)

    ```bash
    sudo apt install pptp-linux
    sudo pptpsetup --create my_tunnel --server vpn.example.com --username alice --password foo --encrypt
    # test the new connection - it will not exit. If there are no errors, great! To
    # fully test, you will also need to run the route command that follows.
    sudo pon my_tunnel debug dump logfd 2 nodetach
    # add a route to access devices on the VPN network (change the IP to match)
    sudo ip route add 192.168.10.0/24 dev ppp0
    # start the connection normally
    sudo pon my_tunnel

    # later, if you want to delete the connection:
    sudo pptpsetup --delete my_tunnel
    ```

0. Firmware update manager [not working yet]

    ```bash
    sudo apt install fwupd
    # show candidate devices
    fwupdmgr get-devices
    # pull latest metadata from lvfs
    fwupdmgr refresh
    >>> Failed to download
    sudo apt remove fwupd

    # need to try latest version (https://github.com/hughsie/fwupd)
    ```

0. Install PyCharm + CLion

    - Download the latest version of JetBrains Toolbox from [here](https://www.jetbrains.com/toolbox/app/).

    ```bash
    tar xvf jetbrains-toolbox-1.15.5387.tar.gz
    cd jetbrains-toolbox-1.15.5387
    ./jetbrains-toolbox
    # Click icon in the top-right and log in (if you care about syncing the IDEs settings)
    # Scroll down to "PyCharm Community" and click Install.
    # (Optional) you can install other jetbrains software (like CLion or IntelliJ) at this time

    # Run this command in a terminal when install is complete (this command is aliased because pycharm needs a fake wmname)
    pycharm

    # or to run CLion:
    clion

    # TODO: add instructions for configuring 'File->Settings Repository'
    ```

0. Install kaitai struct lib

    ```bash
    # Import GPG key, if you never used any BinTray repos before
    sudo apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv 379CE192D401AB61

    # Add stable repository
    echo "deb https://dl.bintray.com/kaitai-io/debian jessie main" | sudo tee /etc/apt/sources.list.d/kaitai.list
    # ... or unstable repository
    echo "deb https://dl.bintray.com/kaitai-io/debian_unstable jessie main" | sudo tee /etc/apt/sources.list.d/kaitai.list

    sudo apt-get update
    sudo apt-get install kaitai-struct-compiler
    ```

    Install kaitai struct visualizer

    ```bash
    sudo gem install kaitai-struct-visualizer
    ```

    Install pip module

    ```bash
    sudo pip3 install kaitaistruct
    ```

0. Intall miktex

    ```bash
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D6BC243565B2087BC3F897C9277A7293F59E4889
    echo "deb http://miktex.org/download/debian stretch universe" | sudo tee /etc/apt/sources.list.d/miktex.list
    sudo apt-get update
    sudo apt-get install miktex
    miktexsetup finish
    initexmf --set-config-value "[MPM]AutoInstall=1"
    texworks
    ```

0. Install RetroArch (game emulator)

    - NOTE: Pretty buggy, but that may be because I run a tiling WM.

    ```bash
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install --user flathub org.libretro.RetroArch
    # how to update:
    flatpak update --user org.libretro.RetroArch
    flatpak run org.libretro.RetroArch 
    ```

0. Install blueman (for xbox one controller via bluetooth - work-in-progress)


    ```bash
    sudo apt install bluetooth blueman
    # now, re-start the system (or at least the X server)
    sudo systemctl start bluetooth
    sudo systemctl status bluetooth
    sudo systemctl enable bluetooth
    # for xbox one controllers:
    echo 1 > /sys/module/bluetooth/parameters/disable_ertm
    # if the service started OK, then there is no need to add `btusb` kernel module. Otherwise run these:
    ```
    1. Add `btusb` to /etc/modules
    2. Reboot or run `sudo modprobe btusb`

    ```bash
    # pair a controller:
    blueman-manager
    ```

    ```bash
    # add drivers for xbox one controller (maybe optional, needs testing)
    # see https://github.com/paroj/xpad
    ```
    - see [here](https://www.maketecheasier.com/set-up-xbox-one-controller-ubuntu/) for
      more info ie how to control kbd/mouse with controller and how to calibrate

0. Pair a bluetooth headset:

   ```bash
   sudo apt install pulseaudio pulseaudio-module-bluetooth pavucontrol bluez-firmware
   sudo service bluetooth restart
   killall pulseaudio

   # pair + trust the device in this gui
   blueman-manager

   # configure output to the headphones in this gui - also enable "A2DP" here
   pavucontrol

   # TODO: make volume hotkeys adjust bluetooth audio also
   ```

0. Install Xbox One S controller support over bluetooth [xpadneo](https://github.com/atar-axis/xpadneo)

    ```bash
    # install dependencies
    sudo apt-get install dkms linux-headers-`uname -r`
    # install xpadneo
    git clone https://github.com/atar-axis/xpadneo.git
    cd xpadneo
    # read it first :)
    sudo ./install.sh 

    # connect a controller
    sudo modprobe btusb
    sudo bluetoothctl
    scan on
    # push scan button on the top of the controller
    # wait for controller to appear (9C:AA:1B:22:E5:62 for me)
    pair 9C:AA:1B:22:E5:62
    trust 9C:AA:1B:22:E5:62
    connect 9C:AA:1B:22:E5:62
    # wait for the rumble - done!
    ```

0. Install ImageMagick 7.0.8+ from source

    ```bash
    # install openjp2 lib for jpeg2000 support
    sudo apt install libopenjp2-7-dev
    cd /tmp
    wget https://imagemagick.org/download/ImageMagick.tar.gz
    tar xvf ImageMagick.tar.gz
    cd ImageMagick-*
    # verify the output of this "configure" command contains this:
    #    DELEGATES       = ... openjp2 ...
    ./configure
    make
    sudo make install
    # run the following command if you get "error while loading shared libraries" errors
    sudo ldconfig /usr/local/lib
    # check the version is correct:
    convert --version
    ```

0. Install factorio

    ```bash
    # download latest version from https://factorio.com/download
    tar xvf factorio_alpha_x64_0.17.66.tar.xz
    mkdir ~/programs
    mv factorio ~/programs/factorio

    # if syncthing is setup, link the saves folder there:
    mkdir -p ~/Sync/misc/backups/saves/factorio/BXPSd-link
    rmdir ~/programs/factorio/saves
    ln -s ~/Sync/misc/backups/saves/factorio/BXPSd-link ~/programs/factorio/saves

    factorio  # uses launcher in ~/bin
    ```

0. ~~Install tizonia~~

    - NOTE: Latest (0.18.0) isn't worth using for soundcloud. Loads at most 10 songs with --soundcloud-user-stream, maybe a soundcloud API limitation. It also misses some tracks, but not as many as mopidy-soundcloud. Check again after some major version updates

    - guide from [here](http://tizonia.org/docs/debian/)
    - NOTE: I disagree with some of the actions take in the standard install script.
      Since I don't want to hose my system by running this, download the script and
      make the following changes:
      - Modify the two calls to tee /etc/apt/sources.list: The new sources should
        be added to /etc/apt/sources.list.d/mopidy.list and tizonia.list
      - Remove --force-yes from the apt install call

    ```bash
    curl 'https://bintray.com/user/downloadSubjectPublicKey?username=tizonia' | sudo apt-key add - 
    echo "deb https://dl.bintray.com/tizonia/debian stretch main" | sudo tee /etc/apt/sources.list.d/tizonia.list
    curl 'http://apt.mopidy.com/mopidy.gpg' | sudo apt-key add -
    echo "deb http://apt.mopidy.com/ stable main contrib non-free" | sudo tee -a /etc/apt/sources.list.d/mopidy.list

    cd /tmp
    wget https://github.com/tizonia/tizonia-openmax-il/raw/master/tools/install.sh
    vi install.sh
    # make changes listed above
    ./install-edited.sh
    tizonia --soundcloud-user-stream
    ```

    - Removing:

    ```bash
    sudo apt remove tizonia-all
    sudo apt remove libspotify12
    sudo rm /etc/apt/sources.list.d/tizonia.list
    sudo rm /etc/apt/sources.list.d/mopidy.list
    sudo apt update
    sudo apt autoremove
    ```

0. ~~Install mopidy~~

    - NOTE: Latest (mopidy-soundcloud 2.1.0) isn't worth using for soundcloud. Pulls _up to_ the 10 most recent songs and many don't pull at all (those with unicode?) Check again if/when this has moved to python 3.

    ```bash
    # you may need these, but skip if you don't `sudo apt install gir1.2-gst-plugins-base-1.0 gir1.2-gstreamer-1.0 python-gst-1.0 python-pykka`

    sudo apt install python-gst-1.0 gir1.2-gstreamer-1.0 gir1.2-gst-plugins-base-1.0 gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools

    sudo pip install -U mopidy
    sudo pip install -U mopidy-soundcloud

    mopidy
    ncmpcpp
    ```

    - Removing:

    ```bash
    sudo pip uninstall mopidy-soundcloud
    sudo pip uninstall mopidy
    ```

0. ~~Setup yeganesh:~~ Yeganesh is included in ~/bin/.

    ```bash
    # Download latest from [here](dmwit.com/yeganesh)
    wget http://dmwit.com/yeganesh/yeganesh-2.5-bin.tar.gz
    tar xf yeganesh*
    cp yeganesh-2.5-bin/yeganesh ~/bin/
    # Try app selector (Super+P)
    ```

0. ~~Install Powerline:~~ skipped

    ```bash
    sudo apt-get install -y python-pip
    sudo pip install git+git://github.com/Lokaltog/powerline
    wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
    wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
    sudo mv PowerlineSymbols.otf /usr/share/fonts/
    sudo fc-cache -vf
    sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
    ```

0. ~~Install Tmuxinator:~~ skipped

    ```bash
    sudo gem install tmuxinator
    ```


#### Favorite Firefox Add-ons
- [uBlock Origin](https://addons.mozilla.org/pt-br/firefox/addon/ublock-origin/)
- [HTTPS Everywhere](https://www.eff.org/https-everywhere)
- [Self Destruction Cookies](https://addons.mozilla.org/pt-br/firefox/addon/self-destructing-cookies/)
- [Random Agent Spoofer](https://addons.mozilla.org/pt-br/firefox/addon/random-agent-spoofer/)
- [Tree Style Tab](https://addons.mozilla.org/pt-br/firefox/addon/tree-style-tab/)
- [Vimperator](https://addons.mozilla.org/en-us/firefox/addon/vimperator/)
- [Tile Tabs](https://addons.mozilla.org/en-us/firefox/addon/tile-tabs/)
- [DownThemAll!](https://addons.mozilla.org/en-us/firefox/addon/downthemall/)
- [Session Manager](https://addons.mozilla.org/en-us/firefox/addon/session-manager/)
- [Send to XBMC/Kodi](https://addons.mozilla.org/en-US/firefox/addon/send-to-xbmc/)
- [Open in VLC media player](https://addons.mozilla.org/en-US/firefox/addon/open-in-vlc/)


#### TODO:
- replace DynNetwork plugin in xmobar with a new xmobar_network.py file.
  - allow minimum units with `--smallestunit K`
  - option to use shorter units (K instead of K/s) with `--shortunits True`
- Can't launch pycharm via Mod+p. Need to do one of the following:
  - add alias support to yeganesh (better)
  - add a binary to launch pycharm in ~/bin
- use hostname_colorized in PS1 and remove its TODO in binary section above
- colorscheme update: dark blue is too dark
- finish copying info from documents/xps/debian_notes.txt to this repo
- add aliases to yeganesh with [this](https://github.com/8carlosf/dotfiles/blob/master/bin/dmenui)
- get syncthing working and autostart it (maybe)
- edit start_syncthing
  - needs a better name, too bad `syncthing` is taken by the default install
  - if service running, opens a browser. otherwise it opens after ~4 seconds
- get something going that will run slock automatically after ~20 mins of inactivity
- add more stuff to left side of xmobar
- Check hist file after a while to see if zsh's `KEYBOARD_HACK` option is needed
- Configure openssh-server and add to this repo (config is `/etc/ssh/sshd_config`)
- modify tmux config to not show stats on bottom bar that are already in xmobar
- check out fasd (and jetho's repo)
- check out [rofi](https://github.com/davatorium/rofi) (dmenu/yeganesh replacement)
- check out YouCompleteMe (https://github.com/Valloric/YouCompleteMe)
- check out freerdp-x11
- check out nemo - it has a better compact mode than nautilus
- login to firefox to sync maybe? its a pain to re-setup
- figure out a good way to save some of fstab's contents (NASes etc). maybe have a file that you append to current fstab during setup?
- figure out where fieryturk comes from (it is used in .xmobarrc)
- check out polybar [here](https://github.com/jaagr/polybar)
  - [screenshot](https://old.reddit.com/r/unixporn/comments/bjq866/bspwm_first_time_posting_i_hope_you_guys_like_it_3/) [dotfiles]( https://raw.githubusercontent.com/jaagr/dots/master/.local/etc/themer/themes/darkpx/polybar)
  - [screenshot](https://i.imgur.com/A6spiZZ.png)
  - [screenshot](https://i.imgur.com/xvlw9iH.png)
- eventually add gtk theme
  - [Fantome](https://github.com/addy-dclxvi/gtk-theme-collections)
- maybe make a new games.md for the install instructions for games
  - include lutris since it used to be in app_list_extras.txt
- setup auto install for redshift; two manual steps needed after installing via apt:
  - add `Environment=DISPLAY=:0` to `/usr/lib/systemd/user/redshift.service` under 
    the [Service] header
  - run `systemctl --user enable redshift` then `systemctl --user start redshift`
- Make some kind of automatic color scheme management that reads from a single location
  - conky can execute a shell script which returns current terminal colors
    - see [this stackoverflow answer](https://stackoverflow.com/a/37285624)
  - xmobar's configuration could be edited with sed before starting
    - could be more obvious/explicit, like importing colors.hs from pywal
- enable DRI3 to improve graphics performance. I tried guides online which suggest to
  create a 20-intel.conf and add a line to enable, but it seems to already be enabled,
  just not in use.
    - `cat /var/log/Xorg.0.log | egrep -i "DRI[2-3]"` shows both DRI2 and DRI3 is
      loaded, but only DRI2 is enabled.
    - Outout of `LIBGL_DEBUG=verbose glxinfo | grep libgl` shows only DRI2 in use


#### BUGS
- after boot, volume controls will not work until something tries to use the speakers
- occasionally tmux prefix hotkey stops working in urxvt. Seems to be a urxvt issue.
  - workaround for now is close urxvt, open a new one, and reattach with `tmux a`
- setxkbmap remappings are unbound after wake from sleep ~50% of the time
  - note: I have not seen this for ~ 2 months, maybe not an issue anymore? as of 8-22-19
  - workaround for now is run `remap` when this happens
  - seems to be a known bug, one of the comments has a workaround that may work
    - [comment](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=633849#92)
    - [workaround script](https://bugs.debian.org/cgi-bin/bugreport.cgi?att=1;bug=633849;filename=40xkb-save-restore;msg=92)
- xmobar temperature readout glitches after wake from suspend
  - happened twice in a row within two days, but hasen't happened in > 2 weeks. will
    make temperature script if the bug happens again.
- ~~Figure out why xmobar is hidden by windows by default~~
  - New windows apparently cover xmobar but not trayer - once trayer opens, the layout
    automatically reconfigures to show trayer (and xmobar since it is the same height
    as trayer). Improving trayer startup delay in .xsessionrc will fix this for good.


#### Notes
- Wired adapter names:
  - x220: enp0s25
  - xps9550:
- Wireless adapter names:
  - x220: wlp3s0
  - xps9550: wlp2s0
- Onboard display names (in xrandr):
  - x220: LVDS-1
  - xps9550: eDP1
- External display names (in xrandr):
  - x220: HDMI-1 (and probably also VGA-1)
  - xps9550: HDMI1 and DP1
