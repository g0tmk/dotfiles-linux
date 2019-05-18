## dotfiles


#### TODO:
- maintenence
  - xps9550 palmrest
  - xps9550 repaste
- check grub bootloader (colors not working)
- fix symlink to bin on x220 and add other binaries
- add aliases to yeganesh with [this](https://github.com/8carlosf/dotfiles/blob/master/bin/dmenui)
- check barrier on xps
- edit start_syncthing
  - needs a better name, too bad `syncthing` is taken by the default install
  - if service running, opens a browser. otherwise it opens after ~4 seconds
- get something going that will run slock automatically after ~20 mins of inactivity
- reverse scroll direction
- add more stuff to left side of xmobar
- go through tmux conf - there are some weird settings in there
- make a small wrapper around amixer that allows higher-level logic (ie if sound is
  muted and you hit the 'volume down' key, set volume to minimum and unmute)
  - make sure that the wrapper always applies voluem changes before unmuting
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
- wicd-curses -> wifi name -> Preferences -> Check "Automatically reconnect on connection loss"
  - was set on x220, maybe is default option
  - seems to work on xps after boot/wake from suspend
- maybe make a new games.md for the install instructions for games
- add `qrcode` binary that can accept from stdin (or filename arg maybe) and display qr in terminal
  - bonus: use unicode to increase pixel resolution OR generate an image the terminal can understand (like ranger)
- setup auto install for redshift; two manual steps needed after installing via apt:
  - add `Environment=DISPLAY=:0` to `/usr/lib/systemd/user/redshift.service` under 
    the [Service] header
  - run `systemctl --user enable redshift` then `systemctl --user start redshift`


#### BUGS
- xmobar temperature readout glitches after wake from suspend
- Figure out why xmobar is hidden by windows by default


#### Install steps on a fresh Debian (Testing) machine

0. Install Debian minimal system, install only "Standard System Utilities" and "Laptop" if needed.

0. Install base software

    ```bash
    sudo apt update
    sudo apt install git apt-transport-https
    sudo sed -i 's/http:/https:/g' /etc/apt/sources.list
    git clone git://github.com/g0tmk/dotfiles-linux.git ~/dotfiles
    cd ~/dotfiles
    ./install.sh
    ```

0. Set zsh as default shell

    ```bash
    chsh -s /bin/zsh
    ```

0. Set rxvt-unicode as default terminal emulator #TODO: do later; skipped

    ```bash
    # note: I did not need to run this. run '--display' instead of set to check
    sudo update-alternatives --set x-terminal-emulator /usr/bin/urxvt
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

    ```bash
    # download firefox from website and extract to a directory in home:
    # TODO: this doesn't work but should: wget https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US
    wget https://download-installer.cdn.mozilla.net/pub/firefox/releases/66.0.5/linux-x86_64/en-US/firefox-66.0.5.tar.bz2
    mkdir ~/bin ~/.mozilla
    tar -xf ./firefox* -C ~/.mozilla
    ln -s ~/.mozilla/firefox/firefox ~/bin/firefox
    sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser ~/bin/firefox 200
    ```

0. Install barrier

    ```bash
    sudo apt install flatpak
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install --user flathub com.github.debauchee.barrier
    flatpak run com.github.debauchee.barrier
    echo -e '#!/bin/sh\nflatpak run com.github.debauchee.barrier' > ~/bin/barrier; chmod +x ~/bin/barrier
    barrier
    # follow in-gui instructions
    ```

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

0. Setup brightness control (only needed on xps 9550). Add to /etc/sudoers with `sudo visudo`:

    ```bash
    Cmnd_Alias    PLUS = /home/<your_username>/bin/brightness.py
    <your_username> ALL = NOPASSWD: PLUS
    # try brightness controls (Fn+F11 on xps9550)
    ```

0. Setup yeganesh (not needed if yeganesh is included in ~/bin/):

    ```bash
    # Download latest from [here](dmwit.com/yeganesh)
    wget http://dmwit.com/yeganesh/yeganesh-2.5-bin.tar.gz
    tar xf yeganesh*
    cp yeganesh-2.5-bin/yeganesh ~/bin/
    # Try app selector (Super+P)
    ```

0. Setup dwarf fortress

    ```bash
    # Install requirements (listed here http://dwarffortresswiki.org/index.php/DF2014:Installation)
    sudo dpkg --add-architecture i386
    sudo apt install libgtk2.0-0 libsdl1.2debian libsdl-image1.2 libglu1-mesa libopenal1 libsdl-ttf2.0-0
    # Download latest version from [here](http://www.bay12games.com/dwarves/)
    wget http://www.bay12games.com/dwarves/df_44_12_linux.tar.bz2
    tar xf df_*
    DF_PATH="$PWD/df_linux"
    echo -e '#!/usr/bin/env bash\ncd' $DF_PATH '\n./df' > ~/bin/dwarf_fortress
    chmod +x ~/bin/dwarf_fortress
    dwarf_fortress
    # TODO: include Cheepicus_12x12.png in repo
    # TODO: symlink df_linux/data/saves into syncthing once syncthing setup is done
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

0. Set up grub:

    - Edit /etc/default/grub:
      - change GRUB_TIMEOUT to 2
      - add these lines to set color:
      
    ```bash
    # colors: https://help.ubuntu.com/community/Grub2/Displays#GRUB_2_Colors
    # set normal text to light-blue on black background
    GRUB_COLOR_NORMAL="light-blue/black"
    # set highlighted text to light-cyan on blue background
    GRUB_COLOR_HIGHLIGHT="light-cyan/blue"
    ```
    - Run `sudo update-grub` to commit changes

0. Install Powertop (check for latest version [here](https://01.org/powertop)

    ```bash
    sudo apt install libnl-3-dev libnl-genl-3-dev gettext libgettextpo-dev autopoint libncurses5-dev libncursesw5-dev libtool-bin dh-autoreconf
    wget https://01.org/sites/default/files/downloads//powertop-v2.10.tar.gz
    tar xvf powertop-v2.10.tar.gz
    cd powertop-v2.10
    ./autogen.sh
    ./configure
    make
    sudo make install

    ```
0. Install tlp (laptop only) from guide [here](https://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html#installation)

    ```bash
    sudo bash -c "echo 'deb https://deb.debian.org/debian stretch-backports main' >> /etc/apt/sources.list"
    sudo apt update
    sudo apt-get install -t stretch-backports tlp tlp-rdw 
    sudo vi /etc/default/tlp
    sudo tlp start
    ```

0. Install Powerline #TODO: do later; skipped

    ```bash
    sudo apt-get install -y python-pip
    sudo pip install git+git://github.com/Lokaltog/powerline
    wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
    wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
    sudo mv PowerlineSymbols.otf /usr/share/fonts/
    sudo fc-cache -vf
    sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
    ```

0. Install Tmuxinator #TODO: do later; skipped

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

#### Attributions
- https://gist.github.com/matthewmccullough/787142
- https://github.com/tpope/vim-sensible

