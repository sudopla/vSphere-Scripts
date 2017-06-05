#Connect to vCenter Server
﻿Get-Module -ListAvailable VMware.* | Import-Module
Connect-VIServer -Server 'IP_ADDRESS' -User 'username' -Password 'password'

#Export to CVS
$vm_tools = @()

$vms = Get-VM | where {$_.PowerState -eq "PoweredOn"} | Get-View | Select Name, config, Guest

foreach ($vm in $vms) {

    if($vm.Guest.ToolsVersionStatus -ne "guestToolsCurrent"){

        $tool = New-Object System.Object
        $tool | Add-Member -type NoteProperty -name Name   -value $vm.Name
        $tool | Add-Member -type NoteProperty -name ToolsVersion   -value $vm.config.tools.toolsVersion
        $tool | Add-Member -type NoteProperty -name ToolsStatus   -value $vm.Guest.ToolsVersionStatus

        $tools += $tool

    }
}

$vm_tools | select Name, ToolsStatus, ToolsVersion | Export-Csv -NoTypeInformatio "C:\Users\ng68d63\Documents\VMware_tools.csv"
