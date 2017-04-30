#!/bin/bash

# This attempts a better bash boot screen

function bashinfo() {
	# test="teawtawet $BASH_VERSINFO[4]"
	center_h ${BASH_VERSINFO[0]}

	# for n in 0 1 2 3 4 5
	# do
	#  echo "BASH_VERSINFO[$n] = ${BASH_VERSINFO[$n]}"
	#done  

	# BASH_VERSINFO[0] = 3                      # Major version no.
	# BASH_VERSINFO[1] = 00                     # Minor version no.
	# BASH_VERSINFO[2] = 14                     # Patch level.
	# BASH_VERSINFO[3] = 1                      # Build version.
	# BASH_VERSINFO[4] = release                # Release status.
	# BASH_VERSINFO[5] = i386-redhat-linux-gnu  # Architecture
												# (same as $MACHTYPE).
	
} 

function vcenter() {

  text=$1

  rows=`tput lines`

  text_length=`echo -e $text | wc -l`
  half_of_text_length=`expr $text_length / 2`

  center=`expr \( $rows / 2 \) - $half_of_text_length`

  lines=""

  for ((i=0; i < $center; i++)) {
    lines="$lines\n"
  }

  echo -e "$lines$text$lines"
}

function hcenter() {

  text="$1"

  cols=`tput cols`

  IFS=$'\n'$'\r'
  for line in $(echo -e $text); do

    # line_length=`echo $line | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g"` 
    line_length=`echo $line| wc -c`
    half_of_line_length=`expr $line_length / 2`
    center=`expr \( $cols / 2 \) - $half_of_line_length`

    spaces=""
    for ((i=0; i < $center; i++)) {
      spaces="$spaces "
    }

    echo "$spaces$line"

  done

}


# example:
# >>> center "Alphagriffin.com"
# takes 1 arguement
function center_v() {
  text="$1"
  vcenter "`hcenter $text`"
}

function center_h() {
  text="$1"
  hcenter $text
}


# case ${TERM} in
#	#[aEkx]term*|rxvt*|gnome*|konsole*|interix)
#		#PS1='\[\033]0;\u@\h:\w\007\]'
#		#;;
#	#screen*)
#		#PS1='\[\033k\u@\h:\w\033\\\]'
#		#;;
#	#*)
#		#unset PS1
#		#;;
#esac
#bashinfo
#TEST="Lord $USER of $HOST\n\n\
#	  Master of\n##$MACHTYPE##\n
#	  
#	  Alphagriffin.com\n\
#	  DummyScript.com"

# echo "$TEST"
center_v "AlphaGriffin.com\nDummyScript.com"
