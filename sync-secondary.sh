#!/bin/bash
#
# Bash script to run on a SECONDARY web host.  Attempts a bi-directional
# sync of files with UNISON, then fails back to RSYNC.
#
# This script DELETES files that are NOT present on the PRIMARY.
#
# Prerequisites:
#
#  unison - fast file sync tool.  Must be configured for both systems.
#           bi-directional sync.
#           http://www.cyberciti.biz/faq/unison-file-synchronizer-tool/
#
#  rsync - ssh file copy tool. one-way from PRIMARY.  
#          Used for fallback on errors.
#
#
# SSH certificate for primary system and modify the /path/to/your.cer


from_email="server@example.com"
to_email="me@example.com"

# RSYNC via SSH options.
# see sshd documentation on how to setup ssh for access with a certificate.
# a password prompt would cause problems with this script.
cert_for_ssh="/path/to/your.cer"

# RSYNC options
rsync_user="username"
rsync_server="www1.example.com"
folder_path="/var/www"

# See documentation on setup of a unison profile.
unison_profile="default"



# start a scratch log to test for errors.
unison ${unison_profile} > unison.log
 
grep -q -i 'failed\|error' unison.log

if [ $? -eq 0 ]
then
  # If errors or failures
  echo unison has errors
  grep -q -i 'chown\|chmod' unison.log

  if [ $? -eq 0 ]
	then
    # If the errors are permission or ownership errors, run rsync as root to capture 
    # the changed permissions from the primary.
    
    # The --delete will DELETE files on the local system.
		sudo rsync -aurltv --delete -e 'ssh -i ${cert_for_ssh}' ${rsync_user}@${rsync_server}:${folder_path} ${folder_path}
	else
    # if the errors were not ownership errors, we will try to give it a second chance.
		if [ -e /home/ubuntu/sync.log ]
		then
      # If there is a sync.log then there were errors not
      # fixed by rsync. Tell someone.  This would be the second pass.
			echo [`date`] Unison has persistent errors >> unison.log
			echo [`hostname`] >> unison.log
			
			# Clear the file once an e-mail has been sent.
			rm sync.log
			# Optionally send message with errors.  Uncomment to use
			mail -aFrom:${from_email} -s 'Unison sync failing' ${to_email} unison.log
		else
			# create a file to identify that this is the first round of errors.
			echo Unison sync has errors > sync.log
		fi
		

	fi
 

else

  echo No errors in unison sync
  if [ -e /home/ubuntu/sync.log ]
  then
	# Clear the error marker since the errors were resolved.
	rm sync.log
  fi
fi



