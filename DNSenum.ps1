#Takes a list of DNS names and returns their IPs if they exist
#Expects hosts.txt with one hostname per line

$Output = @()

hosts = Get-Content("hosts.txt")

foreach ($host in $hosts){
    $hostinfo = Test-Connection -Computername $host -ErrorAction SilentlyContinue
    
    if($hostinfo){
        
        $Host_properties = @{
            Name = $hostinfo.Destination.ToString 
            IP = $details.IPV4Address.IPAddressToString
        }
        
        New-Object PsObject -Property $host_properties
        
        
        $Output+= [System.Net.Dns]::GetHostAddresses($host)
    }

     Else {    
        $Host_properties = @{
            Name = $hostinfo.Destination.ToString 
            IP = 'Unreachable'
        }

        New-Object PsObject -Property $props
    }

}|Sort ComputerName | Export-Csv .\DNS_enum_Report.csv -NoTypeInformation





