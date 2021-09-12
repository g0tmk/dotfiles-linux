# Install WoW on Linux
NOTE: this was done on Ubuntu 17.10

### Install wine:

    wget -nc https://dl.winehq.org/wine-builds/Release.key
    sudo apt-key add Release.key
    sudo apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/
    sudo apt update
    sudo apt install --install-recommends winehq-staging

At this point, apt threw an error. So run this:

    sudo apt install -f
    sudo apt install --install-recommends winehq-staging

Done! run `wine64 --version` to verify

### Install Lutris (Using guide from https://lutris.net/downloads/)

    ver=$(lsb_release -sr); if [ $ver != "18.10" -a $ver != "18.04" -a $ver != "16.04" ]; then ver=18.04; fi
    echo "deb http://download.opensuse.org/repositories/home:/strycore/xUbuntu_$ver/ ./" | sudo tee /etc/apt/sources.list.d/lutris.list
    wget -q https://download.opensuse.org/repositories/home:/strycore/xUbuntu_$ver/Release.key -O- | sudo apt-key add -
    sudo apt update
    sudo apt install lutris

### Installing WoW:

 - Startup lutris: `lutris`
 - Install WoW dependencies (I followed this https://github.com/lutris/lutris/wiki/Game:-World-of-Warcraft)
   - `sudo dpkg --add-architecture i386`
   - `sudo apt install libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libsqlite3-0:i386`
 - Install World of Warcraft in Lutris
 - For non-DXVK hardware only (intel sandybridge gpus or earlier)
   - Once installed, right-click WoW in Lutris and select "configure", uncheck "enable DXVK" in "Runner options"
   - In Lutris options, select "Manage Runners", scroll down to "Wine" and select "configure", add "PBA_ENABLE=1" to environment variables"
 - Run WoW! If you get errors, see below
   - Streaming Error [WOW51900322] when logging in:
     - Exit WoW.
     - Download Cache.zip and use it to overwrite ~/Games/world-of-warcraft/drive_c/Program Files (x86)/World of Warcraft/Cache (Cache.zip here <https://github.com/1thumbbmcc/wowcache.git>), then re-launch WoW.
