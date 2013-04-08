#!/bin/bash
#
# Bash script to change the site permissions on the site
# located in the current folder, ie where you run the script
# from.  The script will test the local folder for an existing
# drupal site.
#
# Tested on a Drupal 7 site on Ubuntu 12.
#
# drupal_user & httpd_group variables should be customized.
#
# Adapted from http://drupal.org/node/244924


if [ $(id -u) != 0 ]; then
        printf "This script must be run as root.\n"
        exit 1
fi

drupal_path=$PWD
drupal_user="ubuntu"
httpd_group="www-data"

# Help menu
print_help() {
cat <<-HELP

This script is used to fix permissions of a Drupal installation
you must execute it in the base folder of a Drupal 7 site.

HELP
exit 0
}


if [ -z "${drupal_path}" ] || [ ! -d "${drupal_path}/sites" ] || [ ! -f "${drupal_path}/core/modules/system/system.module" ] && [ ! -f "${drupal_path}/modules/system/system.module" ]; then
	printf "Please provide a valid Drupal path.\n"
	print_help
	exit 1
fi

if [ -z "${drupal_user}" ] || [ $(id -un ${drupal_user} 2> /dev/null) != "${drupal_user}" ]; then
	printf "Please provide a valid user.\n"
	print_help
	exit 1
fi


cd $drupal_path
printf "Changing ownership of all contents of \"${drupal_path}\":\n user => \"${drupal_user}\" \t group => \"${httpd_group}\"\n"
chown -R ${drupal_user}:${httpd_group} .

printf "Changing permissions of all directories inside \"${drupal_path}\" to \"rwxr-x---\"...\n"
find . -type d -exec chmod u=rwx,g=rx,o= '{}' \;

printf "Changing permissions of all files inside \"${drupal_path}\" to \"rw-r-----\"...\n"
find . -type f -exec chmod u=rw,g=r,o= '{}' \;

printf "Changing permissions of \"files\" directories in \"${drupal_path}/sites\" to \"rwxrwx---\"...\n"
cd ${drupal_path}/sites
find . -type d -name files -exec chmod ug=rwx,o= '{}' \;
printf "Changing permissions of all files inside all \"files\" directories in \"${drupal_path}/sites\" to \"rw-rw----\"...\n"
printf "Changing permissions of all directories inside all \"files\" directories in \"${drupal_path}/sites\" to \"rwxrwx---\"...\n"

for x in ./*/files; do
	find ${x} -type d -exec chmod ug=rwx,o= '{}' \;
	find ${x} -type f -exec chmod ug=rw,o= '{}' \;
done


  if [ -e ${drupal_path}/sites/private ]
   then
     cd ${drupal_path}/sites/private
     echo [`date`] Changing permissions in $PWD
       sudo find . -type d -exec chmod ug=rwx,o= '{}' \;
       sudo find . -type f -exec chmod ug=rw,o= '{}' \;
  
    fi
      
      
   # fix permissions on sites/private folder
  
   if [ -e ${drupal_path}/private ]
   then
     cd ${drupal_path}/private
     echo [`date`] Changing permissions in $PWD
       sudo find . -type d -exec chmod ug=rwx,o= '{}' \;
       sudo find . -type f -exec chmod ug=rw,o= '{}' \;
  
    fi


echo "Completed setting proper permissions on files and directories"



