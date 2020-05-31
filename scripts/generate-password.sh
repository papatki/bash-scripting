#!/bin/bash

# The script generates random password for each user specified on the command line

# How many arguments are passed in
NUMBER_OF_PARAMETERS="${#}"
echo "You supplied ${NUMBER_OF_PARAMETERS} argument(s) on the command line."

# make sure that at least one arguments is supplied
if [[ "${NUMBER_OF_PARAMETERS}" -lt 1 ]]
then
	echo "Usage: ${0} USER_NAME [USER_NAME]..."
	exit 1
fi

# Generate and dispaly a password for each parameter
for USER_NAME in "${@}"
do
	PASSWORD=$(date +%s%N | sha256sum | head -c20)
	echo "${USER_NAME}: ${PASSWORD}"
done

