#!/bin/sh

# loadwou - a program to load a CSV file into the memory of a wouxun KG-UVD1P
#	    radio. Also see "dumpwou.sh". 
#	    

# requires owx, in fact, that is what does much of the heavy lifting. This is
#+just a wrapper script that removes intermedate files.

# sudo apt-get install owx # to install on Ubuntu based systems. 

# Notes:
# find serial port:  lsusb|grep "PL2303"
#example output: Bus 004 Device 002: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port
# find /dev -name "ttyU*"

	

##########
# SETUP
##########
# note: we'll have to fix this to look for the right port number 

#PORT='/dev/ttyUSB0' #hardcoded port number

for x in $(find /dev -name "ttyU*") ; do
	owx-check -p "$x"
	if [ "$?" = "0" ] ; then 
		PORT="$x"
		echo "debug: port was autoset to $PORT"
		break
	fi
done
	

ulFile="$1" # file to be uploaded

file1="/dev/shm/$(date +'%s-%N')"

#echo "${ulFile}"
#echo "${file1}"
#echo "${PORT}"
#echo "--------------"
#exit #debug


chkexit () { 
	x="$?"
	if [ "$x" != "0" ] ; then 
		echo "program halted, chkexit detected an error: $x"
		exit "$x"
	fi
}


##########
# MAIN
##########
#Example of usage were we to use owx manually
#
#	owx-get -o file.bin 			#dump file
#	cp file.bin backup.bin 			#make a copy
#	owx-export -i file.bin -o wouxun.csv 	#convert to csv
#	oocalc wouxun.csv 			# edit
#*	owx-import -i wouxun.csv -o file.bin	# convert csv to bin
#*	owx-put -i file.bin -r backup.bin	# upload bin

{
	true
	chkexit
 
	# check port
	sleep 5
	echo "debug: about to check port" 
	owx-check -p "$PORT"
	chkexit

	# check ul file TBD

	# convert to binary file
	sleep 5
	echo "debug: about to d/l the binary file from HT" 
	owx-get -p "$PORT" -o "${file1}" 			#dump file currently in handheld
	chkexit 
		# we then overwrite this file in the next step
		# yes, it's stupid, but I didn't write owx
		# this is needed because owx-import won't create a bin file from scratch
	sleep 5
	echo "debug: about to convert csv to a bin" 
	owx-import -i "${ulFile}" -o "${file1}"	# convert csv to bin, overwriting dumped bin
	chkexit 

	# check port again
	sleep 5
	echo "debug: about to check port 2nd time" 
	owx-check -p "$PORT"
	chkexit

	# upload to serial port
	sleep 9
	echo "debug: about to u/l file" 
	owx-put -p "$PORT" -i "${file1}"			# upload bin
	chkexit 
	# 				# note, we don't use a reference file
	#				# slower, but works every time
	# done

}

##########
# CLEANUP
##########
rm "${file1}"

exit

