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

#### Basics
 - Xmonad interface using Alt as the mod key
 - Hotkeys
   - Open terminal: Alt+Shift+Enter
   - Open app launcher: Alt+P
   - Lock screen: Alt+Shift+Z
   - Reload configs and restart xmonad: Alt+Q
   - Logout: Alt+Shift+Q
   - Sleep: Power button or close lid
   - Save screenshot to `~/screenshots`: PrtScr
   - Save selection of the screen to `~/screenshots`: Shift+PrtScr`
 - Apps
    - File manager: `ranger`
    - App switcher: `rofi`
    - Configure wifi: `wicd-curses`
    - Power management: xfce4-power-manager (`xfce4-power-manager-settings` to manage)
      - handles low-battery notifications
    - Notifications: dunst (`dunst-reload-config` to reload config and show some test messages)
    - File manager (gui): `nautilus`

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

0. If installing on a Dell XPS 9550, follow this first `guide_xps9550_hardware_install_notes.txt`.

0. Install Debian minimal system (see guide_xxx_hardware_install_notes), install only "Standard System Utilities". Optionally select "Debian desktop environment" which will install Gnome 3.

0. Fix apt sources list

    # edit /etc/apt/sources.list and comment-out the "cdrom" line, you may also need to add more lines - for debian buster it should look like:

    deb http://deb.debian.org/debian buster main contrib non-free
    deb-src http://deb.debian.org/debian buster main contrib non-free
    deb http://deb.debian.org/debian-security/ buster/updates main contrib non-free
    deb-src http://deb.debian.org/debian-security/ buster/updates main contrib non-free
    deb http://deb.debian.org/debian buster-updates main contrib non-free
    deb-src http://deb.debian.org/debian buster-updates main contrib non-free

    # now switch apt over to using HTTPS
    sudo apt install git apt-transport-https
    sudo sed -i 's/http:/https:/g' /etc/apt/sources.list

0. Health checks
 - First need to check some common issues that - if they are present - we should fix early.
   - Check suspend by running `systemctl suspend`. The system should go to S3 sleep if bios is configured correctly (power will apppear to turn off, all fans stop).
   - Check for extra interrupts - this made me reinstall my Debian 9 OS because I could not figure out what was wrong. After replacing it with Debian 10, the issue eventually became apparent.
     - Run `watch -n 1 sudo cat /proc/interrupts` to show counters for all interrupts - in my case, IRQ 16 was incrementing by about 15,000 per second. To upgrade to a newer kernel using backports (WARNING: while newer, using a kernel from backports is actually worse for security. Backports are not officially supported, so they will not receive security updates like stable packages.

        sudo -i
        echo "deb https://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list
        echo "deb-src https://deb.debian.org/debian buster-backports main" >> /etc/apt/sources.list
        apt update
        apt install -t buster-backports linux-image-amd64 linux-headers-amd64
        exit
        sudo reboot
        # now run the above test again, verify the interrupt rate is normal (100 per sec roughly)

0. (Optional) If using Gnome 3 as a fallback window manager, change a few settings after booting into it. The majority of these settings will not be used when booting int xmonad, however, some will persist (for example - theme).

   - click "super" key, un-favorite the unused apps on the left (help, rythmbox, etc)
   - open "Tweaks" app -> Appearance -> Application Theme -> Adwaita-dark
   - open "Tweaks" app -> Extensions -> Removeable drive menu -> On
   - open "Tweaks" app -> Keyboard & Mouse -> Mouse Click Emulation -> Area
   - open "Tweaks" app -> Top Bar -> Battery Percentage -> On
   - open "Tweaks" app -> Top Bar -> Date -> On
   - open settings -> privacy -> purge trash & temporary files -> automatically purge temporary files -> On
   - open settings -> bluetooth -> Off (for now)
   - open settings -> devices -> Keyboard -> add custom shortcut with command `x-terminal-emulator` and shortcut Ctrl+Alt+T
   - open settings -> devices -> removable media -> set all sections to "ask what to do"
   - open settings -> devices -> mouse & touchpad -> tap to click -> on
   - open settings -> devices -> displays -> Night Light -> On
   - open settings -> details -> users -> automatic login -> On
   - also, change these after installing default apps:
     - open settings -> details -> default applications -> music -> mpv Media Player
     - open settings -> details -> default applications -> video -> mpv Media Player
     - open "Tweaks" app -> Fonts -> Interface Text -> Ubuntu Regular (size: 11)
     - open "Tweaks" app -> Fonts -> Document Text -> Ubuntu Regular (size: 11)
     - open "Tweaks" app -> Fonts -> Monospace Text -> Terminus Regular (size: 11)
     - open "Tweaks" app -> Fonts -> Legacy Window Titles -> Ubuntu Medium (size: 11)

0. Install base software

    ```bash
    sudo apt update
    # optional: copy ~/.ssh/id_rsa key from somewhere, or generate a new one with `ssh-keygen -t rsa -b 4096`

    # Install apps and link dotfiles. See install.sh for details.
    git clone git://github.com/g0tmk/dotfiles-linux.git ~/dotfiles
    cd ~/dotfiles
    # say yes to everything
    ./install.sh
    # reboot, make sure enerything looks OK

    # sensors-detect will probably tell you to add coretemp to /etc/modules - instead do this:
    # run this command, if you see output then coretemp is enabled already
    cat /proc/modules | grep coretemp
    # if you see no output, add coretemp to /etc/modules

    # optional; run this if some hardware does not work and reboot (I did not need it for debian 10 on xps9550)
    sudo apt install firmware-misc-nonfree

    # optional; if default apps are fine with you then skip this
    sudo update-alternatives --all
    ```

0. Xmonad

    - reboot. in login screen, select "xmonad" as window manager, login
    - alt+shift+enter to open terminal
    - if xmonad fails to start, you might need to run this (but try not to, it is worse than the built-in xorg driver)`sudo apt install xserver-xorg-video-intel`

0. Improve graphics performance (for intel embedded gpus)

    sudo apt remove xserver-xorg-video-intel
    sudo apt install xserver-xorg-core
    reboot

0. Install NTP

- run `sudo apt-get install ntp`
- add these lines to /etc/ntp.conf (and remove the generic ones)

    server 0.north-america.pool.ntp.org
    server 1.north-america.pool.ntp.org
    server 2.north-america.pool.ntp.org
    server 3.north-america.pool.ntp.org

0. Configure sound (optional)

    - run `speaker-test` (or make a sound some other way)
      - if no sound, run `sudo alsactl init`
    - Run `alsamixer` 
    - Hit F6 and select sound card (probably "HDA Intel PCH")
    - set all channels to 0db. Unmute channels with 'm'. I left all muted except
      "Master" and "Speaker". ("OO" is enabled, "MM" is muted).

0. Reverse touchpad scroll direction + enable tap-to-click

    - First, check if this is needed for you. Scroll with your touchpad and if the
      direction is fine (and you don't care about tapping), skip this section.

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

    - Reboot and check if it worked. If not, try the following:
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

    - Reboot and check if scroll direction is fixed. If not, try method #2:

    ```
    open `/usr/share/X11/xorg.conf.d/50-vmmouse.conf`
    add `Option "ButtonMapping" "1 2 3 5 4 6 7 8"` between `Section` and `EndSection`
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

