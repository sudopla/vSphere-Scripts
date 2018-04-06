#This scipts add the specified email address to all the defined alarms in vCenter

Get-Module -ListAvailable VMware.* | Import-Module
Connect-VIServer -Server 'vCenter_IP_address' -User administrator@vsphere.local -Password 'password'

Get-AlarmDefinition | Get-AlarmAction -ActionType SendEmail | Remove-AlarmAction -Confirm:$false

Get-AlarmDefinition | Set-AlarmDefinition -ActionRepeatMinutes 30

Get-AlarmDefinition | New-AlarmAction -Email -To @('user@domain.com') | New-AlarmActionTrigger -StartStatus "Green" -EndStatus "Yellow"

#The 'Yellow' -> 'Red' trigger is created by default but with the option 'Once'. I will remove it and create it again with the repeat option
Get-AlarmDefinition | Get-AlarmAction -ActionType SendEmail | Get-AlarmActionTrigger | where {$_.StartStatus -eq 'Yellow'} | Remove-AlarmActionTrigger -Confirm:$false
Get-AlarmDefinition | Get-AlarmAction -ActionType SendEmail | New-AlarmActionTrigger -StartStatus "Yellow" -EndStatus "Red" -Repeat


