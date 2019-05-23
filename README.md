## g0tmk's dotfiles


#### Useful resources
 - Dell XPS 15 (9550)
   - [XPS 15 Service Manual](http://topics-cdn.dell.com/pdf/xps-15-9550-laptop_Service-Manual_en-us.pdf)
   - [Notes about installing a Debian Stretch on a Dell XPS 15](http://wiki.yobi.be/wiki/Laptop_Dell_XPS_15)
   - [Dell XPS 15 - ArchWiki](https://wiki.archlinux.org/index.php/Dell_XPS_15)
   - [Dell XPS 15 9550 - ArchWiki](https://wiki.archlinux.org/index.php/Dell_XPS_15_(9550))
   - 2016-01-13 [Arch on XPS 15 (late 2015)](https://bbs.archlinux.org/viewtopic.php?id=204739)
   - [Ubuntu 15.10 on Dell XPS 15 9550](https://ubuntuforums.org/showthread.php?t=2301071&p=13382949#post13382949)
   - 2016-05-16 [Ubuntu 16.04 on Dell XPS 15 9550](https://ubuntuforums.org/showthread.php?t=2317843)
   - 2017-12-01 [Installing Kali Linux on a Dell XPS 9550](https://www.rafaelhart.com/2017/12/installing-kali-linux-on-a-dell-xps-9550/)

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
    Cmnd_Alias    PLUS = /home/<your_username>/bin/brightness.py
    <your_username> ALL = NOPASSWD: PLUS
    # try brightness controls (Fn+F11 on xps9550)
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

0. Install virtualbox (from [here](https://wiki.debian.org/VirtualBox#Debian_9_.22Stretch.22))

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
    discord
    ```

0. Install Parsec

    ```bash
    # Download latest 'parsec for ubuntu' from parsecs site
    # NOTE: it segfaulted the first (and maybe second) time I ran it - eventually it became stable /shrug
    sudo dpkg -i parsec-linux.deb
    parsec
    ```

0. Setup dwarf fortress

    ```bash
    # Install requirements (listed here http://dwarffortresswiki.org/index.php/DF2014:Installation)
    sudo dpkg --add-architecture i386
    sudo apt install libgtk2.0-0 libsdl1.2debian libsdl-image1.2 libglu1-mesa libopenal1 libsdl-ttf2.0-0
    # Download latest version from [here](http://www.bay12games.com/dwarves/)
    wget http://www.bay12games.com/dwarves/df_44_12_linux.tar.bz2
    tar xf df_*
    dwarf_fortress --large
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
    # run binary which then runs syncthing:
    start_syncthing
    ```

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

0. Firmware update manager [not working yet]

    ```bash
    sudo apt install fwupd
    # show candidate devices
    fwupdmgr get-devices
    # pull latest metadata from lvfs
    fwupdmgr refresh
    >>> Failed to download
    sudo apt remove fwupd

    # need to try latest version
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
- finish copying info from documents/xps/debian_notes.txt to this repo
- maintenence
  - xps9550 palmrest
  - xps9550 repaste
- check grub bootloader (colors not working)
- add aliases to yeganesh with [this](https://github.com/8carlosf/dotfiles/blob/master/bin/dmenui)
- edit start_syncthing
  - needs a better name, too bad `syncthing` is taken by the default install
  - if service running, opens a browser. otherwise it opens after ~4 seconds
- get something going that will run slock automatically after ~20 mins of inactivity
- add more stuff to left side of xmobar
- go through tmux conf - there are some weird settings in there
- make a small wrapper around amixer that allows higher-level logic (ie if sound is
  muted and you hit the 'volume down' key, set volume to minimum and unmute)
  - make sure that the wrapper always applies volume changes before unmuting
- get syncthing working and autostart it (maybe)
- Check hist file after a while to see if zsh's `KEYBOARD_HACK` option is needed
- Configure openssh-server and add to this repo (config is `/etc/ssh/sshd_config`)
- modify tmux config to not show stats on bottom bar that are already in xmobar
- check out dell command | configure; there are builds for linux
  - NOTE: these links are for dcc 3.3 - use 4.2 instead
  - [link to download](https://www.dell.com/support/article/us/en/04/sln311302/dell-command-configure?lang=en)
  - [link to documentation](https://www.dell.com/support/manuals/us/en/04/command-configure-v3.3/dellcommandconfigure-cli-3.3/-primarybatterycfg?guid=guid-681d4efe-eed0-4d0f-b290-afdd74e81765&lang=en-us)
  - then run `sudo /opt/dell/dcc/cctk` to show usage (and show which options are valid
    on this system
  - then configure with `sudo /opt/dell/dcc/cctk --primarybatterycfg=custom:70-90`
  - NOTE: there are other useful options that may work also:
    - `--biosver`: show bios version
    - `--fullscreenlogo`: hide/show logo at post
    - `--splashscreen` enable or disable, maybe similar to above
    - `--kbdbacklighttimeoutac` and `--kbdbacklighttimeoutbatt` allow adjusting kbd backlight timeouts
    - `--keyboardillumination` allow adjusting kbd backlight brightness
    - `--mfgdate` shows manufacturing date
    - `--fanspeed` auto, high, medium, medium_high, medium_low, low
    - `--fanspeedctrllevel` 0-100
      - 0=auto; higher number provides larger cooling boost
    - `--sysfanspeed` fullspeed, noisereduce
    - `--sysname` show system name?
    - `--thunderboltsecuritylevel` can be used to disable thunderbolt port
      - nosecurity (thunderbolt enabled), userauthorization, secureconnect, displayport (thunderbolt disabled)
- check out fasd (and jetho's repo)
- check out [rofi](https://github.com/davatorium/rofi) (dmenu/yeganesh replacement)
- check out YouCompleteMe (https://github.com/Valloric/YouCompleteMe)
- check out freerdp-x11
- check out nemo - it has a better compact mode than nautilus
- login to firefox to sync maybe? its a pain to re-setup
- figure out a good way to save some of fstab's contents (NASes etc). maybe have a file that you append to current fstab during setup?
- figure out where fieryturk comes from (it is used in .xmobarrc)
- compare envypn font (from [here](https://bbs.archlinux.org/viewtopic.php?id=144462) with terminus font)
- check out polybar [here](https://github.com/jaagr/polybar)
  - [screenshot](https://old.reddit.com/r/unixporn/comments/bjq866/bspwm_first_time_posting_i_hope_you_guys_like_it_3/) [dotfiles]( https://raw.githubusercontent.com/jaagr/dots/master/.local/etc/themer/themes/darkpx/polybar)
  - [screenshot](https://i.imgur.com/A6spiZZ.png)
  - [screenshot](https://i.imgur.com/xvlw9iH.png)
- eventually add gtk theme
  - [Fantome](https://github.com/addy-dclxvi/gtk-theme-collections)
- maybe make a new games.md for the install instructions for games
- add `qrcode` binary that can accept from stdin (or filename arg maybe) and display qr in terminal
  - bonus: use unicode to increase pixel resolution OR generate an image the terminal can understand (like ranger)
- setup auto install for redshift; two manual steps needed after installing via apt:
  - add `Environment=DISPLAY=:0` to `/usr/lib/systemd/user/redshift.service` under 
    the [Service] header
  - run `systemctl --user enable redshift` then `systemctl --user start redshift`


#### BUGS
- capslock->escape remapping doesn't stay bound always? maybe after wake from sleep?
- Figure out why xmobar is hidden by windows by default
- xmobar temperature readout glitches after wake from suspend
  - happened twice in a row within two days, but hasen't happened in > 2 weeks. will
    make temp script if the bug happens again.


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


