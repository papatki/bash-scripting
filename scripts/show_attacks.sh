#!/bin/bash

#Count the nnum of failed logins by IP address
#If there are any IPs with over LIMIT failures, displays the vounts, IP and location
LIMIT='10'
FILE="${1}"

#Check if FILE was supplied as an argument

if [[ ! -e "${FILE}" ]]
then
	echo "Cannot open log file: ${FILE}" >&2
	exit 1
fi

#Display the CSV header
echo 'Count,IP,Location'
#Loop through the list of failed attempts and corresponding IP addresses
grep Failed syslog | awk '{print $(NF -3)' | sort | uniq -c | sort -nr | while read COUNT IP

do
	#if the num of failed attempts is greater than the limit, display count, IP and location
	if [[ "${COUNT}" -gt "${LIMIT}" ]]
	then
		LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
		echo "${COUNT},${IP},${LOCATION}"
	fi
done
exit 0
