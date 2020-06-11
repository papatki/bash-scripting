#!/bin/bash
#This script demonstrates I/O redirection
#Redirect STDOUT to a file
FILE="/tmp/data"
head -n1 /etc/passwd > ${FILE}

#Redirect STDIN to a program
read LINE < ${FILE}
echo "LINE contains: ${LINE}"

#Redirect STDOUT to a file, overwriting the file
head -n3 /etc/passwd > ${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}

#Redirect STDOUT to a file, appending to that file
echo "${RANDOM} ${RANDOM}" >> ${FILE}
echo
echo "Contents of ${FILE}"
cat ${FILE}

#Redirecting STDIN to a program using FD 0
read LINE 0< ${FILE}
echo
echo "LINE contains: ${LINE}"

#Redirecting STDOUT to a file using FD 1, overwring the file
head -n3 /etc/passwd 1> ${FILE}
echo
echo "Contents of ${FILE}:"
cat ${FILE}
#Redirecting STDERR to a file using FD 2
ERR_FILE="/tmp/data.err"
head -n3 /etc/passwd /fakefile 2> ${ERR_FILE}

#Redirect STDOUT and STRERR to a file
head -n3 /etc/passwd /fakefile &> ${FILE}
echo 
echo "Contents of ${FILE}:"
cat ${FILE}

#redirect STDOUT and STRERR through the pipe
echo
head -n3 /etc/passwd /fakefile |& cat -n


#Clean
rm ${FILE} ${ERR_FILE}

