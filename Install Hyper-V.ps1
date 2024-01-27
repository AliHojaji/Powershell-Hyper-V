#--- Author : Ali Hojaji ---#

#--*----------------------*--#
#---> HV1-Test (Desktop) <---#
#--*----------------------*--#

#--> install Hyper-V remotely
Install-WindowsFeature -ComputerName HV1-TEST -Name Hyper-V IncludeManagementTools -Restart


#--*-------------------*--#
#---> HV2-TEST (Nano) <---#
#--*-------------------*--#

#--> enter remote session
Enter-PSSession -ComputerName HV2-TEST

#--> import provider, view installed and available packages
Import-PackageProvider -Name NanoServerPackage
Get-Package -ProviderName NanoServerPackage
Find-Package -ProviderName NanoServerPackage

#--> install the hyper-v role
Install-NanoServerPackage -Name Microsoft-NanoServer-Compute-Package

#reboot
Restart-Computer


#--> ADMIN-TEST (Local) <--#

#--> install GUIm cndk
Get-WindowsOptionalFeature -Online -FeatureName *Hyper-V*
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Tools-All