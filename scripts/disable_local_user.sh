#!/bin/bash
#This script disables, deletes and/or archives users on the local system

ARCHIVE_DIR='/archive'

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
#loop through all the username supplied as argument
for USERNAME in "${@}"
do
	echo "Processing user: ${USERNAME}"
	#make sure the UID of the account is at least 1000
	USERID=$(id -u ${USERNAME})
	if [[ "${USERID}" -lt 1000 ]]
	then
		echo "Refusing to remove the ${USERNAME} account with UID ${USERID}" >&2
		exit 1
	fi

	#create an archive if requested to do so
	if [[ "${ARCHIVE}" = 'true' ]]
	then
		#make sure the ARCHIVE_DIR directory exists
		if [[ ! -d "${ARCHIVE_DIR}" ]]
		then
			echo "Creating ${ARCHIVE_DIR} directory"
			mkdir -p ${ARCHIVE_DIR}
			if [[ "${?}" -ne 0 ]]
			then
				echo "The archive direcory ${ARCHIVE_DIR} could not be created." >&2
				exit 1
			fi
		fi
		#archive the user's home directory and move it into the ARCHIVE_DIR
		HOME_DIR="/home/${USERNAME}"
		ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
		if [[ -d "${HOME_DIR}" ]]
		then
			echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
			tar -zcf ${ARCHIVE_FILE} ${HOME_DIR} &> /dev/null
			if [[ "${?}" -ne 0 ]]
			then 
				echo "Could not create ${ARCHIVE_FILE}" >&2
				exit 1
			fi
		else
			echo "${HOME_DIR} does not exist or is not a directory" >&2
			exit 1
		fi
	fi


	if [[ "${DELETE_USER}" = 'true' ]]
	then
		#delete the user
		userdel ${REMOVE_OPTION} ${USERNAME}

		#check is userdel command succeeded
		if [[ "${?}" -ne 0 ]]
		then
			echo "The account ${USERNAME} was not deleted" >&2
			exit 1
		fi
		echo "The account ${USERNAME} was deleted"
	else
		chage -E 0 {USERNAME}

		#check if chage command succeeded
		if [[ "${?}" -ne 0 ]]
		then
			echo "The account ${USERNAME} was not disabled" >&2
			exit 1
		fi
		echo "The account ${USERNAME} was disabled" >&2
	fi
done

exit 0

