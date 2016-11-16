## dotfiles

#### Install steps on a fresh Debian (Testing) machine

0. Install Debian minimal system, install only "Standard System Utilities" and "Laptop" if needed.

1. Install base software

    ```bash
    sudo apt-get update
    sudo apt-get install git stow
    git clone git://github.com/g0tmk/dotfiles-linux.git ~/dotfiles
    cd ~/dotfiles
    #sudo stow -t / etc # copy apt preferences: TODO: verify and uncomment
    sudo apt-get update
    sudo apt-get install -y $(< ~/dotfiles/app_list.txt)
    # TODO: manually download/install google-chrome .deb here
    # install firefox from backports
    sudo aptitude install -y -t jessie-backports firefox-esr
    ```

2. Set rxvt-unicode as default terminal emulator

    ```bash
    sudo update-alternatives --set x-terminal-emulator /usr/bin/urxvt
    ```

3. Install Powerline #TODO: do later; skipped

    ```bash
    sudo apt-get install -y python-pip
    sudo pip install git+git://github.com/Lokaltog/powerline
    wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf 
    wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
    sudo mv PowerlineSymbols.otf /usr/share/fonts/
    sudo fc-cache -vf
    sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
    ```

4. Install prezto #TODO: do later; skipped

    ```bash
    git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
    ```

5. Set zsh as default shell

    ```bash
    chsh -s /bin/zsh
    ```


6. Install screenfetch

    ```bash
    wget -O screenfetch 'https://raw.github.com/KittyKatt/screenFetch/master/screenfetch-dev'
    chmod +x screenfetch
    sudo mv screenfetch /usr/local/bin/
    ```

7. Install Tmuxinator #TODO: do later; skipped

    ```bash
    sudo gem install tmuxinator
    ```

8. Stow dotfiles

    ```bash
    cd ~/dotfiles
    stow $(ls -d ^etc(/))
    ```

9. Haskell Tools (optional) #TODO: do later; skipped

    ```bash
    curl -sSL https://get.haskellstack.org/ | sh
    stack install ghc-mod hlint hasktags codex hscope pointfree pointful hoogle hindent apply-refact
    ```

10. Set permissions

    ```bash
    chmod u+x ~/.xmonad/bin/*.sh
    #chmod u+x ~/bin/*.sh
    ```

11. Set Wallpaper

    ```bash
    sh ~/.fehbg 
    ```


#### Favorite Firefox Add-ons
- [uBlock Origin](https://addons.mozilla.org/pt-br/firefox/addon/ublock-origin/)
- [HTTPS Everywhere](https://www.eff.org/https-everywhere)
- [Privacy Badger](https://addons.mozilla.org/pt-br/firefox/addon/privacy-badger-firefox/)
- [Self Destruction Cookies](https://addons.mozilla.org/pt-br/firefox/addon/self-destructing-cookies/)
- [NoScript](https://addons.mozilla.org/en-us/firefox/addon/noscript/)
- [Random Agent Spoofer](https://addons.mozilla.org/pt-br/firefox/addon/random-agent-spoofer/)
- [Tree Style Tab](https://addons.mozilla.org/pt-br/firefox/addon/tree-style-tab/)
- [Vimperator](https://addons.mozilla.org/en-us/firefox/addon/vimperator/)
- [NumberedTabs](https://addons.mozilla.org/En-us/firefox/addon/numberedtabs/)
- [Omnibar](https://addons.mozilla.org/en-us/firefox/addon/omnibar/)
- [Tile Tabs](https://addons.mozilla.org/en-us/firefox/addon/tile-tabs/)
- [GreaseMonkey](https://addons.mozilla.org/en-us/firefox/addon/greasemonkey/)
- [DownThemAll!](https://addons.mozilla.org/en-us/firefox/addon/downthemall/)
- [Session Manager](https://addons.mozilla.org/en-us/firefox/addon/session-manager/)
- [Send to XBMC/Kodi](https://addons.mozilla.org/en-US/firefox/addon/send-to-xbmc/)
- [Stylus Blue](https://addons.mozilla.org/de/firefox/addon/stylus-blue/)

