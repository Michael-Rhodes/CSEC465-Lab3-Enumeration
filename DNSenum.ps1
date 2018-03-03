<#
DNSenum.ps1  3/3/18
Author = Mark White
Purpose: Takes a list of DNS names and returns their IPs if they exist

Expects: file names hosts.txt in the same directory as this script with one hostname perline.  Hosts specified must be network reachable.

Gives: file names host_IPs.txt in the same directory as this script. 
    host_IPS.txt with have the following format for each line.  HOSTNAME: 192.168.1.1 OR HOSTNAME: UNREACHABLE
#>


$Output = @()


$hosts = Get-Content $PSScriptRoot\hosts.txt

foreach ($target in $hosts){
    $hostinfo = Test-Connection -Computername $target -Count 1 -ErrorAction SilentlyContinue   #attempt to ping $target to get IP
    
    if($hostinfo){                                          #If output of Test-Connection is NOT NULL...
        
        
           
            $IP = $hostinfo.IPV4Address.IPAddressToString   #grab IPv4 address from Test-Connection output object
        
            $Output += $target + ": " + $IP + "`r`n"        #append results to output string/array
    }

     Else {                                                 #If output of Test-Connection IS NULL...
        
            $IP = 'UNREACHABLE'
            
            $Output += $target + ": " + $IP + "`r`n"        #append results to output string/array
            
        
    }
}

Write-Host $Output                                          

Write-Host "Output saved in host_IPs.txt"

Out-File -FilePath $PSScriptRoot\host_IPs.txt -InputObject $Output   


