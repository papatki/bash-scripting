#!/bin/bash
#This script generates a random password
#user cat set the password length woth -l and add a special character with -s
#verbose mode can be enabled with -v

usage() {
	echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
	echo 'Generate a random password'
	echo ' -l LENGTH Specify the password length'
	echo ' -s        Append a special character to the password'
	echo ' -v        Increase verbosity'
	exit 1
}


log() {
	local MESSAGE="${@}"
	if [[ "${VERBOSE}" = 'true' ]]
	then
		echo "${MESSAGE}"
	fi
}

#set a default password length
LENGTH=48

while getopts vl:s OPTION
do
	case ${OPTION} in
		v)
			VERBOSE='true'
			echo 'Verbose mode on.'
			;;
		l)
			LENGTH="${OPTARG}"
			;;
		s)
			USE_SPECIAL_CHAR='true'
			;;
		?)
			
			;;
	esac
done

log 'Generating a password'

PASSWORD=$(date +%s%N{RSNDOM} | sha256sum | head -c${LENGTH})

#append special char if requested to do so
if [[ "${USE_SPECIAL_CHAR}" = 'true' ]]
then
	log 'Selecting a random special character.'
	SPECIAL_CHAR=$(echo '!@#$%^&*()' | fold -w1 |shuf | head -c1)
	PASSWORD="${PASSWORD}${SPECIAL_CHAR}"
fi

log 'Done'
log 'Your password is:'

#display the password
echo "${PASSWORD}"

exit 0
