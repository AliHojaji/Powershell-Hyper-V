#--- Author : Ali Hojaji ---#

#--*------------------------------*--#
#---> Configure & Manage Hyper-V <---#
#--*------------------------------*--#

#--> hyper-v cmdlets
Get-Command -Module Hyper-V

#--*----------------------------------*--#
#---> Remote Hyper-V Host Management <---#
#--*----------------------------------*--#

#--> single-use remote session 
Invoke-Command -ComputerName HV1-TEST,HV2-TEST -ScriptBlock { Get-VMHost }
Invoke-Command -ComputerName HV1-TEST,HV2-TEST -ScriptBlock { Set-VMHost -VirtualHardDiskPath V:\VMs -VirtualMachinePath V:\VMs }

#--> interactive remote session
Enter-PSSession -ComputerName HV1-TEST
Get-VM
Start-VM -Name GUI-TEST
Exit-PSSession

#--> persistent remote session
$hv2 = New-PSSession -ComputerName HV2-TEST
Enter-PSSession -Session $hv2
Get-VM
Start-VM -Name CORE-TEST
Exit-PSSession

#--*------------------------------------------------*--#
#---> PowerShell Direct Virtual Machine Management <---#
#--*------------------------------------------------*--#

#--> single-use powershell direct session
Invoke-Command -VMName CORE-TEST -Credential (Get-Credential) -ScriptBlock { Get-ComputerInfo }

#--> interactive powershell direct session
Enter-PSSession -VMName CORE-TEST -Credential (Get-Credential)
Get-WindowsFeature
Exit-PSSession

#--> persistent powershell direct session 
$core = New-PSSession -VMName CORE-TEST -Credential (Get-Credential)
Enter-PSSession -Session $core
"this file was created on core-TEST" > c:\core-TEST.txt
Exit-PSSession

#--> copy files to/from VM
"this file was created on hv2-TEST" > c:\hv2-TEST.txt
Copy-Item -Path c:\hv2-test.txt -Destination C:\ -ToSession $core
Copy-Item -Path c:\core-test.txt -Destination C:\ -FromSession $core

#--> clean up sessions
Exit-PSSession
Remove-PSSession $core
Exit-PSSession
Remove-PSSession $hv2

#--*----------------------------------*--#
#---> Nested Virtualization <---#
#--*----------------------------------*--#

#--> interactive session on HV1-TEST
Enter-PSSession -ComputerName HV1-TEST

#--> attempt to install Hyper-V role on GUI-TEST (fail...)
Invoke-Command -VMName GUI-TEST -ScriptBlock { Install-WindowsFeature Hyper-V -IncludeManagementTools }

#--> stop the vm
Stop-VM GUI-TEST

#--> enable nested virt on HV1-TEST for GUI-TEST VM
Set-VMProcessor -VMName GUI-TEST -ExposeVirtualizationExtensions $true

#--> start the vm
Start-VM GUI-TEST

#--> interactive session on HV1-TEST
Enter-PSSession -ComputerName HV1-TEST

#--> attempt to install Hyper-V role on VM (success!)
Invoke-Command -VMName GUI-TEST -ScriptBlock { Install-WindowsFeature Hyper-V -IncludeManagementTools }