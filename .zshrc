# -*- coding: utf-8 -*-
# lastupdate 2009/10/25

# users generic .zshrc file for zsh(1)

# Environment variable configuration
#
# LANG
#
export LANG=ja_JP.UTF-8
case ${UID} in
0)
    LANG=C
    ;;
esac

## Default shell configuration
#
# set prompt
#
autoload colors
colors
case ${UID} in
0)
    PROMPT='%{[33m%}[%~]%(!.#.$)%{[m%} '
    RPROMPT="%{[32m%}%n@%m%{[m%} %{[36m%}%D{%Y/%m/%d %H:%M:%S}%{[m%}"
    SPROMPT="%r is correct? [n,y,a,e]"

    ;;
*)
    PROMPT='%{[33m%}[%~]%(!.#.$)%{[m%} '
    RPROMPT="%{[32m%}%n@%m%{[m%} %{[36m%}%D{%Y/%m/%d %H:%M:%S}%{[m%}"
    SPROMPT="%r is correct? [n,y,a,e]"
    ;;
esac

# auto change directory
#
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
#
setopt auto_pushd

# command correct edition before each completion attempt
#
setopt correct

# compacked complete list display
#
setopt list_packed

# no remove postfix slash of command line
#
setopt noautoremoveslash

# no beep sound when complete list displayed
#
setopt nolistbeep

# historical backward/forward search with linehead string binded to ^P/^N
#
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end


## Command history configuration
#
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data


## Completion configuration
#
fpath=(~/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit


## zsh editor
#
autoload zed


## Prediction configuration
#
#autoload predict-on
#predict-off


## Alias configuration
#
# expand aliases before completing
#
setopt complete_aliases     # aliased ls needs if file/dir completions work

alias where="command -v"
alias j="jobs -l"

case "${OSTYPE}" in
freebsd*|darwin*)
    alias ls="ls -G -w"
    ;;
linux*)
    alias ls="ls --color=auto"
    ;;
esac

alias la="ls -la"
alias lf="ls -F"
alias ll="ls -l"

alias du="du -h"
alias df="df -h"

alias su="su -l"

# for screen
alias screen="TERM=screen screen -U" 

case "${OSTYPE}" in
darwin*)
    alias updateports="sudo port selfupdate; sudo port outdated"
    alias portupgrade="sudo port upgrade installed"
    ;;
freebsd*)
    case ${UID} in
    0)
        updateports() 
        {
            if [ -f /usr/ports/.portsnap.INDEX ]
            then
                portsnap fetch update
            else
                portsnap fetch extract update
            fi
            (cd /usr/ports/; make index)

            portversion -v -l \<
        }
        alias appsupgrade='pkgdb -F && BATCH=YES NO_CHECKSUM=YES portupgrade -a'
        ;;
    esac
    ;;
esac


## terminal configuration
#
unset LSCOLORS
case "${TERM}" in
xterm)
    # export TERM=xterm-color
    ;;
kterm)
    # export TERM=kterm-color
    # set BackSpace control character
    stty erase
    ;;
cons25)
    unset LANG
    ;;
esac

# set terminal title including current directory
#
case "${TERM}" in
kterm*|xterm*)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

# color settings
export LSCOLORS=Gxfxcxdxbxegedabagacad
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors \
	'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# completation (ignorecase)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

#
# Includes
#
source ~/.profile
source ~/.aliases
