#! /bin/bash
#
# This script will backup your web data for several sites
# into a 14 different folders based on the day and week.
#
# Tested on Ubuntu 8, 10 & 12.  Should work on any Linux with bash.
#
#
#
# This is based on a backup script for a mail server, adapted to a web server.
#
# If run daily, this backup will eventually create two weeks of backups
# 0 or 1 MON-SUN 
#
# The SITESFOLDER is meant to be a base folder contining sub-folders which are
# each an individual site.

#Get the week number of the year and Day of Week
WEEK_NUM=$(date +%V)

#TAPE_SET will be 0 or 1
TAPE_SET=$(expr $WEEK_NUM % 2)
TAPE=$TAPE_SET$(date +%a) 


# Edit the following two values if necessary
SITESFOLDER="/var/www"
BACKUPFOLDER="/home/ubuntu/backup"
TARGET="$BACKUPFOLDER/$TAPE"



# Uncomment the next four lines and modify if you want to backup to a mount point
# This requires a predefined mount point setup in mtab.
# REMOTESERVER="myserver.example.com"
# if ! grep -q "$REMOTESERVER" /etc/mtab
# then 
#    mount /mnt/fileserver
# fi

#### END CUSTOM HEADER #####
#
# No more editing needed after this line
cd ${SITESFOLDER}

echo "Web sites Backup Starting [`date`] to $TARGET"
if [ -d $TARGET ]; then
     echo "Found Backup Directory ${TARGET}. Using It."
else
    echo "Creating Backup Directory ${TARGET} to backup sites."
    mkdir -p ${TARGET}
fi

# This command is designed to 
for i in $(ls -d */); do
    subfolder=`printf "$i" | sed -e 's:/::g'`
    cd ${SITESFOLDER}/${subfolder}
#
#  $subfolder = folder without trailing slash
#

    echo +++++++++++++++++++++++++++++++++++++++++++++
    echo [`date`] [`pwd`] backup started to [${TARGET}/${subfolder}.tar.gz]
    if [ -e ${TARGET}/${subfolder}.tar.gz ]; then
        echo "Existing backup found.  Deleting before creating new backup."
        rm -f ${TARGET}/${subfolder}.tar.gz
    fi

    sudo nice -n 19 tar -cz * -f ${TARGET}/${subfolder}.tar.gz
    echo [`date`] [${TARGET}/${subfolder}.tar.gz] backup completed.
    echo +++++++++++++++++++++++++++++++++++++++++++++
done



echo +++++++++++++++++++++++++++++++++++++++++++++
echo +++++++ Backup Folder Contents ++++++++++++++
echo +++++++++++++++++++++++++++++++++++++++++++++
ls -l $TARGET
echo
echo "Finished backing up web data. [`date`]"
echo

# This is a good spot to add a command to copy a local backup off the server.
# s3cmd sync $BACKUPFOLDER s3://bucketname --delete-removed
