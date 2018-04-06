#This script export a list of all the virtual machines' disks and along with their capacity and usage.

Get-Module -ListAvailable VMware.* | Import-Module
Connect-VIServer -Server 'vCenter_IP_address' -User administrator@vsphere.local -Password 'password'

$vms =  Get-View –viewtype VirtualMachine | Select Name, config, Guest
$vm_list =@()

foreach ($vm in $vms) {
    if($vm.Guest.ToolsVersionStatus -ne 'guestToolsNotInstalled') {      
        $disks = $vm.Guest.Disk
        foreach ($disk in $disks) {  
            $capacity = $disk.Capacity
            $free_space = $disk.FreeSpace
            $used_space = $capacity - $free_space

            $capacity_GB = [math]::Round($capacity / 1024 / 1024 / 1024)
            $free_space_GB = [math]::Round($free_space / 1024 / 1024 / 1024  ,2)
            $used_space_GB = [math]::Round(($used_space / 1024 / 1024 / 1024), 2)

            #$print = $vm.Name + ' - Disk Capacity: ' + $capacity_GB + ' Space Used: ' + $used_space_GB
            #Write-Output $print

            $list = New-Object System.Object
            $list | Add-Member -type NoteProperty -name Name -value $vm.Name
            $list | Add-Member -type NoteProperty -name Disk_Path -value $disk.DiskPath
            $list | Add-Member -type NoteProperty -name Disk_Capacity_[GB] -value $capacity_GB
            $list | Add-Member -type NoteProperty -name Used_Space_[GB] -value $used_space_GB
            $list | Add-Member -type NoteProperty -name Free_Space_[GB] -value $free_space_GB

            $vm_list += $list
        }
    }
}

$vm_list | Export-Csv -NoTypeInformatio "C:\Users\user\Documents\List_VM_Disks.csv"
