#Connect to vCenter Server
﻿Get-Module -ListAvailable VMware.* | Import-Module
Connect-VIServer -Server 'IP_ADDRESS' -User 'username' -Password 'password'

$authMgr = Get-View (Get-View ServiceInstance).Content.authorizationManager

###MODIFY the following variables

$cluster_name='Cluster_Name'
$role = "Role_Name"
$user_or_group = "username"
$vm_folder = 'Folder_Name'
#Change this variable.If the permisions will be set up for a user then the value is false, if not, the value is true
$its_group = $false
#Change this variable depending on if you will add a permision (true) or remove it (false)
$add_permision = $true

###END

#Permission Object
$perm = New-Object VMware.Vim.Permission
$perm.Principal = $user_or_group
$perm.roleId = ($authMgr.RoleList | where{$_.Name -eq $role}).RoleId
$perm.propagate = $true
$perm.group = $its_group


#Get the Cluster
$cluster = Get-View -ViewType ComputeResource -Filter @{name=$cluster_name}

#Permisions for the CLUSTERS
if($add_permision -eq $true){
    #GIVE Permission
    $authMgr.SetEntityPermissions($cluster.MoRef, $perm)
}else{
    #REMOVE Permission
    $authMgr.RemoveEntityPermission($cluster.MoRef, $user_or_group, $perm.group)
}


#Permissions for DATASTORES
foreach($datastore in $cluster.Datastore){ 
    $id = "$datastore"
    $datastore_object = Get-View $id
    
    if($add_permision -eq $true){
    #GIVE Permission
        $authMgr.SetEntityPermissions($datastore_object.MoRef, $perm)
    }else{
        #REMOVE Permission
        $authMgr.RemoveEntityPermission($datastore_object.MoRef, $user_or_group, $perm.group)
    }

}

#Permissions for the PORT_GROUPS
foreach($port_group in $cluster.network){  
    $id = "$port_group" 
    $pg_object = Get-View $id
    
    if($add_permision -eq $true){
    #GIVE Permission
        $authMgr.SetEntityPermissions($pg_object.MoRef, $perm)
    }else{
        #REMOVE Permission
        $authMgr.RemoveEntityPermission($pg_object.MoRef, $user_or_group, $perm.group)
    }
}


#Permissions for VMS & Templates FOLDER
$folder_object = get-view -ViewType folder -filter @{name=$vm_folder}

if($add_permision -eq $true){
    #GIVE Permission
        $authMgr.SetEntityPermissions($folder_object.MoRef, $perm)
    }else{
        #REMOVE Permission
        $authMgr.RemoveEntityPermission($folder_object.MoRef, $user, $perm.group)
    }
