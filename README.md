## dotfiles


#### TODO:
- Xmobar config wifi adapter name only works with wifi on xps9550
- Check hist file after a while to see if zsh's KEYBOARD_HACK option is needed
- Figure out why xmobar is hidden by windows by default

#### Install steps on a fresh Debian (Testing) machine

0. Install Debian minimal system, install only "Standard System Utilities" and "Laptop" if needed.

1. Install base software

    ```bash
    sudo apt update
    sudo apt install git stow apt-transport-https
    git clone git://github.com/g0tmk/dotfiles-linux.git ~/dotfiles
    cd ~/dotfiles
    #sudo stow -t / etc # copy apt preferences: TODO: verify and uncomment
    sudo apt update
    sudo apt install -y $(< ~/dotfiles/app_list_minimal.txt)
    sudo apt install -y $(< ~/dotfiles/app_list_extras.txt) # optional
    ```

6. Set zsh as default shell

    ```bash
    chsh -s /bin/zsh
    # unpack only the zsh dotfiles for now
    cd ~/dotfiles
    stow zsh/
    ```

2. Install virtualbox

    ```bash
    # install virtualbox using their apt source:
    echo "deb https://download.virtualbox.org/virtualbox/debian stretch contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list
    wget -q -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo apt-key add
    sudo apt update
    sudo apt search virtualbox | grep ^virtualbox  # install the newest available
    sudo apt install virtualbox-6.x
    # you can now run `virtualbox`
    ```

3. Install sublime text & sublime merge

    ```bash
    # install using their apt source:
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    wget -q -O- https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add
    sudo apt update
    sudo apt install sublime-text sublime-merge
    # you can now run `subl` and `smerge`
    ```

4. Install firefox stable

    ```bash
    # download firefox from website and extract to a directory in home:
    # TODO: this doesn't work but should: wget https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US
    wget https://download-installer.cdn.mozilla.net/pub/firefox/releases/66.0.1/linux-x86_64/en-US/firefox-66.0.1.tar.bz2
    mkdir ~/bin ~/.mozilla
    tar -xf ./firefox* -C ~/.mozilla
    ln -s ~/.mozilla/firefox/firefox ~/bin/firefox
    ```

3. Set rxvt-unicode as default terminal emulator #TODO: do later; skipped

    ```bash
    # note: I did not need to run this. run '--display' instead of set to check
    sudo update-alternatives --set x-terminal-emulator /usr/bin/urxvt
    ```

4. Install Powerline #TODO: do later; skipped

    ```bash
    sudo apt-get install -y python-pip
    sudo pip install git+git://github.com/Lokaltog/powerline
    wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
    wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
    sudo mv PowerlineSymbols.otf /usr/share/fonts/
    sudo fc-cache -vf
    sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
    ```

5. Install prezto #TODO: do later; skipped

    ```bash
    git clone --recursive https://github.com/sorin-ionescu/prezto.git ~/.zprezto
    ```

7. Install screenfetch #TODO: do later; skipped

    ```bash
    wget -O screenfetch 'https://raw.github.com/KittyKatt/screenFetch/master/screenfetch-dev'
    chmod +x screenfetch
    sudo mv screenfetch /usr/local/bin/
    ```

8. Install Tmuxinator #TODO: do later; skipped

    ```bash
    sudo gem install tmuxinator
    ```

9. Stow dotfiles

    ```bash
    cd ~/dotfiles
    stow $(ls -d ^etc(/))
    ```

10. Haskell Tools (optional) #TODO: do later; skipped

    ```bash
    curl -sSL https://get.haskellstack.org/ | sh
    stack install ghc-mod hlint hasktags codex hscope pointfree pointful hoogle hindent apply-refact
    ```

    # TODO: manually download/install google-chrome .deb here


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

#### Notes
- Wired adapter names:
  - x220: enp0s25
  - xps9550:
- Wireless adapter names:
  - x220: wlp3s0
  - xps9550:
- Onboard display names (in xrandr):
  - x220: LVDS-1
  - xps9550:
- External display names (in xrandr):
  - x220: HDMI-1 (and probably also VGA-1)
  - xps9550:

#### Attributions
- https://gist.github.com/matthewmccullough/787142

