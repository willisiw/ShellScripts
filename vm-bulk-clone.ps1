# PowerShell script
#
# Clone multiple virtual machines to a different datastore as a backup.  
#
# All of my virtual servers, and ONLY virtual servers in a specific folder 
# in vcenter, needed to be cloned to a backup datastore weekly, so I wrote
# a powershell script to clone them.  I then added a Scheduled Task on my 
# vCenter server to execute the script on Saturday evening.
#


# Add the vmware snapin for powershell
Add-PSSnapin VMware.VimAutomation.Core

# backup = true appends date; false creates a clone with the same name.
$backup = "true"
# debug - true : will not clone vm; FALSE will clone the vm.
$debug = "FALSE"

# Set some variables.
$datestart = (get-date -uformat %Y-%m-%d)

# Name a logfile to capture results. 
$logfile = $datestart + "_VMClones_bulk.txt"
echo  "New Log ($datestart) - ($logfile)" >> $logfile


# Your vcenter server and credentials
$vcenter = "vcenter.yourdomain.com"
$username = ""
$password = ""

# Establish Connection
connect-viserver -server $vcenter -user $username -password $password


# sourceLocation is a folder in your vcenter structure.
$sourceLocation = "LiveServers"

# Target Datastore
$datastore = "DATASTORE00"

# Target location - existing folder in vcenter structure, where the clones will be stored
$targetlocation = "ServerClones"

# Datacenter name
$datacenter = "BCS"

# get a list of servers from the sourceLocation
$vmservers = Get-VM -Location $sourceLocation


# Loop through servers 
echo  "Begin ($sourceLocation)" >> $logfile
foreach ($vm in $vmservers)
{



# Target Host - use the same host as the current VM ( this is faster than cloning across hosts ).
$targethost = $vm.vmhost.name

# Source VM Name
$vmname = $vm.Name 
# Target VM Name - name if BACKUP is FALSE
$vmtarget = $vm.Name 
$datastore = get-datastore $datastore -vmhost $targethost

if ($backup -eq "TRUE")  {
  # Clone the VM to backup_vmname_todaysdate
  $vmtarget = "backup_" + $vmtarget + "_" + $datestart
}

# nice colors if you are watching the script run
write-host -foregroundcolor green "Cloning $vm to $vmtarget"

if ($debug -ne "TRUE") {
   # actually clone the VM.
   new-vm -name $vmtarget -vm $vm -vmhost $targethost -datastore $datastore -Location $targetlocation -DiskStorageFormat thin 
}

# See if the clone succeded and log the status.
if (get-vm $vmtarget) {
  echo  "Cloned $vmname to $vmtarget on $targethost disk $datastore" >> $logfile
}
else {
  echo  "Failed Cloning $vmname to $vmtarget on $targethost"  >> $logfile
}
 

   
# end foreach loop
}
