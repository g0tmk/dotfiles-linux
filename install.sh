#!/usr/bin/env bash

#
# g0tmk's dotfiles install script
#
# what this does:
#  - install app list via apt
#  - link all dotfiles into home
#  - change shell to zsh
#  - change terminal to urxvt
#  - installs custom fonts
#  - detect hardware sensors with sensors-detect
#
# assumes:
#  - you want repositories installed to ~/repos/
#

set -eEuo pipefail


######## PRE-INSTALL CHECKS

# verifies we are running this from the right place (dotfiles dir) by checking
# that the app list and .git is in the current working directory.. not foolproof
if [ ! -f ./app_list_minimal.txt ] || [ ! -d ./.git ]; then
    echo "ERROR: This should be run from the dotfiles directory; cd there first"
    exit 1
fi

# verify this dir's parent dir is equal to $HOME dir
dir="`pwd`/.."
parentdir=`eval "cd $dir;pwd;cd - > /dev/null"`
if [ "$parentdir" != "$HOME" ]; then
    echo "ERROR: This folder ("$(basename `pwd`)") should be inside your home dir"
    exit 1
fi

# verify there are no pending updates
# no updates if output of "apt list --upgradeable" is only a single line
echo "Updating apt sources (may require sudo password)..."
sudo apt -qq update
if [ $(apt list --upgradeable 2>/dev/null | wc -l) != "1" ]; then
    echo "ERROR: Pending updates, run \"sudo apt upgrade\" first."
    exit 1
fi


######## INSTALLER FUNCTIONS

ask () {
    # asks for confirmation. param1 is question, param2 is function to run if yes
    # flush stdin
    read -t 0.1 -n 10000 discard || true
    # read one char
    read -p "$1 [y/n]" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        $2
    fi
    echo
}

install_apps () {
    # sudo apt install $(< "$1")
    # sed removes comments from app list files
    sudo apt install $(sed -E 's/ *#.*//' < "$1")
}

clone_repo () {
    mkdir -p /home/$USER/repos 2> /dev/null
    if [ -d "/home/$USER/repos/$1" ]; then
        echo "/home/$USER/repos/$1 exists"
    else
        git clone "$2" "/home/$USER/repos/$1" 2> /dev/null
    fi
}

clone_all_repos () {
    clone_repo pystatusbar https://github.com/g0tmk/pystatusbar.git
    clone_repo picom https://github.com/yshui/picom.git
}

stow_dotfiles () {
    # loop through all folders (except etc) and run stow to install them
    echo -n "Stowing... "
    for folder in ./*/
    do
        # trim leading ./ and trailing / from the folder (ie "./bin/" to "bin")
        folder=$( echo "$folder" | sed -e "s/^\.\///g" | sed -e "s/\/$//g" )

        # etc folder needs to be stored to the root of the filesystem, so skip
        if [ "$folder" = "etc" ]; then
            continue
        fi

        echo -n "$folder "
        stow "$folder"
    done
    echo
}

font_setup () {
    echo "Updating font cache..."
    fc-cache
    ask "Hit enter to open font wizard. Choose Native, Slight, Automatic, Yes." stow_dotfiles
    sudo dpkg-reconfigure fontconfig-config
}

change_settings () {
    echo "Changing shell to zsh..."
    chsh -s /bin/zsh
    echo "Changing terminal to urxvt..."
    sudo update-alternatives --set x-terminal-emulator /usr/bin/urxvt
    echo "Detecting hardware sensors..."
    sudo sensors-detect
}


f(){ install_apps "./app_list_minimal.txt"; }; ask "Install minimal apps?" f
f(){ install_apps "./app_list_extras.txt"; }; ask "Install extra apps (games, etc)?" f
ask "Install missing repositories?" clone_all_repos
ask "Install dotfiles?" stow_dotfiles
ask "Change settings (shell, alternatives)?" change_settings
ask "Update font cache/settings?" font_setup
echo "Done!"


