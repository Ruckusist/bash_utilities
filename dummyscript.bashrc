## /etc/bash/bashrc
##
## This file is sourced by all *interactive* bash shells on startup,
## including some apparently interactive shells such as scp and rcp
## that can't tolerate any output.  So make sure this doesn't display
## anything or bad things will happen !

##$$$$
## Test for an interactive shell.  There is no need to set anything
## past this point for scp and rcp, and it's important to refrain from
## outputting anything in those cases.
#if [[ $- != *i* ]] ; then
	## Shell is non-interactive.  Be done now!
	#return
#fi

## Bash won't get SIGWINCH if another process is in the foreground.
## Enable checkwinsize so that bash will check the terminal size when
## it regains control.  #65623
## http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
#shopt -s checkwinsize

## Disable completion when the input buffer is empty.  i.e. Hitting tab
## and waiting a long time for bash to expand all of $PATH.
#shopt -s no_empty_cmd_completion

## Enable history appending instead of overwriting when exiting.  #139609
#shopt -s histappend

## Save each command to the history file as it's executed.  #517342
## This does mean sessions get interleaved when reading later on, but this
## way the history is always up to date.  History is not synced across live
## sessions though; that is what `history -n` does.
## Disabled by default due to concerns related to system recovery when $HOME
## is under duress, or lives somewhere flaky (like NFS).  Constantly syncing
## the history will halt the shell prompt until it's finished.
##PROMPT_COMMAND='history -a'

## Change the window title of X terminals 
#case ${TERM} in
	#[aEkx]term*|rxvt*|gnome*|konsole*|interix)
		#PS1='\[\033]0;\u@\h:\w\007\]'
		#;;
	#screen*)
		#PS1='\[\033k\u@\h:\w\033\\\]'
		#;;
	#*)
		#unset PS1
		#;;
#esac

## Set colorful PS1 only on colorful terminals.
## dircolors --print-database uses its own built-in database
## instead of using /etc/DIR_COLORS.  Try to use the external file
## first to take advantage of user additions.
## We run dircolors directly due to its changes in file syntax and
## terminal name patching.
#use_color=true
#if type -P dircolors >/dev/null ; then
	## Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	#LS_COLORS=
	#if [[ -f ~/.dir_colors ]] ; then
		#eval "$(dircolors -b ~/.dir_colors)"
	#elif [[ -f /etc/DIR_COLORS ]] ; then
		#eval "$(dircolors -b /etc/DIR_COLORS)"
	#else
		#eval "$(dircolors -b)"
	#fi
	## Note: We always evaluate the LS_COLORS setting even when it's the
	## default.  If it isn't set, then `ls` will only colorize by default
	## based on file attributes and ignore extensions (even the compiled
	## in defaults of dircolors). #583814
	#if [[ -n ${LS_COLORS:+set} ]] ; then
		#use_color=true
	#else
		## Delete it if it's empty as it's useless in that case.
		#unset LS_COLORS
	#fi
#else
	## Some systems (e.g. BSD & embedded) don't typically come with
	## dircolors so we need to hardcode some terminals in here.
	#case ${TERM} in
	#[aEkx]term*|rxvt*|gnome*|konsole*|screen|cons25|*color) use_color=true;;
	#esac
#fi

#if ${use_color} ; then
	#if [[ ${EUID} == 0 ]] ; then
		#PS1+='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
	#else
		#PS1+='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
	#fi

	#alias ls='ls --color=auto'
	#alias grep='grep --colour=auto'
	#alias egrep='egrep --colour=auto'
	#alias fgrep='fgrep --colour=auto'
#else
	#if [[ ${EUID} == 0 ]] ; then
		## show root@ when we don't have colors
		#PS1+='\u@\h \W \$ '
	#else
		#PS1+='\u@\h \w \$ '
	#fi
#fi

#for sh in /etc/bash/bashrc.d/* ; do
	#[[ -r ${sh} ]] && source "${sh}"
#done

## Alias's

#alias ll="ls -l --color"


##smiley () { echo -e ":\\$(($??50:51))"; }
#sensors
##PS1="\h\$(smiley) \e[30;1m\w\e[0m\n\$ "
##PS1="\n\[\033[35m\]\$(/bin/date)\n\[\033[32m\]\w\n\[\033[1;31m\]\u@\h: \[\033[1;34m\]\$(/usr/bin/tty | /bin/sed -e 's:/dev/::'): \[\033[1;36m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files \[\033[1;33m\]\$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\033[0m\] -> \[\033[0m\]"
##PS1="\n\[\e[32;1m\](\[\e[37;1m\]\u\[\e[32;1m\])-(\[\e[37;1m\]jobs:\j\[\e[32;1m\])-(\[\e[37;1m\]\w\[\e[32;1m\])\n(\[\[\e[37;1m\]! \!\[\e[32;1m\])-> \[\e[0m\]"
#PS1="\n\[\e[30;1m\]\[\016\]l\[\017\](\[\e[34;1m\]\u@\h\[\e[30;1m\])-(\[\e[34;1m\]\j\[\e[30;1m\])-(\[\e[34;1m\]\@ \d\[\e[30;1m\])->\[\e[30;1m\]\n\[\016\]m\[\017\]-(\[\[\e[32;1m\]\w\[\e[30;1m\])-(\[\e[32;1m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\e[30;1m\])--> \[\e[0m\]"

