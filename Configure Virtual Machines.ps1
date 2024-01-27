#--- Author : Ali Hojaji ---#

#--*------------------------------*--#
#---> Configura Virtual Machines <---#
#--*------------------------------*--#

#--> start powershell session on HV1-TEST
Enter-PSSession HV1-TEST


#---> Dynamic Memory <---#

#--> configure dynamic memory
Get-VM | Set-VM -MemoryStartupBytes 2GB -DynamicMemory

#--> configure buffer and weight
Set-VMMemory -VMName CORE-TEST -Buffer 10 -Priority 100


#--->  NUMA <---#

#--> view hosts NUMA topology
Get-VMHostNumaNode

#--> disable NUMA spanning
Set-VMHost -NumaSpanningEnabled $false


#---> Smart Paging <---#

Get-VM | Set-VM -SmartPagingFilePath V:\Paging


#---> Resource Metering <---#

#--> enable resource metering
Get-VM | Enable-VMResourceMetering

#--> view usage stats
Get-VM | Measure-VM

#--> configure Collection interval
Set-VMHost -ResourceMeteringSaveInterval 00:01:00

#--> create a resource pool to measure memory
New-VMResourcePool -Name HV1RP -ResourcePoolType Memory

#--> add VMs memory to pool
Set-VMMemory -ResourcePoolName HV1RP -VMName CORE-TEST,GUI-TEST

#--> view pool usage stats
Measure-VMResourcePool -Name HV1RP | ft *mem*

#--> disable resource metering 
Get-VM | Disable-VMResourceMetering

#--> exit powershell session
Exit-PSSession