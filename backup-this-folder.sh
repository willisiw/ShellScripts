#!/bin/bash
#
# Simple bash script to compress the current folder structure into a 
# tar.gz file in a backup folder under the current user home folder.
#
# Tested on various linux systems.

# Sets the date variable format for zipped file: MM-dd-yy_hh_mm
NOWDATE=`date +%Y-%m-%d_%H%M` 

# compress current folder.  change -cvz to -cz to silence output.
sudo tar -cvz * -f $HOME/backup/$NOWDATE-"${PWD##*/}".tar.gz

# display all files created with nowdate
ls -l $HOME/backup/$NOWDATE*
echo "Backup complete!"
