#This script will find all the virtual machines that need to update VMware tools.

Get-Module -ListAvailable VMware.* | Import-Module
Connect-VIServer -Server 'vCenter_IP_address' -User administrator@vsphere.local -Password ''

#Export to CVS
$tools = @()

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

$tools | select Name, ToolsStatus, ToolsVersion | Export-Csv -NoTypeInformatio "C:\Users\user\Documents\VMware_tools.csv"
