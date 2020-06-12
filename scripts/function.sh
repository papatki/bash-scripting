#!/bin/bash

#This function sends a message to syslog and to STDOUT if VERBOSE is true
#define function log
#function log { .... } also works
log() {
	local MESSAGE="${@}" #local makes variable local --> accessible only in this function
	if [[ "${VERBOSE}" = 'true' ]]
	then
		echo "${MESSAGE}"
	fi
	logger -t function.sh "${MESSAGE}" 
}

backup_file() {
	#This function creates a backup of a file, returns non-zero status on error
	local FILE="${1}"
	#check if file exists
	if [[ -f "${FILE}" ]]
	then
		local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
		log "Backing up ${FILE} to ${BACKUP_FILE}."
		cp -p ${FILE} ${BACKUP_FILE}
	else
		#file does not exist, return non-zero exit status
		return 1
	fi
}

#execute function
readonly VERBOSE='true' #readonly -> immutable variable
backup_file '/etc/passwd'
