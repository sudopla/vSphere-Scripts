#This script finds all the VMs that are running old virtual hardware

Get-Module -ListAvailable VMware.* | Import-Module
Connect-VIServer -Server 'vCenter_IP_address' -User administrator@vsphere.local -Password 'password'

$vms =  Get-View –viewtype VirtualMachine | Select Name, config, Guest

$list_vm_version = @()

foreach ($vm in $vms) {
    if ($vm.config.version -ne 'vmx-11') {        
        $object = New-Object System.Object
        $object | Add-Member -type NoteProperty -name Name -value $vm.Name
        $object | Add-Member -type NoteProperty -name VM_Version -value $vm.config.Version

        $list_vm_version += $object
    }
}

$list_vm_version | Export-Csv -NoTypeInformatio "C:\Users\user\Documents\VMs_Version.csv"
