#!/bin/bash
###########################
# Bonus Bash Functionality
# AlphaGriffin.com 2017
# Version: 1.0
# License: GPLv3
#$$$$$$$$$$$$$$$$$$$$$$$$$$

#!/bin/bash
# vim: foldmarker={{{,}}}
#
# helpers
# Author: Alexandre Keledjian <dervishe@yahoo.fr>
# Version: 1.0
# License: GPLv3
# 
#
# Some kind of library
#


LOG=./testlog.log
DELAY=5

# Log file Header
echo -e "\n\n#############################################################" >> $LOG
date >> $LOG
echo -e "\n\n" >> $LOG

HSTAR="\e[1;32m*\e[0m\e[37m"

function printResult()
{
	[[ $1 -ne 0 ]] && echo -e "\e[1;31m[FAIL]\e[0m" || echo -e "\e[1;32m[OK]\e[0m\e[37m"
	return 0
}

#	Take 1 argument: the location of the file to retrieve
function getFile() #{{{
{
	wget $1 >> $LOG 2>&1
	local BUFFER=$?
	printResult $BUFFER
	if [[ $BUFFER -ne 0 ]]; then 
		echo -e "\tThe file can't be retrieve. Check the name, the address or the connectivity."
		exit 1
	fi
	return 0
}
#}}}

#
#	Take 3 arguments (in order):
#		* The file name
#		* The hash file name
#		* The server's address
#	Before retrieving the file, it test its local presence and the signature
function retrieveFile() #{{{
{
	if [[ -f $1 ]]; then
		md5sum --quiet -c $2 >> $LOG 2>&1
		if [[ $? -ne 0 ]]; then
			rm $1 >> $LOG 2>&1
			getFile $3/$1
		else
			printResult 0
		fi
	else
		getFile $3/$1
	fi
}
#}}}

function checkConnectivity() #{{{
{
	ping -c 1 -w $DELAY www.google.com >> $LOG 2>&1
	local BUFFER=$?
	printResult $BUFFER
	[[ $BUFFER -ne 0 ]] && exit 1
	return 0
}
#}}}

function checkRoot() #{{{
{
	if [[ $EUID -ne 0 ]]; then
		printResult 1
		exit 1
	else
		printResult 0
	fi
}
#}}}

function checkGPG() #{{{
{
	which gpg >> $LOG 2>&1
	local BUFFER=$?
	printResult $BUFFER
	[[ $BUFFER -eq 1 ]] && exit 1
}
#}}}

function checkF2FS() #{{{
{
	which mkfs.f2fs >> $LOG 2>&1
	local BUFFER=$?
	printResult $BUFFER
	[[ $BUFFER -eq 1 ]] && exit 1
}
#}}}

function checkKBT() #{{{
{
	which imagetool-uncompressed.py >> $LOG 2>&1
	local BUFFER=$?
	printResult $BUFFER
	[[ $BUFFER -eq 1 ]] && exit 1
}
#}}}

#	Take 1 argument: the hash file of the file to test
function checkFingerprint() #{{{
{
	md5sum --quiet -c $1 >> $LOG 2>&1
	local BUFFER=$?
	printResult $BUFFER
	rm $1
	if [[ $BUFFER -eq 1 ]]; then 
		echo -e "\tBad fingerprint check result, archive corrupted !!!"
		exit 1;
	fi
}
#}}}

#	Take 2 arguments (in order):
#		* The signature file name
#		* The file name
function checkSignature() #{{{
{
	gpg --verify $1 $2 >> $LOG 2>&1
	local BUFFER=$?
	printResult $BUFFER
	rm $1
	return $BUFFER
}
#}}}

#	Take 1 argument:
#		* The crossdev prefix
function checkCrossdev() { #{{{
	ls ${1}* >> $LOG 2>&1
	local BUFFER=$?
	printResult $BUFFER
	[[ $BUFFER -eq  1 ]] && exit 1
}
#}}}

#	Take 1 argument:
#		* The kernel source URI
function getBranch() { #{{{
	git ls-remote $1 | grep -v "pull\|patch" | grep head | cut -d '/' -f 3 2> $LOG
}
#}}}

#	Take 1 argument:
#		* The branch name
#		* The kernel source URI
function checkBranch() { #{{{
	getBranch $2 | grep "^$1$" >> $LOG 2>&1
	echo $?
}
#}}}
