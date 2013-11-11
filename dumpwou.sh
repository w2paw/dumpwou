#!/bin/sh

# dumpwou - a program to dump the memory of a wouxun KG-UVD1P to a timestamped
#	    CSV output file. File can then be edited and reuploaded.

# requires owx, in fact, that is what does much of the heavy lifting. This is
#+just a wrapper script that removes intermedate files.

# sudo apt-get install owx # to install on Ubuntu based systems. 

# Notes:
# find serial port:  lsusb|grep "PL2303"
#example output: Bus 004 Device 002: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port


##########
# SETUP
##########
# note: we'll have to fix this to look for the right port number 
PORT='/dev/ttyUSB0' #hardcoded port number

# we need two scratch files  
# files are kept in ram, but just as easly could have been in /tmp
# We're also using `date` to generate unique file name 
file1="/dev/shm/$(date +'%s-%N')" 
file2="/dev/shm/$(date +'%s-%N')"
fileOutput="./$(date +'%Y_%m_%d_%R')_freq.csv"

##########
# MAIN
##########

{ 
	#/usr/sbin/owx -c check -p $PORT 	&& 
	#echo "CONNECTED to $PORT" 	;	
	owx -c get -p $PORT -o "${file1}"	&&
	echo "downloded binary file"	;
	owx -c export -i "${file1}" -o "${file2}" && 
	echo "csv file created"	;
	echo  	;
	echo  ;
	cp ${file2} ${fileOutput}

}

##########
# CLEANUP
##########

rm ${file1}
rm ${file2}

exit

