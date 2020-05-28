#!/bin/bash
#This script will creates an account on the local system.
#You will be prompted for account name and password

#ask for the user name
read -p 'Enter the username to create: ' USER_NAME

#ask for the real name
read -p 'Enter your full name: ' COMMENT

#ask for the password
read -p 'Enter the password to use for the account: ' PASSWORD

#create user
iseradd -c "${COMMENT}" -m ${USER_NAME}

#set the password for the user
echo ${PASSWORD} | passwd --stdin ${USER_NAME}

#force fassword change on forst login
passwd -e ${USER_NAME}
