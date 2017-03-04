#!/bin/bash
#"""
#This Is an Update Script for All local Github Repos
#Ruckusist - 2017
#"""

# Variables
DELAY=5

# Logging these events
LOG=./update.log
exec &> >(tee -ia update.log)

TODAY=$(date)
HOST=$(hostname)
clear
echo "-----------------------------------------------------"
echo "Attempting to update this set of Github Libs"
echo "Date: $TODAY"
echo "Host: $USER@$HOST"
echo "-----------------------------------------------------"
function grep_status {
	for i in $( ls -d */); do
		# go into dir
		cd $i 
		# if git is up to date
		if git status | grep -q up-to-date; then
		 echo "Repo: $i is up to date"
		else
		 # if pulled latest
		 if git pull | grep -q Already; then
		  echo "Repo: $i has been updated"
		 else
		  echo "failed to pull new Repo for $i"
		 fi
		fi
		# back out of each dir as you work through
		cd ..
	done }

OPTIONS="Check_Folders About Quit"
#TEST="'ls -d */' Hello Quit"
select opt in $OPTIONS; do
   if [ "$opt" = "Check_Folders" ]; then
    grep_status
   elif [ "$opt" = "About" ]; then
	echo """Alphagriffin.com"""
   elif [ "$opt" = "Quit" ]; then
	echo done
	exit
   else
	echo bad option
   fi
done