0. Enable sensors (needed on debian 10 xps9550). First run `sensors`. If you see fan RPMs, skip this section.

    ```bash
    # verify dell kernel module is present:
    find /lib/modules/$(uname -r) -type f -name '*.ko' | grep dell-smm-hwmon
    # temporarily enable module; ignore_dmi because xps9550 is not a supported system (works anyways)
    sudo modprobe dell-smm-hwmon ignore_dmi=1
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

0. (Optional, skipped on Debian 10 install) Install Powertop to monitor/maximize battery life (laptop only) (check for latest version [here](https://01.org/powertop))

    ```bash
    sudo apt install libnl-3-dev libnl-genl-3-dev gettext libgettextpo-dev autopoint libncurses5-dev libncursesw5-dev libtool-bin dh-autoreconf
    wget https://01.org/sites/default/files/downloads//powertop-v2.12.tar.gz
    tar xvf powertop-v2.12.tar.gz
    cd powertop-v2.12
    ./autogen.sh
    ./configure
    make
    sudo make install
    # you can now run `sudo powertop`
    ```

0. (Optional, skipped on Debian 10 install) Install tlp for decent power management (laptop only) from guide [here](https://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html#installation)

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

0. (Optional, skipped on Debian 10 install) Setup Thermald to help with thermals (Intel only, probably only useful on laptops)

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

0. Install sublime text & sublime merge (from [here](https://www.sublimetext.com/docs/3/linux_repositories.html))

    ```bash
    # install using their apt source:
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
    sudo apt update
    sudo apt install apt-transport-https
    sudo apt install sublime-text sublime-merge
    # you can now run `subl` and `smerge`

    # TODO: figure out how to include (or auto-install) my plugins list. Example:
    #   - MarkdownPreview
    ```

0. Install syncthing [from guide here](https://apt.syncthing.net/)

    ```bash
    # Add the release PGP keys:
    sudo curl -s -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg

    # Add the "stable" channel to your APT sources:
    echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

    # Increase preference of Syncthing's packages ("pinning")
    printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | sudo tee /etc/apt/preferences.d/syncthing

    # Update and install syncthing:
    sudo apt update
    sudo apt install syncthing

    # To configure as a systemd service
    mkdir -p ~/.config/systemd/user/
    sudo cp /lib/systemd/system/syncthing@.service ~/.config/systemd/user/
    sudo chown $USER:$USER ~/.config/systemd/user/syncthing@.service
    # IMPORTANT: edit the file, remove the `User=` line
    # IMPORTANT: edit the file, change "WantedBy=multi-user.target" to "WantedBy=default.target"
    sudo vi ~/.config/systemd/user/syncthing@.service
    systemctl --user daemon-reload
    systemctl --user enable "syncthing@$USER.service"
    systemctl --user start "syncthing@$USER.service"
    # if everything works, this should contain "Access the GUI via the following URL..."
    sudo journalctl | grep sync | tail -n 20
    ```

    - Now, load interface at `http://localhost:8384/`
    - Use the web UI to delete the default folder at `~/Sync`
    - Open settings -> Default Configuration -> Edit Folder Defaults -> Folder Path: `/home/<your_username_here>/Sync/`
    - Open settings -> GUI -> Use HTTPS For GUI -> Yes
    - reboot and verify web UI is accessible. NOTE: `start_syncthing` will manually start if needed
    - later, put a .stignore file at the root of each synced folder that contains `#include .stglobalignore`

