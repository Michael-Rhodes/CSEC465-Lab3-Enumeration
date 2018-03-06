#!/usr/bin/env python3

# File: fingerprintOS.py
#
# Description: Attempts to fingerpint the OS of a hsot using TTL values in the
#              IP header. This script differentiates between Windows, Linux, 
#              and freeBSD.
#
# Limitations: This script ONLY looks at the TTL values. To make a more 
#              accurate attempt to fingerprint the OS, other factors should
#              be considered (e.g. TCP Window Size, TCP ISN, Service banners,
#              etc.)
# Usage:       fingerprintOS.py [file of hosts]


import logging
logging.getLogger("scapy.runtime").setLevel(logging.ERROR)  # supress IPv6 error
import sys
import os
try:
  from scapy.all import *
except Exception as e:
  print("scapy is required for this script to work")
  print("Install:\n\tapt install python3-pip\n\tpip3 install scapy-python3")
  sys.exit(1)

# check if file exists
if (len(sys.argv) != 2):
  sys.exit("Usage:	fingerprintOS.py [filename]")
if (not os.path.isfile(sys.argv[1])):
  sys.exit("Usage:	fingerprintOS.py [filename]")

# check TTL of each ip address
with open(sys.argv[1],'r') as addrs:
  for ip in addrs:
    ip = ip.strip('\n')	#remove newline if it exists
    try:
      ans = sr1(IP(dst=ip)/ICMP(),timeout=2,verbose=0) #send ping
    except Exception as e:
      if ('not permitted' in str(e)):
        sys.exit(e)
      continue
    if not (ans is None):
       if (ans.ttl <= 64):
         print(ip+": most likely Linux, possibly a newer version of freeBSD")
       elif (ans.ttl <= 128):
         print(ip+": most likely Windows")
       else:	# ttl <=255
         print(ip+": most likely freeBSD") 


