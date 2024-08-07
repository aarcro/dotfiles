# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
umask 0027

#TERM=screen

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export VISUAL=vim

# Check for brew
if [ $(which brew 2> /dev/null) ] ; then
    BREW_PATH=`brew --prefix`
    export PATH=${BREW_PATH}/opt/coreutils/libexec/gnubin:${BREW_PATH}/sbin:${PATH}
fi

# ARM Mac
if [ -d /opt/homebrew/ ] ; then
    export HOMEBREW_PREFIX="/opt/homebrew";
    export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
    export HOMEBREW_REPOSITORY="/opt/homebrew";
    export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}";
    export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:";
    export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
    BREW_PATH=`brew --prefix`
fi


# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
    ansi) color_prompt=yes;;
    screen) color_prompt=yes;;
    screen-bce) color_prompt=yes;;
    screen-256color-bce) color_prompt=yes;;
    screen.xterm-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\[\033[0;36m\]$(git branch 2> /dev/null | grep -e "\* " | sed "s/^..\(.*\)/{$(basename $(git rev-parse --show-toplevel 2> /dev/null) 2> /dev/null):\1}:/")\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(git branch 2> /dev/null | grep -e "\* " | sed "s/^..\(.*\)/{$(basename $(git rev-parse --show-toplevel 2> /dev/null) 2> /dev/null):$\1}:/")\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

#if [ -f ~/.bash_aliases ]; then
#    . ~/.bash_aliases
#fi

alias vissh="vi ~/.ssh/config"

alias gc="git commit -a"
alias gd="git diff"
alias gl="git log --decorate --graph"
alias gp="git pull --ff-only"
alias gs="git status"

alias pbjson='pbpaste | json_pp | pbcopy'
alias pbpull='ssh ets pbpaste | pbcopy'
alias pbpush='pbpaste  | ssh ets pbcopy'

# Always post private and copy to clip board
alias gist="gist -pc"


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b ~/.dir_colors`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
else
    # Probably Mac, this will help
    export CLICOLOR=1
    export LSCOLORS=gxFxCxDxBxegedabagacad
fi

# Newer Mac
if [ -x /usr/local/opt/coreutils/libexec/gnubin/dircolors ]; then
    eval "`dircolors -b ~/.dir_colors`"
    alias ls='ls --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
    echo "Extended Complete enabled"
fi
#Or on Solaris
if [ -f /opt/csw/etc/bash_completion ]; then
    . /opt/csw/etc/bash_completion
    echo "Extended Complete enabled"
fi
# Or Mac (with homebrew)
if [ -n "$BREW_PATH" ]; then
  if [ -f $BREW_PATH/etc/bash_completion ]; then
    . $BREW_PATH/etc/bash_completion
    echo "Extended Complete enabled"
  fi
fi

# ARM Mac (with homebrew)
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

. ~/bin/django_bash_completion
. ~/.homesick/repos/homeshick/completions/homeshick-completion.bash

alias here='cd `pwd -P`'

case $( uname -s ) in
	SunOS )
		export PATH=/opt/SUNWspro/bin:/ndnp/staging/python2.6/bin:/usr/ccs/bin:/ndnp/staging/mysql5/bin:/usr/bin:/sbin:/usr/local/sbin:/usr/sbin:/opt/local/bin:/opt/csw/bin
        export LD_CONFIG_32=/ndnp/staging/ld.config
		alias sudo=pfexec
        alias tar=gtar
        alias ls='gls --color'
        #Solaris lacks dircolors, these were built on 2010-05-10 on ds
        LS_COLORS='no=00:fi=00:di=00;36:ln=target:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:';
        export LS_COLORS
		;;
esac

export PATH=~/bin:${PATH}:/usr/sbin:/sbin

#For some reason using screen requires this
alias vi=vim

function random_value ()
{
# Fix tr for OSX
LC_CTYPE=C tr -dc '[:alnum:]' < /dev/urandom | fold -w ${1:-32} | head -n 1
}

function type_find ()
{
    TYPE=$1
    shift
    find . -path "./.*" -prune -o -path "*_env" -prune -o -path "*node_modules" -prune -o -name \*$TYPE -type f -exec grep -H "$@" {} \;
    unset TYPE
}

function py_find ()
{
    type_find py "$@"
}

function table ()
{
  awk -F: '{gsub(/^  */, "", $2); printf("%-50s %s\n", $1, $2)}'
}

#Virtenv wrapper
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
if [ -n "$BREW_PATH" ]; then
    # Prefer python3 for virtual env
    if [ -x $BREW_PATH/bin/python3 ]; then
        export VIRTUALENVWRAPPER_PYTHON=$BREW_PATH/bin/python3
    elif [ -x $BREW_PATH/bin/python ]; then
        export VIRTUALENVWRAPPER_PYTHON=$BREW_PATH/bin/python
    fi
fi

if [ -d /opt/virtual_envs ]; then
    export WORKON_HOME=/opt/virtual_envs
else
    export WORKON_HOME=~/virtual_envs
fi

# NVM stuff
if [ -f /usr/local/opt/nvm/nvm.sh ] ; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
	[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi


# NVM, but ARM mac
if [ -f /opt/homebrew/opt/nvm/nvm.sh ] ; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi

#Lazy breaks tab completion for workon :(
#if [ -f /usr/local/bin/virtualenvwrapper_lazy.sh ]; then
#    source /usr/local/bin/virtualenvwrapper_lazy.sh
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
#CentOS
elif [ -f /usr/bin/virtualenvwrapper.sh ]; then
    source /usr/bin/virtualenvwrapper.sh
fi

alias newproject="/bin/bash ~/newproject.sh"

if [ -f $HOME/.pythonrc.py ]; then
    export PYTHONSTARTUP=$HOME/.pythonrc.py
fi

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end

if [ -f $HOME/.homesick/repos/homeshick/homeshick.sh ]; then
    source $HOME/.homesick/repos/homeshick/homeshick.sh
else
    echo "homeshick is out of date"
    alias homeshick="source $HOME/.homesick/repos/homeshick/bin/homeshick.sh"
fi
alias start_gunicorn="if [[ -x ./manage.py ]] ; then ./manage.py run_gunicorn localhost:8080 --timeout 3600 --graceful-timeout=3600 --pid=../../tmp/gunicorn.pid ; else echo 'No manage.py fournd' ; fi"

complete -W "$([ -f ~/.ssh/config ] && grep -v "[?*]" ~/.ssh/config | awk '/^Host / {sub("^Host ", ""); print $0;}') $([ -f ~/.ssh/known_hosts ] && echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
alias start_gunicorn="if [[ -x ./manage.py ]] ; then ./manage.py run_gunicorn localhost:8080 --timeout 3600 --graceful-timeout=3600 --pid=../../tmp/gunicorn.pid ; else echo 'No manage.py found' ; fi"
alias collectstatic="if [[ -x ./manage.py ]] ; then ./manage.py collectstatic --noinput ; else echo 'No manage.py found' ; fi"

# Static AUTH_SOCK for screen
if [ -S "$SSH_AUTH_SOCK" ] && [ ! -h "$SSH_AUTH_SOCK" ]; then
    ln -sf "$SSH_AUTH_SOCK" ~/.agent
fi
export SSH_AUTH_SOCK=~/.agent

if [ -f ~/.bashrc_local ]; then
    #Here's a chance to do crazy local stuff
    . ~/.bashrc_local
fi
alias back='cd ${ACM_BACK_DIR}'
alias mark='ACM_BACK_DIR=`pwd`'
alias docker-on='eval $(docker-machine env default)'
alias docker-aws='eval $(aws ecr get-login)'
alias fix-docker-clock='docker run --rm --privileged alpine hwclock -s'

# Termbin!
alias tb="nc termbin.com 9999"

alias do_sum="paste -sd+ - | bc"

# Might want this for pyenv
if [ $(which pyenv 2> /dev/null) ] ; then
    eval "$(pyenv init -)"
fi

# django on docker enterypoint
function manage ()
{
    if [ -f docker-compose.yml ] ; then
        docker-compose run --rm web "$@"
    else
        echo "Only use this in a directory with a docker-compose.yml file"
    fi
}

function unzip_all ()
{
    find . -name '*.zip' -execdir unzip -u '{}' ';'
}

alias s3_services='aws s3 sync s3://mytime-merchant-data-ingestion-qa/petco-services /Users/aarmcm/tmp/s3/mytime-merchant-data-ingestion-qa/petco-services'

# alias isort='pipenv run isort -rc --atomic .'
alias lock='time docker-compose -f docker-compose.tools.yml run --rm lock'
alias rehash="hash -r"
alias settz="sudo systemsetup -settimezone $@"
alias yapf='yapf -ir .'

if [ -f ${BREW_PATH}/opt/autoenv/activate.sh ]; then
    # AUTOENV_AUTH_FILE: Authorized env files, defaults to ~/.autoenv_authorized
    # AUTOENV_ENV_FILENAME: Name of the .env file, defaults to .env
    # AUTOENV_LOWER_FIRST: Set this variable to flip the order of .env files executed
    # AUTOENV_ENV_LEAVE_FILENAME: Name of the .env.leave file, defaults to .env.leave
    # AUTOENV_ENABLE_LEAVE: Set this to a non-null string in order to enable source env when leaving
    # AUTOENV_ASSUME_YES: Set this variable to silently authorize the initialization of new environments

    AUTOENV_ENV_FILENAME=.env.auto
    AUTOENV_ENV_LEAVE_FILENAME=.env.leave
    AUTOENV_ENABLE_LEAVE=yes

    source ${BREW_PATH}/opt/autoenv/activate.sh
else
    echo "autoenv not found"
fi

alias chia-disks="df -h | grep -v -e loop -e tmpfs"

# Run one time to update a repo to use the petco key
alias petco-git="git config core.sshCommand 'ssh -i ~/.ssh/id_petco_gitlab -o IdentitiesOnly=yes -F /dev/null'"
# Run to clone petco repos
alias petco-clone="GIT_SSH_COMMAND='ssh -i /Users/aarmcm/.ssh/id_petco_gitlab -o IdentitiesOnly=yes' git clone"
export PATH="$PATH:$HOME/dev/carta-toolbox/scripts"
