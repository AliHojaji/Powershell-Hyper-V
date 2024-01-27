#--- Author : Ali Hojaji ---#

#--*---------------------------*--#
#---> Manage Virtual Machines <---#
#--*---------------------------*--#

#--> start powershell session on HV1-TEST
Enter-PSSession HV1-TEST


#---> Hot/ Add/Remove Memory <---#

#--> add more memory to both machines
Get-VM | Set-VMMemory -StartupBytes 3072
Get-VM


#---> Enhanced Session Mode <---#

#--> enable enhanced session mode support on the host
Set-VMHost -EnableEnhancedSessionMode $true


#---> Secure Boot <---#

#--> enable secure boot
Get-VM | Set-VMFirmware -EnableSecureBoot On -SecureBootTemplate MicrosoftWindows # <- MicrosoftUEFICertificateAuthority (linux)
Get-VM | Set-VMFirmware


### Direct Device Assignment (DDA) ##

#--> DDA cmdlets
Get-Command *device* -Module Hyper-V


#---> Integration Services <---#

#--> view integration services
Get-VMIntegrationService -VMName GUI-TEST 

#--> enable guest services
Enable-VMIntegrationService -VMName GUI-TEST -Name "Guest Service Interface"


#---> Import & Export VMs <---#

#--> export a vm
Export-VM -Name GUI-TEST -Path \\hv1-test\v$\vms\exports

#--> import a vm
Invoke-Command -computerName HV2-TEST -ScriptBlock { Import-VM -Path v:\vms\exports\GUI-TEST }


#---> Convert VMs from Previous Versions <---#

#--> upgrade vm version to server 2016 hyper-v (8.0)
Get-VM | Update-VMVersion

#--> exit powershell session on HV1-TEST
Exit-PSSession HV1-TEST