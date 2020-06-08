#!/bin/bash
LOG_FILE=/home/patrycja/log.txt
max_retry=10
i=1
while true
do
[[ $i -eq max_retry ]] && echo "Last attempt-send email with attachment" >> ${LOG_FILE} && echo "Message Body" | mutt -s "Subject" -a log.txt -- email@mail.com && exit 1
echo "#$i attempt" >> ${LOG_FILE}
((i++))
sleep 1
done
