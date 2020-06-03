#!/bin/bash
# This script creates a new user on the local system
# enter the username, the person name and password
# the username, password, and the host for the account will be displayed

# check if the script is being executed with superuser privileges
if [[ "${UID}" -ne 0 ]]
then
	echo 'Please run with sudo or as root'
	exit 1
fi

# get the username
read -p 'Eneter the username to create: ' USER_NAME

# get the full name
read -p 'Eneter full name of the user: ' FULL_NAME

#get the password
read -p 'Enter the password to use for the account: ' PASSWORD

# create an account
useradd -c "${FULL_NAME}" -m ${USER_NAME}

# check if the useradd command succeeded
if [[ "{?}" -ne 0 ]]
then
	echo 'The account could not be created'
	exit 1
fi

# set the password
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

if [[ "${?}" -ne 0 ]]
then
	echo 'The password for the account could not be set'
	exit 1
fi

# force password to change on first login
passwd -e ${USER_NAME}

# display the username, password and the host where the user was created
echo 'Username: '
echo "${USER_NAME}"
echo 'PAssword: '
echo "${PASSWORD}"
echo 'Host:'
echo "${HOSTNAME}"
exit 0
