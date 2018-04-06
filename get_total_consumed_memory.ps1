#This script calculates the total consumed memory of all the VMs inside a specific folder

Get-Module -ListAvailable VMware.* | Import-Module
Connect-VIServer -Server 'vCenter_IP_address' -User administrator@vsphere.local -Password 'password'

#Specify the folder
$folder_name = "Folder-Name"

$metric_name = "mem.consumed.average"
$vms = Get-VM -Location $folder_name 

$total_metric = 0

foreach($vm in $vms) {
    $metric = Get-VM -Name $vm | Get-Stat -Stat $metric_name
    $total_metric = $total_metric + $metric[0].Value
}

Write-Output $total_metric
