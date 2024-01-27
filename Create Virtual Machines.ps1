#--- Author : Ali Hojaji ---#

#--*--------------------------*--#
#---> Create Virtual Machine <---#
#--*--------------------------*--#

#--> start powershell session on HV1-TEST
Enter-PSSession HV1-TEST

#--> create generation 2 VM
New-VM -Name GUI-TEST -MemoryStartupBytes 2GB -NewVHDP v:\VMs\GUI-TEST.vhdx -NewVHDSizeBytes 40GB -Generation 2

#--> add SCSI controller for DVD drive 
Add-VMScsiController -VMName GUI-TEST

#--> add DVD drive to SCSI controller with Server 2016 installation media mounted
Add-VMDvdDrive -VMName GUI-TEST -ControllerNumber 1 -ControllerLocation 0 -Path V:\ISOs\WindowsServer2016.ISO

#--> create another virtual hard disk for data drive
New-VHD -Path V:\VMs\GUI-TEST_data1.vhdx -SizeBytes 100GB -Dynamic

#--> attach data disk
Add-VMHardDiskDriver -VMName GUI-TEST -Path V:\VMs\GUI-TEST_data1.vhdx

#--> start the VM
Start-VM -Name GUI-TEST

#--> exit powershell session
Exit-PSSession