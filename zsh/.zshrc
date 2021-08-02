#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# add custom bin folder
export PATH=~/bin:$PATH

# add python binaries folder (executables installed by pip are stored here)
export PATH=~/.local/bin:$PATH

## Load pws prompt and add path to RPROMPT. TODO: get g0tmk prompt off bmbp
autoload -U promptinit
promptinit
prompt pws
RPROMPT="%F{green}%~%f"

# Import colorscheme from 'wal' asynchronously
# # &   # Run the process in the background.
# # ( ) # Hide shell job control messages.
#(cat ~/.cache/wal/sequences &)

## Source Prezto.
#if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
#  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
#fi


# Rebind / (search) to use default zsh search mode instead of vim one
bindkey -M vicmd '/' history-incremental-pattern-search-backward


# Aliases
if [ -f ~/.zaliases ]; then
    source ~/.zaliases
else
    print "404: ~/.zaliases not found."
fi


# For renaming groups of files. Examples: 
# zmv  'juliet-(*)' 'prospera-$1'
# zmv '(*).sh' '$1'

# Passing -n to zmv will show you what zmv would do, without doing anything. 
autoload zmv

# show Cabal sandbox status
#function cabal_sandbox_info() {
#    cabal_files=(*.cabal(N))
#    if [ $#cabal_files -gt 0 ]; then
#        if [ -f cabal.sandbox.config ]; then
#            echo "%{$fg[green]%}sandboxed%{$reset_color%}"
#        else
#            echo "%{$fg[red]%}not sandboxed%{$reset_color%}"
#        fi
#    fi
#}


##############################################################################
# History Configuration
##############################################################################
HISTSIZE=10000                 # How many lines of history to keep in memory
HISTFILE=~/.zsh_history       # Where to save history to disk
SAVEHIST=10000                 # Number of history entries to save to disk
HISTDUP=erase                 # Erase duplicates in the history file
setopt extended_history       # Use ":start:elapsed;command" history format.
setopt hist_expire_dups_first # Expire duplicates first when trimming history.
setopt hist_ignore_dups       # Don't record an entry that was just recorded.
setopt hist_ignore_all_dups   # Delete old entry if new entry is a duplicate.
setopt hist_find_no_dups      # Do not display a line previously found.
setopt hist_ignore_space      # Don't record an entry starting with a space.
setopt hist_save_no_dups      # Don't write duplicate entries to disk.
setopt hist_reduce_blanks     # Remove superfluous blanks before recording.
setopt hist_verify            # Don't execute immediately upon hist expansion.
#setopt hist_beep              # Beep when accessing nonexistent history.
setopt appendhistory          # Append to the history file (no overwriting).
setopt sharehistory           # Share history across terminals
setopt incappendhistory       # Immediately append to file, not just on exit.

 
#PROMPT='%F{59}[$HISTCMD] '$PROMPT
#RPROMPT="\$(cabal_sandbox_info) $RPROMPT"

# Always start with 256 colors
export TERM=xterm-256color


