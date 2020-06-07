#!/bin/bash
LOG_FILE=/logfile.log
max_retry=10
i=1
while true
do
[[ $i -eq max_retry ]] && echo `date +c%` - "Last attempt" >> ${LOG_FILE} && echo -e "Subject: 10th attempt `hostname`\nTo: patrycja.p9428@gmail.com\n\n`cat ${LOG_FILE}`" | /usr/sbin/sendmail patrycja.p9428@gmail.com && exit 1
echo "#$i attempt" >> ${LOG_FILE}
((i++))
sleep 5
done
