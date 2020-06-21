#!/bin/bash
#This script disables, deletes and/or archives users on the local system

usage() {
	#display the usage and exit
	echo "USAGE: ${0} [-dra] USER [USERN]..." >&2
	echo 'Disable a local Linux account.' >&2
	echo ' -d Deletes accounts instead of disabling them.' >&2
	echo ' -r Removes the home directory associated with the account(s).' >&2
	echo ' -a Creates an archive of the home directory associated with the account(s).' >&2
	exit 1
}

#Run with superuser previlidges
if [[ "${UID}" -ne 0 ]]
then
	echo 'Please run with sudo or as root.' >&2
	exit 1
fi

#Parse the options
while getopts dra OPTION
do
	case ${OPTION} in
		d) DELETE_USER='true' ;;
		r) REMOVE_OPTION='-r' ;;
		a) ARCHIVE='true' ;;
		?) usage ;;
	esac
done

#Remove the options while leaving the remainnig arguments
shift "$(( OPTIND - 1 ))"

#If the user doesn't supply at least one argument. give help
if [[ "${#}" -lt 1 ]]
then
	usage
fi

