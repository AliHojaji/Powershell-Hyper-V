#--- Author : Ali Hojaji ---#

#--*---------------------------*--#
#---> Manage Hyper-V Storages <---#
#--*---------------------------*--#

#---> remote over to HV1-TEST <---#

#--> install roles and features into a VHDX
Install-WindowsFeature -Name Web-Server -Vhd v:\VMs\CORE-TEST.vhdx

#--> compact a VHDX 
Optimize-VHD -Path V:\VMs\CORE-TEST_data1.vhdx

#--> resize a VHDX 
Resize-VHD -Path v:\VMs\CORE-TEST_data1.vhdx -SizeBytes 10GB

#--> modify a VHDX
Convert-VHD -Path v:\VMs\CORE-TEST_data1.vhdx -DistinationPath v:\VMs\CORE-TEST_data.vhdx -VHDType Fixed -DeleteSource

#--> merge diff disks
Merge-VHD -Path v:\VMs\CORE-TEST_diff2.vhdx -DistinationPath v:\VMs\CORE-TEST_diff1.vhdx


#--> checkpoints
Set-VM -Name CORE-TEST -CheckpointType Standard
Start-VM -VMName CORE-TEST

#--> create a base checkpoint
Checkpoint-VM -Name CORE-TEST -SnapshotName CORE-TEST_base

#--> install container feature and checkpoint
Invoke-Command -VMName CORE-TEST -ScriptBlock { Install-WindowsFeature FS-File-Server -Restart }
Checkpoint-VM -Name CORE-TEST -SnapshotName CORE-TEST_fileserver

#--> install data dedup and checkpoint 
Invoke-Command -VMName CORE-TEST -ScriptBlock { Install-WindowsFeature FS-Data-Deduplication }
Checkpoint-VM -Name CORE-TEST -SnapshotName CORE-TEST_dedup

#--> view checkpoints
Get-VMSnapshot -VMName CORE-TEST

#--> revert back to container checkpoint
Restore-VMSnapshot -VMName CORE-TEST -Name CORE-TEST_container

#--> revert back to base checkpoint
Restore-VMSnapshot -VMName CORE-TEST -Name CORE-TEST_base

#--> remove all checkpoints
Get-VMSnapshot -VMName CORE-TEST | Remove-VMSnapshot -VMName CORE-TEST