##PS1="\n\[\033[35m\]\$(/bin/date)\n\[\033[32m\]\w\n\[\033[1;31m\]\u@\h: \[\033[1;34m\]\$(/usr/bin/tty | /bin/sed -e 's:/dev/::'): \[\033[1;36m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files \[\033[1;33m\]\$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\033[0m\] -> \[\033[0m\]"

##PS1="\[\e[30;1m\]\[\016\]\[\017\](\[\e[31;1m\]\u@\h\[\e[30;1m\])-(\[\e[31;1m\]\j\[\e[30;1m\])-(\[\e[31;1m\]\@ \d\[\e[30;1m\])->\[\e[30;1m\]\n\[\016\]\[\017\](\[\[\e[32;1m\]\w\[\e[30;1m\])-(\[\e[32;1m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files, \$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\e[30;1m\])-> \[\e[0m\]"







## Shortcuts to Other Known Machines for easy access
##alias aws = ??
##alias agserver = "agserver"
#alias mini="ssh root@10.42.100.197"
#alias opi="ssh root@opi"

#alias test="cd ~/Documents/;\
			#sudo python3 testing.py;\
			#nvidia-smi;
			#"


######################################
#
# Alphagriffin.com
# DummyScript.com
# 
# Dummy .bashrc 
# /home/<user>/.bashrc
######################################

# Check for Interactive session and if using inline cmd prompt for 
# other reasons then do not show anything and be done.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Disable completion when the input buffer is empty.  i.e. Hitting tab
# and waiting a long time for bash to expand all of $PATH.
shopt -s no_empty_cmd_completion

# Enable history appending instead of overwriting when exiting.  #139609
shopt -s histappend

# Save each command to the history file as it's executed.  #517342
# This does mean sessions get interleaved when reading later on, but this
# way the history is always up to date.  History is not synced across live
# sessions though; that is what `history -n` does.
# Disabled by default due to concerns related to system recovery when $HOME
# is under duress, or lives somewhere flaky (like NFS).  Constantly syncing
# the history will halt the shell prompt until it's finished.
#PROMPT_COMMAND='history -a'

# Change the window title of X terminals 
case ${TERM} in
	[aEkx]term*|rxvt*|gnome*|konsole*|interix)
		PS1='\[\033]0;\u@\h:\w\007\]'
		;;
	screen*)
		PS1='\[\033k\u@\h:\w\033\\\]'
		;;
	*)
		unset PS1
		;;
esac

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.
# We run dircolors directly due to its changes in file syntax and
# terminal name patching.
use_color=true
if type -P dircolors >/dev/null ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	LS_COLORS=
	if [[ -f ~/.dir_colors ]] ; then
		eval "$(dircolors -b ~/.dir_colors)"
	elif [[ -f /etc/DIR_COLORS ]] ; then
		eval "$(dircolors -b /etc/DIR_COLORS)"
	else
		eval "$(dircolors -b)"
	fi
	# Note: We always evaluate the LS_COLORS setting even when it's the
	# default.  If it isn't set, then `ls` will only colorize by default
	# based on file attributes and ignore extensions (even the compiled
	# in defaults of dircolors). #583814
	if [[ -n ${LS_COLORS:+set} ]] ; then
		use_color=true
	else
		# Delete it if it's empty as it's useless in that case.
		unset LS_COLORS
	fi
else
	# Some systems (e.g. BSD & embedded) don't typically come with
	# dircolors so we need to hardcode some terminals in here.
	case ${TERM} in
	[aEkx]term*|rxvt*|gnome*|konsole*|screen|cons25|*color) use_color=true;;
	esac
fi

if ${use_color} ; then
	if [[ ${EUID} == 0 ]] ; then
		PS1+='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
	else
		PS1+='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1+='\u@\h \W \$ '
	else
		PS1+='\u@\h \w \$ '
	fi
fi

for sh in /etc/bash/bashrc.d/* ; do
	[[ -r ${sh} ]] && source "${sh}"
done


# Start with the Sensors at the top of the screen
sensors
# then maybe do some fortune /header stuff

# This is similar to the ParrotOS stock bash
PS1="\[\033[0;31m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]root\[\033[01;33m\]@\[\033[01;96m\]\h'; else echo '\[\033[0;39m\]\u\[\033[01;33m\]@\[\033[01;96m\]\h'; fi)\[\033[0;31m\]]\342\224\200[\[\033[0;32m\]\w\[\033[0;31m\]]\n\[\033[0;31m\]\342\224\224\342\224\200\342\224\200\342\225\274 \[\033[0m\]\[\e[01;33m\]\\$\[\e[0m\]"

# Alias's
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias mini="ssh root@10.42.100.197"
alias opi="ssh root@opi"

alias test="cd ~/Documents/;\
			sudo python3 testing.py;\
			nvidia-smi; "
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# BUILT IN FUNCTIONS !
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi
