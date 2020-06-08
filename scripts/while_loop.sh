#!/bin/bash
LOG_FILE=/home/patrycja/log.txt
max_retry=10
i=1
while true
do
[[ $i -eq max_retry ]] && echo "Last attempt-sending email notification" >> ${LOG_FILE} && echo -e "Subject: 10th attempt `hostname`\nTo: patrycja.p9428@gmail.com\n\n`cat ${LOG_FILE}`" | /usr/sbin/sendmail patrycja.p9428@gmail.com && exit 1
echo "#$i attempt" >> ${LOG_FILE}
((i++))
sleep 1
done
