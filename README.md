## dotfiles


#### TODO:
- Check hist file after a while to see if zsh's `KEYBOARD_HACK` option is needed
- Figure out why xmobar is hidden by windows by default
- reverse scroll direction
- ~~Remove prezto files/references~~
- Configure openssh-server and add to this repo (config is `/etc/ssh/sshd_config`)
- modify tmux config to not show stats on bottom bar that are already in xmobar
- check out fasd (and jetho's repo)
- check out YouCompleteMe (https://github.com/Valloric/YouCompleteMe)
- check out freerdp-x11
- login to firefox to sync maybe? its a pain to re-setup
- figure out a good way to save some of fstab's contents (NASes etc). maybe have a file that you append to current fstab during setup?
- figure out where fieryturk comes from (it is used in .xmobarrc)
- compare envypn font (from [here](https://bbs.archlinux.org/viewtopic.php?id=144462) with terminus font)
- check out polybar [here](https://github.com/jaagr/polybar)
  - https://old.reddit.com/r/unixporn/comments/bjq866/bspwm_first_time_posting_i_hope_you_guys_like_it_3/
    - https://raw.githubusercontent.com/jaagr/dots/master/.local/etc/themer/themes/darkpx/polybar
  - https://i.imgur.com/A6spiZZ.png
  - https://i.imgur.com/xvlw9iH.png
- eventually add gtk theme
  - [Fantome](https://github.com/addy-dclxvi/gtk-theme-collections)
- wicd-curses -> wifi name -> Preferences -> Check "Automatically reconnect on connection loss"
  - was set on x220, maybe is default option
- ~~manually download/install google-chrome .deb?~~
- maybe make a new games.md for the install instructions for games
- make syncthing-browser binary that starts syncthing if needed then opens it in a browser
- add `qrcode` binary that can accept from stdin (or filename arg maybe) and display qr in terminal
  - bonus: use unicode to increase pixel resolution OR generate an image the terminal can understand (like ranger)
- check out [rofi](https://github.com/davatorium/rofi) (dmenu/yeganesh replacement)


#### Install steps on a fresh Debian (Testing) machine

0. Install Debian minimal system, install only "Standard System Utilities" and "Laptop" if needed.

1. Install base software

    ```bash
    sudo apt update
    sudo apt install git stow apt-transport-https
    git clone git://github.com/g0tmk/dotfiles-linux.git ~/dotfiles
    cd ~/dotfiles
    sudo apt install -y $(< ~/dotfiles/app_list_minimal.txt)
    sudo apt install -y $(< ~/dotfiles/app_list_extras.txt) # optional
    ```

2. Set zsh as default shell

    ```bash
    chsh -s /bin/zsh
    # unpack only the zsh dotfiles for now
    cd ~/dotfiles
    stow zsh/
    ```

3. Install virtualbox (from [here](https://wiki.debian.org/VirtualBox#Debian_9_.22Stretch.22))

    ```bash
    # install virtualbox using their apt source:
    echo "deb https://download.virtualbox.org/virtualbox/debian stretch contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
    wget -q -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add
    sudo apt update
    sudo apt search virtualbox | grep ^virtualbox  # install the newest available
    sudo apt install virtualbox-6.x
    # you can now run `virtualbox`
    ```

4. Install sublime text & sublime merge (from [here](https://www.sublimetext.com/docs/3/linux_repositories.html))

    ```bash
    # install using their apt source:
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    wget -q -O- https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add
    sudo apt update
    sudo apt install sublime-text sublime-merge
    # you can now run `subl` and `smerge`
    ```

5. Install firefox stable (from [here](https://wiki.debian.org/Firefox#Firefox_Stable.2C_Beta_and_Nightly))

    ```bash
    # download firefox from website and extract to a directory in home:
    # TODO: this doesn't work but should: wget https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US
    wget https://download-installer.cdn.mozilla.net/pub/firefox/releases/66.0.1/linux-x86_64/en-US/firefox-66.0.1.tar.bz2
    mkdir ~/bin ~/.mozilla
    tar -xf ./firefox* -C ~/.mozilla
    ln -s ~/.mozilla/firefox/firefox ~/bin/firefox
    ```

6. Set rxvt-unicode as default terminal emulator #TODO: do later; skipped

    ```bash
    # note: I did not need to run this. run '--display' instead of set to check
    sudo update-alternatives --set x-terminal-emulator /usr/bin/urxvt
    ```

7. Install Powerline #TODO: do later; skipped

    ```bash
    sudo apt-get install -y python-pip
    sudo pip install git+git://github.com/Lokaltog/powerline
    wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
    wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
    sudo mv PowerlineSymbols.otf /usr/share/fonts/
    sudo fc-cache -vf
    sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
    ```

8. Install prezto #TODO: do later; skipped

    ```bash
    git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
    ```

9. Install Tmuxinator #TODO: do later; skipped

    ```bash
    sudo gem install tmuxinator
    ```

9. Stow dotfiles

    ```bash
    cd ~/dotfiles
    stow $(ls -d ^etc(/))
    ```

9. Haskell Tools (optional) #TODO: do later; skipped

    ```bash
    curl -sSL https://get.haskellstack.org/ | sh
    stack install ghc-mod hlint hasktags codex hscope pointfree pointful hoogle hindent apply-refact
    ```

9. Install barrier

    ```bash
    sudo apt install flatpak
    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install --user flathub com.github.debauchee.barrier
    flatpak run com.github.debauchee.barrier
    echo -e '#!/bin/sh\nflatpak run com.github.debauchee.barrier' > ~/bin/barrier; chmod +x ~/bin/barrier
    barrier
    # follow in-gui instructions
    ```

9. Install discord

    ```bash
    # Download latest deb from https://discordapp.com/download
    wget https://dl.discordapp.net/apps/linux/0.0.9/discord-0.0.9.deb
    sudo dpkg -i discord-0.0.9.deb
    sudo apt install -f
    discord
    ```

9. Install Parsec

    ```bash
    # Download latest 'parsec for ubuntu' from parsecs site
    # NOTE: it segfaulted the first (and maybe second) time I ran it - eventually it became stable /shrug
    sudo dpkg -i parsec-linux.deb
    parsec
    ```

9. Setup brightness control (only needed on xps 9550). Add to /etc/sudoers with `sudo visudo`:

    ```bash
    Cmnd_Alias    PLUS = /home/<your_username>/bin/brightness.py
    <your_username> ALL = NOPASSWD: PLUS
    # try brightness controls (Fn+F11 on xps9550)
    ```

9. Setup yeganesh (not needed if yeganesh is included in ~/bin/):

    ```bash
    # Download latest from [here](dmwit.com/yeganesh)
    wget http://dmwit.com/yeganesh/yeganesh-2.5-bin.tar.gz
    tar xf yeganesh*
    cp yeganesh-2.5-bin/yeganesh ~/bin/
    # Try app selector (Super+P)
    ```

9. Setup dwarf fortress

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

9. Install syncthing [from guide here](https://apt.syncthing.net/)

    ```bash
    # Add the release PGP keys:
    curl -s https://syncthing.net/release-key.txt | sudo apt-key add -

    # Add the "stable" channel to your APT sources:
    echo "deb https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

    # Update and install syncthing:
    sudo apt-get update
    sudo apt-get install syncthing
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

