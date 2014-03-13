# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
umask 0027

#TERM=screen

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export VISUAL=vim

# Check for brew
if which brew > /dev/null; then
    BREW_PATH=`brew --prefix`
    export PATH=${BREW_PATH}/sbin:${PATH}
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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\033[0;36m$(git branch 2> /dev/null | grep -e "\* " | sed "s/^..\(.*\)/{\1}:/")\033[00m\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(git branch 2> /dev/null | grep -e "\* " | sed "s/^..\(.*\)/{\1}:/")\$'
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

function type_find {
    TYPE=$1
    shift 1
    find ./ -name \*$TYPE -exec grep -H $@ {} \;
}

function py_find {
    type_find py $@
}

#Virtenv wrapper
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
if [ -n "$BREW_PATH" ]; then
    if [ -x $BREW_PATH/bin/python ]; then
        export VIRTUALENVWRAPPER_PYTHON=$BREW_PATH/bin/python
    fi
fi

if [ -d /opt/virtual_envs ]; then
    export WORKON_HOME=/opt/virtual_envs
else
    export WORKON_HOME=~/virtual_envs
fi

#Lazy breaks tab completion for workon :(
#if [ -f /usr/local/bin/virtualenvwrapper_lazy.sh ]; then
#    source /usr/local/bin/virtualenvwrapper_lazy.sh
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
    source /usr/local/bin/virtualenvwrapper.sh
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

complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh
alias start_gunicorn="if [[ -x ./manage.py ]] ; then ./manage.py run_gunicorn localhost:8080 --timeout 3600 --graceful-timeout=3600 --pid=../../tmp/gunicorn.pid ; else echo 'No manage.py found' ; fi"
alias collectstatic="if [[ -x ./manage.py ]] ; then ./manage.py collectstatic --noinput ; else echo 'No manage.py found' ; fi"

if [ -f ~/.bashrc_local ]; then
    #Here's a chance to do crazy local stuff
    . ~/.bashrc_local
fi
