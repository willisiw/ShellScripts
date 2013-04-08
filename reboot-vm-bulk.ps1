# PowerShell script
#
# Reboot multiple Virtual Machines on a single vCenter server based on a name with a wildcard.
#
#
# Prerequisites
# vCenter 4 or vCenter 5 with
# Windows PowerShell
# VMWare Power CLI http://kb.vmware.com/kb/2032946
#
# Windows Scheduled Task
# Program:
# C:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe
# 
# Arguments:
# -file C:\scriptfolder\reboot-vms.ps1
#


# Add the vmware snapin for powershell
Add-PSSnapin VMware.VimAutomation.Core

# Set some variables.
$datestart = (get-date -uformat %Y-%m-%d)
# Name a logfile to capture results. 
$logfile = "VMReboot_" + $datestart + ".txt"
# Put the date in the logfile.
echo  "New Log ($datestart) - ($logfile)" >> $logfile

# Your vcenter server and credentials
$vcenter = "vcenter.yourdomain.com"
$username = ""
$password = ""

# Establish Connection
connect-viserver -server $vcenter -user $username -password $password

echo  "Connected - ($vcenter)" >> $logfile

# get list vm's to reboot.  Please CUSTOMIZE THIS before you run it.
$vmdesktops = Get-VM vm-*
# Add (+=) more vm's to reboot.
$vmdesktops += Get-VM vm7-*

# add desktop list to logfile
echo  "Desktops - ($vmdesktops)" >> $logfile

foreach ($vm in $vmdesktops)
{
    echo "Restart-VMGuest ($vm) at (get-date)" >> $logfile
    # Reboot VM using vmtools
    Restart-VMGuest $vm
    # space out the reboots by 6 minuites or 360 seconds.
	  ping -n 360 localhost
}
# COMPLETED 
