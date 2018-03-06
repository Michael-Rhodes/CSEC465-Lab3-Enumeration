#!/bin/bash
# File: ping.sh
#
# Description: takes an IP address range as input and returns
#              the hosts in IP range that are up
#
# Usage:	ping.sh [IP address(es)]
# Valid ip formats: 
#		a. Range:	1.1.1.1-1.1.1.233
#		b. Subnet:	1.1.1.0/24
#		c. Single host:	1.1.1.1

function usage {
	cat << EOF
Usage: 	 ping.sh [host(s)]

Valid host formats:
		1. 1.1.1.1 - Single host
		2. 1.1.1.1-1.1.255.254 - Host range
		3. 1.1.1.1/21 - Entire subnet
EOF
	exit
}

##### get ip address(es) ####
IPfile="/tmp/ipList"
if [ -e listIP.py ]; then
	python3 listIP.py $1 $IPfile
	if [[ "$?" -ne "0" ]]; then
		echo
		usage
	fi
else
	echo "Cannot find helper script listIP.py."
	echo "Ensure listIP.py is in the same directory as scan.py."
fi

# ping addresses
while read -r host; do	# for each IP address
	ping -q -c 1 -W 2 $host >/dev/null 2>&1 
	if [ "$?" -eq "0" ]; then # if ping returned successfully
		echo $host is up. 
	fi
done < $IPfile
