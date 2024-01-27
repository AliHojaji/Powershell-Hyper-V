#--- Author : Ali Hojaji ---#

#--*--------------------------------------*--#
#---> Create & Configure Hyper-V Storage <---#
#--*--------------------------------------*--#

#--> remote over to HV1-TEST
Enter-PSSession -ComputerName HV1-TEST


#--> create a VHDX
New-VHD -Path v:\VMs\CORE-TEST_data2.vhdx -SizeBytes 100GB -Dynamic
Add-VMHardDiskDrive -VMName CORE-TEST -Path v:\VMs\CORE-TEST_data2.vhdx -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 2

#--> configure storage Qos
Set-VMHardDiskDrive -VMName CORE-TEST -ControllerLocation 0 -ControllerNumber 2 -MinimumIOPS 0 -MaximumIOPS 100

#--> create a pass-through disk
Add-VMScsiController -VMName CORE-TEST
Add-VMHardDiskDrive -VMName CORE-TEST -DiskNumber 2 -ControllerType SCSI -ControllerNumber 1 -ControllerLocation 0

#--> create a vhd set
New-VHD -Path v:\shated.vhds -SizeBytes 100GB -Dynamic

#--> create a diff disk
New-VHD -Path v:\VMs\GUI-TEST_data1-diff2.vhdx -ParentPath v:\VMs\GUI-TEST_data1-diff1.vhdx -Differencing 

#--> exit remote session
Exit-PSSession