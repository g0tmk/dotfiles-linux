#
# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

if [[ "$OSTYPE" == darwin* ]]; then
    export BROWSER='open'
fi

#
# Editors
#

export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

#
# Language
#

if [[ -z "$LANG" ]]; then
    export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
cdpath=(
    $cdpath
# /mnt/nas
# /mnt/nas/home
)

# Set the list of directories that Zsh searches for programs.
path=(
    /usr/local/{bin,sbin}
    $HOME/.cabal/bin
    $HOME/.xmonad/bin
    $HOME/bin
    $path
)

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-g -i -M -R -S -w -z-4'

# Set the Less input preprocessor.
if (( $+commands[lesspipe.sh] )); then
    export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
    export TMPDIR="/tmp/$USER"
    mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
if [[ ! -d "$TMPPREFIX" ]]; then
    mkdir -p "$TMPPREFIX"
fi

#
# auto-start x at login terminal. this will auto-start xmonad via .xsessionrc
# $DISPLAY is the name of the X display when inside an X server (NOTE: unset over ssh)
# $XDG_VTNR is the virtual terminal number
# NOTE: check for tty1 is needed or else new conky windows over SSH will try to call
# startx (XDG_VTNR is 1 but tty is not 1)
#
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]] && [[ $(tty) = /dev/tty1 ]]; then
    exec startx
fi


