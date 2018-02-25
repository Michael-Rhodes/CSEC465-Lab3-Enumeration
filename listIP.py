#!/usr/bin/env python3
#
# File:		listIP.py
#
# Description:	Produces a file that lists all IP addresses in a given network.
#		Returns with an error if the ip address is invalid.
#
# Usage:	listIP.py [ip address or range] [outfile]
#
# Valid ip formats: 
#		a. Range:	1.1.1.1-1.1.1.233
#		b. Subnet:	1.1.1.0/24
#		c. Single host:	1.1.1.1

import ipaddress	# parses IP addresses
import sys		# parses command line args, returns error

# check number of args
if (len(sys.argv) != 3):
  sys.exit("Invalid number of arguments")

ip = sys.argv[1]
outfile = sys.argv[2]
listIP = []

### parse ip
if ('-' in ip):	# format a - range
  try: 
    start = ipaddress.IPv4Address(ip.split('-',1)[0])
    end = ipaddress.IPv4Address(ip.split('-',1)[1])
    listIP.append(str(start))
    i = 0
    if (start > end): # invalid range
      sys.exit("Invalid IP range")
    while (start+i < end):
      listIP.append(str(start+i))
      i = i + 1
    listIP.append(str(end))
  except Exception as e:
    sys.exit(e)

elif ('/' in ip):  # format b - subnet
  try:
    ntwk = ipaddress.IPv4Network(ip)
  except Exception as e:
    print(e)
    sys.exit("The network address of the subnet should be used")
  for addr in ntwk.hosts():
    listIP.append(str(addr))

else:  # format c - single host
  try:
    listIP.append(str(ipaddress.IPv4Address(ip)))
  except Exception as e:
    sys.exit(e)

# write to file  
with open(outfile,'w') as f:
  for ip in listIP:
    f.write(ip+'\n')