0. Install Duplicati (guide [here](https://duplicati.readthedocs.io/en/latest/02-installation/))

    - Install mono (note: uses about 400 MB)

    ```bash
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF

    echo "deb http://download.mono-project.com/repo/debian buster main" | sudo tee /etc/apt/sources.list.d/mono-official.list

    sudo apt update
    sudo apt install mono-devel
    ```

    - Install the actual app

    ```bash
    # maybe optional
    sudo apt install apt-transport-https nano git-core software-properties-common dirmngr

    # check for latest version here https://www.duplicati.com/download
    cd ~/Downloads
    wget https://updates.duplicati.com/beta/duplicati_2.0.6.3-1_all.deb
    sudo apt install ./duplicati_2.0.6.3-1_all.deb
    ```

    - Now create a service to start duplicati automatically
      - Edit `/etc/systemd/system/duplicati.service` and fill it with the following:

        ```
        [Unit]
        Description=Duplicati web-server
        After=network.target

        [Service]
        Nice=19
        IOSchedulingClass=idle
        EnvironmentFile=-/etc/default/duplicati
        ExecStart=/usr/bin/duplicati-server $DAEMON_OPTS
        Restart=always

        [Install]
        WantedBy=multi-user.target
        ```

      - Edit `/etc/default/duplicati` and change DAEMON_OPTS, file should look like the following:

        ```bash
        # Defaults for duplicati initscript
        # sourced by /etc/init.d/duplicati
        # installed at /etc/default/duplicati by the maintainer scripts

        # Additional options that are passed to the Daemon.
        DAEMON_OPTS="--webservice-interface=127.0.0.1 --webservice-port=8200"
        ```

      - Enable the service and verify it is running by running these commands:

        ```bash
        sudo systemctl daemon-reload
        sudo systemctl enable duplicati.service
        sudo systemctl start duplicati.service
        sudo systemctl status duplicati.service
        ```

      - Open web UI at http://localhost:8200
      - Reboot and verify web UI is still accessible
      - In web UI change some settings:
        - Access to Interface -> Set a password
        - Pause after startup or hibernation -> 30 seconds
        - Display and color theme -> Dark theme
        - Donation messages -> click to hide
        - Usage statistics -> None/disabled
          - NOTE: if you want to set a password, then you must also edit .xsessionrc and 
            modify the `duplicati` launch line to include a password, like this:
            `duplicati --no-hosted-server --webserver-password=MYPASSWORD`

0. Install virtualbox

    - Original guide [here](https://wiki.debian.org/VirtualBox#Debian_9_.22Stretch.22)
    - Info on integration with tiling WM [here](http://kissmyarch.blogspot.com/2012/01/hiding-menu-and-statusbar-of-virtualbox.html)

    ```bash
    # install virtualbox using their apt source:
    # WARNING: make sure to modify apt name from buster to something else, if needed
    echo "deb https://download.virtualbox.org/virtualbox/debian buster contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
    wget -q -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add
    sudo apt update
    sudo apt search virtualbox | grep ^virtualbox
    # install the newest available
    # NOTE: change this value if there is a newer version
    sudo apt install virtualbox-6.x

    # add yourself to vboxusers group
    sudo usermod -a -G vboxusers $USER

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

0. Install redshift

    - If you installed the minimal app list, this is installed already, but it can't hurt to run.

            sudo apt install redshift

    - Enable the user service

            systemctl --user enable redshift
            systemctl --user start redshift

0. Install firefox stable (from [here](https://wiki.debian.org/Firefox#Firefox_Stable.2C_Beta_and_Nightly))

    - If a desktop environment is installed already, you might have the best version of
      firefox. Check if firefox-esr and firefox are installed already. If they are,
      skip the rest of this section.

    ```bash
    sudo apt show firefox-esr
    sudo apt show firefox
    ```

    - If you want the debian-packaged version of firefox (possibly older but stable and
      secure) then all you need to run is `sudo apt install firefox-esr`, and skip the
      rest of this section.
    - If you want the latest firefox, then you can install the latest version like this:

    ```bash
    # first remove any debian-packaged versions
    sudo apt remove firefox firefox-esr
    # download firefox from website and extract to a directory in home:
    # TODO: this doesn't work but should: wget https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US
    wget https://download-installer.cdn.mozilla.net/pub/firefox/releases/66.0.5/linux-x86_64/en-US/firefox-66.0.5.tar.bz2
    mkdir ~/bin ~/.mozilla
    tar -xf ./firefox* -C ~/.mozilla
    ln -s ~/.mozilla/firefox/firefox ~/bin/firefox
    sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser ~/bin/firefox 200
    # you can now run `firefox`

    # (optional, modern firefox has a dark mode that is good enough)
    # to install shadowfox, download the latest from here https://overdodactyl.github.io/ShadowFox/#
    # make sure you set firefox theme to 'Dark' first
    wget https://github.com/SrKomodo/shadowfox-updater/releases/download/v1.7.19/shadowfox_linux_x64
    chmod+x shadowfox_linux_x64
    ./shadowfox_linux_x64
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

0. (Optional, skipped on Debian 10 install) Install a compositor (picom, yshui's compton fork [github](https://github.com/yshui/picom))

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

0. Install discord

    ```bash
    # Download latest deb from https://discordapp.com/download
    cd ~/Downloads
    wget -O discord.deb "https://discord.com/api/download?platform=linux&format=deb"
    sudo apt install ./discord.deb
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

0. Setup Franz (messenger)

    - Download .deb from [here](https://www.meetfranz.com/download?platform=linux&type=deb)
    - `sudo dpkg -i file.deb`
    - you can now run `franz`

0. Setup `Dell Command | Configure` (Dell hardware only)

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
    - [troubleshooting tips for pptpclient/pptpsetup](http://pptpclient.sourceforge.net/howto-diagnosis.phtml)

    ```bash
    # assumes new name:    my_tunnel
    # assumes server url:  vpn.example.com
    # assumes username:    alice
    # assumes password:    foo
    # assumes vpn network: 192.168.10.0/24
    sudo apt install pptp-linux
    sudo pptpsetup --create my_tunnel --server vpn.example.com --username alice --password foo --encrypt
    # test the new connection - it will not exit. If there are no errors, great! To
    # fully test, you will also need to run the route command that follows. If there
    # are errors connecing, you may need to add "refuse-eap" to the top of /etc/ppp/options
    sudo pon my_tunnel debug dump logfd 2 nodetach
    # Option 1: If you want to route traffic only to devices on vpn network (not
    # internet traffic) then add this route (change the network's subnet info to match)
    sudo ip route add 192.168.10.0/24 dev ppp0
    # Option 2: Route all traffic over VPN
    sudo ip route add default dev ppp0

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

0. Install ClickUp

    ```bash
    # download latest desktop app for linux here https://clickup.com/apps
    unzip ~/Downloads/clickup-desktop-2.0.8-linux.zip
    ~/Downloads/clickup-desktop-2.0.8-x86_64.AppImage --no-sandbox
    # NOTE: see here for info on how to get it to run in-sandbox:
    # https://github.com/standardnotes/forum/issues/690#issuecomment-531802728
    ```

0. Install Minecraft

    ```bash
    # download latest deb from minecraft.net and install it
    sudo dpkg -i minecraft-latest.deb
    minecraft-launcher

    # if launcher fails with error "Couldn't load launcher core from /home/g0tmk/.minecraft/launcher/liblauncher.so: LoadErrorNotPresent"
    #   then download latest libstdc++ (i did the one for buster)
    cd /tmp
    wget http://ftp.us.debian.org/debian/pool/main/g/gcc-8/libstdc++6_8.3.0-6_amd64.deb
    ar x libstdc++6_8.3.0-6_amd64.deb
    tar xvf data.tar.xz
    cp usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.25 usr/lib/x86_64-linux-gnu/libstdc++.so.6 ~/.minecraft/launcher/
    minecraft-launcher
    ```

0. Install Steam (NOT TESTED)

    ```bash
    sudo usermod -a -G video,audio $USER
    sudo apt install steam
    steam
    ```

0. Install Chrome (NOT TESTED)

    - How to install stable (I picked this one):
      1. Install with `sudo apt install google-chrome-stable`
      2. Open chrome, sign in
      3. Go to "Extensions" click "details" on one of the extensions
      4. if chrome doesn't freeze, congrats! you're done. otherwise go to 5
      5. re-open chrome, use mod+right-click to resize chrome to 25% the size of the screen
      6. repeat steps 3-4, chrome shouldn't freeze this time (instead a tiny window will pop up)

    - How to install latest:

    ```bash
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    sudo apt-get -f install
    ```

0. Set up service to run xfce4-power-manager (IN-DEV / NOT WORKING - currently started via cmdline in .xsessionrc)

    - NOTE: this does not currently work - service attempts to start, but xfce4-power-manager prints an error message "Unable to open display" which probably means it expects to be run inside of an X-session, so when it is started as root (or anyone probably) as a service, X is not available. Not sure if there is a good solution for this; workaround of starting in .xsessionrc works so far.
    - create `/etc/systemd/system/xfce4-power-manager.service` and fill it with the following contents:

        [Unit]
        Description=Xfce4 Power Manager
        Documentation=man:xfce4-power-manager(1) man:xfce4-power-manager-settings(1)

        [Service]
        Type=dbus
        BusName=org.xfce.PowerManager
        ExecStart=/usr/bin/xfce4-power-manager --no-daemon
        ExecStop=/usr/bin/xfce4-power-manager --quit

        [Install]
        WantedBy=multi-user.target
        Alias=dbus-org.xfce.PowerManager.service

    - Run `sudo systemctl daemon-reload` to reload service files
    - Run `sudo systemctl enable xfce4-power-manager` to enable xfce4-power-manager on boot
    - Run `sudo systemctl status xfce4-power-manager` to verify service file works and is running
    - Run `sudo journalctl -u xfce4-power-manager` to check the service logs

0. Install evmlab (NOT YET WORKING)

    ```bash
    sudo apt install python3 python3-pip
    python3 -m pip install evmlab[consolegui,abidecoder,docker]
    python3 -m evmlab opviewer --hash 0xETHTXHASH

    ```

0. Install Rollercoaster Tycoon (NOT YET WORKING)

    ```bash
    # NOTE: these instructions are not fully correct - needed debian 10+ to complete, and I was on 9

    sudo mkdir /mnt/rc2_cd
    sudo mount RC2.iso /mnt/rc2_cd -o loop
    sudo apt install unshield
    mkdir ~/programs/rc2
    INSTALLDIR=/mnt/rc2_cd
    EXTRACTDIR=~/programs/rc2

    unshield -g Minimum -d "$EXTRACTDIR" x "$INSTALLDIR/data1.hdr"
    cp -R "$INSTALLDIR/Data/" "$EXTRACTDIR/Minimum/Data"
    mv "$EXTRACTDIR/Minimum" "$EXTRACTDIR/RCT2"
    sudo umount /mnt/rc2_cd

    # clone and build openrc2 - if you were on ubuntu, you could just use the ppa...
    # AppImage file provided on the website appeared to require debian 10 only libs, so no debian 9
    git clone https://github.com/OpenRCT2/OpenRCT2.git
    cd OpenRC2
    mkdir build
    cd build
    cmake ..

    # for the latest version, check here:
    wget https://github.com/OpenRCT2/OpenRCT2/releases/download/v0.2.6/OpenRCT2-0.2.6-linux-x86_64.tar.gz
    tar xvf Open*
    cd OpenRCT2

    # for the latest version, check here: 
    cd ~/programs/rc2
    wget https://github.com/OpenRCT2/OpenRCT2/releases/download/v0.2.6/OpenRCT2-0.2.6-linux-x86_64.AppImage
    chmod +x Open*
    ln -s OpenRCT2-0.2.6-linux-x86_64.AppImage OpenRC2_latest
    # this runs a wrapper script in ~/bin
    rollercoastertycoon2

    sudo apt install playonlinux
    playonlinux
    # in the gui, click the "Configure" button, click "New", select 32 bits, select "System" as the wine version, type "rc2" as name of virtual drive, click OK.
    # in the gui, click the "Configure" button, select rc2 drive, wine tab, click "Configure Wine", go to Drives tab, click "Add", add D: with path /mnt/rc2_cd
    # might have to restart playonlinux here
    # in the gui, click "Install Program", search for "Rollercoaster Tycoon 2" (You might have to check "No-cd needed" in search options)


    ```

    ```bash
    # separate attempt number 2
    # needed if running openrct2 throws 'libduktape.so.202: cannot open shared object file'
    sudo apt install duktape-deb
    cd ~/programs/rc2
    wget https://github.com/Limetric/OpenRCT2-binaries/releases/download/v0.3.3-efd5d7d/OpenRCT2-0.3.3-develop-efd5d7d-linux-x86_64.tar.gz
    tar xvf OpenRCT2-0.3.3-develop-efd5d7d-linux-x86_64.tar.gz
    cd OpenRCT2
    ./openrct2
    ```

0. Install mkchromecast (NOT TESTED / NOT WORKING)

    ```bash
    sudo apt install mkchromecast
    sudo apt install python3-flask python3-flask python3-psutil
    mkchromecast --video -i videofile.mp4
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

0. ~~Install pywal to enable colorschemes based on the wallpaper~~ skipped

    ```bash
    pip3 install --user pywal
    # install extra backends (optional)
    pip3 install --user haishoku colorthief colorz
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

0. ~~Setup yeganesh:~~ Yeganesh is included in `~/bin/`, this can still be followed to
   update it, if needed.

    ```bash
    # Download latest from [here](dmwit.com/yeganesh)
    curl dmwit.com/yeganesh/yeganesh-2.5-bin.tar.gz | tar xzv
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
- check macbook dotfiles + copy over any useful preferences (at least .vimrc and tmux.conf)
- replace middle-click paste with something better. It is too easy to accidentally triple-tap with the touchpad and dump a block of text at the cursor. Step 1 is disable middle click with touchpad, then step 2 is merge the x-selection and the standard clipboard with some kind of app or maybe even a custom shortcut with an intelligent paste (or Ctrl+V for one, Ctrl+Shift+V for another). Should google how others have solved this problem.
- add sublime text 4 themes and colorscheme. Config is saved already
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
  - after install run `gsettings set org.nemo.desktop show-desktop-icons false` to disable desktop window
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
- volume controls do not work on bluetooth (or any non-built-in-speaker) headphones
  - the slider that changes in pavucontrol is named "Built-in Audio Analog Stereo"
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
