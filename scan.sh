#!/bin/bash

# File: scan.sh
#
# Description: Scans a given host or range of hosts for open TCP ports
#
# Usage: 	scan.sh [host(s)] [port(s)]
#
# Valid host formats:
#		1. 1.1.1.1 - Single host
#		2. 1.1.1.1-1.1.255.254 - Host range
#		3. 1.1.1.1/21 - Entire subnet
#
# Valid port formats:
#		1. 443 - Single port
#		2. 10-100 - port range
#		3. 44,55,66 - Comma separated


#####################################
#	Usage Function
######
function usage {
	cat << EOF
Usage: 	scan.sh [host(s)] [port(s)]

Valid host formats:
		1. 1.1.1.1 - Single host
		2. 1.1.1.1-1.1.255.254 - Host range
		3. 1.1.1.1/21 - Entire subnet

Valid port formats:
		1. 443 - Single port
		2. 10-100 - port range
		3. 44,55,66 - Comma separated
EOF

	exit
}

#### check number of args ####
if (($# != 2)); then
	usage
fi


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


#### create list of port numbers ####
if [[ $2 =~ ^[0-9]+-[0-9]+$ ]]; then		# range of ports
	start=$(echo $2 | cut -d '-' -f 1)
	end=$(echo $2 | cut -d '-' -f 2)
	if (( $start < 1 || $start > 65535 )); then
		echo "$2 is an invalid port range"; echo
		usage
	fi
	if (( $end < 1 || $end > 65535 || $end < $start )); then
		echo "$2 is an invalid port range"; echo
		usage
	fi
	ports=$(seq $start $end)

elif [[ $2 =~ ^[0-9]+(,[0-9]+)+$ ]]; then	# comma separated
	ports=$(echo $2 | tr ',' ' ')
	for i in $ports; do
		if (( $i < 1 || $i > 65535 )); then
			echo "$i is an invalid port"; echo
			usage
		fi
	done

elif [[ $2 =~ ^[0-9]+$ ]]; then			# single host
	if (( $2 < 1 || $2 > 65535 )); then
		echo "$2 is an invalid port"; echo
		usage
	fi
	ports=$2

else						# error
	echo "$2 is an invalid port format"; echo
	usage
fi

# TODO: Make more efficient. currently takes 1 second per port
# 		multiple subprocesses that scan, cache results, organize output
#### scan hosts and ports ####
portsOpen=0
hostsScanned=0
echo "Scanning ports...."
while read -r host; do	# for each IP address
	echo $host
	for port in $ports; do # scan each port
		exec 2>/dev/null	# redirect stderr (refused connection)
		echo > /dev/tcp/$host/$port & 1>/dev/null
		pid=$!
		sleep 1
		kill $pid 1>/dev/null	# kill if still running
		wait $pid				# capture return value from echo or kill
		if (( "$?" != 0 )); then
			echo "    $port : CLOSED"
		else
			echo "    $port : OPEN"
			(( portsOpen++ ))
		fi
	done
	echo "--> $portsOpen port(s) open"
	echo
	portsOpen=0
	((hostsScanned++))
done < $IPfile

echo "Done: $hostsScanned host(s) scanned."


