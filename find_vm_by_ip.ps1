 Get-VM -Location NAR-CLUSTER | Where {$_.guest.IPAddress[0] -eq '10.0.0.20'} | Select Name
