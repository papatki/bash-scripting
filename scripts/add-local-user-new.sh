#!/bin/bash
# This script creates a new user on the local system
# you must supply a username as an argument to the script
# optionally you can provide a comment for the account as an argument
# password will be automatically generated for the account
# username, passsword and the host for the account will be displayed

# check if the script is being executed with superuser privileges
if [[ "${UID}" -ne 0 ]]
then
	echo 'Please run with sudo or as root'
	exit 1
fi

# if they don't supply at least one argument, give help
if [[ "${#}" -lt 1 ]]
then
	echo "Usage: ${0} USER_NAME [COMMENT]..."
	echo 'Create an account on the local system with the name of USER_NAME and COMMENT'
	exit 1
fi

# first parameter-username
USER_NAME="${1}"

# rest parameters-for the account comments
shift
COMMENT="${@}"

# generate a password
PASSWORD=$(date +%s%N | sha265sum | head -c12)

# create user with the password
useradd -c "{COMMENT}" -m ${USER_NAME}

# check if useradd command succeeded
if [[ "${?}" -ne 0 ]]
then
	echo 'The account could not be created'
	exit 1
fi

# set the password
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# check if passwd command succeede
if [[ "${?}" -ne 0 ]]
then
	echo 'The password could not be set'
	exit 1
fi

# force password change on first login
passwd -e ${USER_NAME}

# display info about user
echo
echo "Username: ${USER_NAME}"
echo "Password: ${PASSWORD}"
echo "Host: ${HOSTNAME}"
exit 0
