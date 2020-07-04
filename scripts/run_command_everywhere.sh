#!/bin/bash
#A list of servers
SERVER_LIST='/vagrant/server'

#Options for ssh command
SSH_OPTIONS='-o ConnectSTimeout=2'

usage() {
  #Display usage and exit
  echo "Usage: ${0} [-nsv] [-f FILE] COMMAND" >&2
  echo "Executes COMMAND as a single command on every server." >&2
  echo " -f FILE Use FILE for the list of servers. Default ${SERVER_LIST}." >&2
  echo ' -n      Dry run mode. Display the COMMAND that would have been executed and exit' >&2
  echo ' -s      Execute the COMMAND using sudo on the remote server' >&2
  echo ' -v      Verbose mode. Display the server name before executing COMMAND' >&2
  exit 1
}


#Make sure the script is not begin execuded with sudo
if [[ "${UID}" -eq 0 ]]
then
  echo 'Do not execute this script as root. Use the -s option instead.' >&2
  usage
fi

#Parse the Options
while getopts f:nsv OPTION
do
  case ${OPTION} in
    f) SERVER_LIST="${OPTARG}" ;;
    n) DRY_RUN='true' ;;
    s) SUDO='sudo' ;;
    v) VERBOSE='true' ;;
    ?) usage ;;
  esac
done

#Remove the options while leaving the remaining arguments
shift "$(( OPTIND - 1 ))"

#If the user does not supply at least one argument, give help
if [[ "${#}" -lt 1 ]]
then
  usage
fi

#Amything that remains on the command line is treated as a single COMMAND
COMMAND="${@}"

#Check if SERVER_LIST exists
if [[ ! -e "${SERVER_LIST}" ]]
then
  echo "Cannot open server list file ${SERVER_LIST}" >&2
  exit 1
fi

EXIT_STATUS='0'

#Loop through the SERVER_LIST
for SERVER in $(cat ${SERVER_LIST})
do
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${SERVER}"
  fi

  SSH_COMMAND="ssh ${SSH_OPTIONS} ${SERVER} ${SUDO} ${COMMAND}"

  #If its a dry run, dont execute, just echo
  if [[ "${DRY_RUN}" = 'true' ]]
  then
    echo "DRY RUN: ${SSH_COMMAND}"
  else
    ${SSH_COMMAND}
    SSH_EXIT_STATUS="${?}"

    #Capture any non-zero exit status from the SSH_COMMAND and report to the user
    if [[ "${SSH_EXIT_STATUS}" -ne 0 ]]
    then
      EXIT_STATUS="${SSH_EXIT_STATUS}"
      echo "Executing on ${SERVER} failed." >&2
    fi
  fi
done

exit ${EXIT_STATUS}
