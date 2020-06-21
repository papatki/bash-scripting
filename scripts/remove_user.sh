#!/bin/bash

#This script deletes a user

#run as root
if [[ "${UID}" -ne 0 ]]
then
	echo 'Please run with sudo or as root.' >&2
	exit 1
fi

#assume the first argument is the user to delete
USER="${1}"

#delete the user
userdel ${USER}

#make sure the user got deleted
if [[ "${?}" -ne 0 ]]
then
	echo "The account ${USER} was not deleted." >&2
	exit 1
fi

#tell the account was deleted
echo "The account ${USER} was deleted."

exit 0
