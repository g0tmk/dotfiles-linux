#!/usr/bin/env bash

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

######## INSTALLER FUNCTIONS - ONE PER CATEGORY

stow_dotfiles () {
    # loop through all folders (except etc) and run stow to install them
    for folder in ./*/
    do
        # trim leading ./ and trailing / from the folder (ie "./bin/" to "bin")
        folder=$( echo "$folder" | sed -e "s/^\.\///g" | sed -e "s/\/$//g" )

        # etc folder needs to be stored to the root of the filesystem, so skip
        if [ "$folder" = "etc" ]; then
            continue
        fi

        echo "Stowing $folder..."
        stow "$folder"
    done
}

install_minimal_apps () {
    sudo apt install -y $(< ./app_list_minimal.txt)
}

install_extra_apps () {
    sudo apt install -y $(< ./app_list_extras.txt)
}

ask () {
    # asks for confirmation. param1 is question, param2 is function to run if yes
    read -p "$1 [y/n]" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        $2
        echo
    fi
}


ask "Install minimal apps?" install_minimal_apps
ask "Install extra apps (games, etc)?" install_extra_apps
ask "Install dotfiles?" stow_dotfiles
echo "Done!"

