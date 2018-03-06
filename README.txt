# CSEC465-Lab3-Enumeration
A Collection of enumeration scripts for CSEC 465


1. DNS enumeration script using PowerShell
Script:	DNSenum.ps1
Usage:	DNSenum.ps1
Expects: file named "hosts.txt" in the same directory as the 
         script with one hostname per line	


2. Ping sweep script using Bash
Script:	ping.sh
Description: takes an IP address range as input and returns
             the hosts in IP range that are up
Usage:	ping.sh [IP address(es)]
Valid ip formats: 
		a. Range:	1.1.1.1-1.1.1.233
		b. Subnet:	1.1.1.0/24
		c. Single host:	1.1.1.1


3. OS fingerprinting script using Python
  Script: fingerprintOS.py
  Description: Attempts to fingerpint the OS of a hsot using TTL values in the
               IP header. This script differentiates between Windows, Linux, 
               and freeBSD. 
  Usage: fingerprintOS.py [filename]
  Expects: the file with filename to contain a list of IP addresses
         with one address per line


4. Port Scanning script using Bash
  Script: scan.sh
  Description: Scans a given host or range of hosts for open TCP ports
  Usage: 	scan.sh [host(s)] [port(s)]
  Valid host formats:
		1. 1.1.1.1 - Single host
		2. 1.1.1.1-1.1.255.254 - Host range
		3. 1.1.1.1/21 - Entire subnet
  Valid port formats:
		1. 443 - Single port
		2. 10-100 - port range
		3. 44,55,66 - Comma separated


5. OTHER: TCP SYN tracker using Python
  Script: trackSYN.py
  Description:  Listens on a given interface for incoming TCP segments with
                the SYN flag set. Ignores segments with both SYN and ACK flags
                set.
  Usage: trackSYN.py


Helper scripts and other files:
  Script: listIP.py
    Description:  Produces a file that lists all IP addresses in a given
                  network. Returns with an error if the ip address is invalid.
    Usage: listIP.py [ip address or range] [outfile]
    Valid ip formats: 
		a. Range:	1.1.1.1-1.1.1.233
		b. Subnet:	1.1.1.0/24
		c. Single host:	1.1.1.1
  
  File: hosts.txt
    Description: sample input file of hostnames for DNSenum.ps1

  File: ipOS.txt
    Description: sample input file of IP addresses for fingerprintOS.py

