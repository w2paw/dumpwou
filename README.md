**dumpwou.sh** and **loadwou.sh** are two simple wrapper scripts I use to dump the memory of a Wouxun KG-UVD1P radio to a timestamped CSV (comma separated value) output file. File can then be edited and re-uploaded.

These tools **require** [owx](http://owx.chmurka.net/), in fact, that is what does much of the heavy lifting. This is just a wrapper script that removes intermedate files.

Why write a wrapper script? Well, I though the syntax of *owx* was awkward. Too many steps. I wanted one command to dump out my radio's current content (even if the radio was totally empty, brand new, or freshly reset), a familiar text editor to edit the entries, and another command to upload my edited file. I also wanted to keep a copy of my edited file around so I could perhaps rename it, and upload it to a different radio, or keep several profiles around for different tasks. 

The underlying *owx* pulls an non-editable binary file from the radio, which needs to be converted before it's human readable. To load a file, *owx* first needs a to convert the CSV into another binary file and then needs to be ordered to upload it.

The one thing this *quick-and-dirty* script doesn't do efficiently is upload. It doesn't matter if you tweak one CTCSS tone, the entire memory of the radio needs to be re-uploaded. If you're flashing something minor on a thousand radio, this tool is likely to waste a whole lot of your time as you wait and babysit the upload. But for one or two radios, I made the design choice to not do a `diff` against the binary file that was last downloaded to make the script easier to use. But if I ever revisit this script, that's likely the first feature to add. The underlying program can be used to only upload part of the radio's memory, and doing it that way can be quite a bit faster.

I'm using the programming cable I bought with the radio.    

`sudo apt-get install owx` #for the underlying software on Ubuntu-based systems. 

`lsusb|grep "PL2303"` # to find what name the serial port was assigned to on your PC. Example output: `Bus 004 Device 002: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial Port`

Presented in the hopes that it will be useful, but without any warranty. GNU GPLv3 

73 - w2paw

