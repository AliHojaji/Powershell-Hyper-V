#--- Author : Ali Hojaji ---#

#--*--------------------------------*--#
#---> Configure Hyper-V Networking <---#
#--*--------------------------------*--#

#--> remote over to HV1-TEST
Enter-PSSession -ComputerName HV1-TEST

#--> create a switch
New-VMSwitch -SwitchName vInternal -SwitchType Internal

#--> configure switch IP (gateway)
New-NetIPAddress -IPAddress 10.10.0.1 -PrefixLength 24 -InterfaceAlias "vEthernet (vInternal)"

#--> configure network address translation
New-NetNAT -Name "vNAT" -InternalIPInterfaceAddressPrefix 10.10.0.0/24

#--> add a virtual NIC
Add-NetEventVmNetworkAdapter -VMName CORE-TEST -SwitchName vInternal

#--> exit remote session 
Exit-PSSession