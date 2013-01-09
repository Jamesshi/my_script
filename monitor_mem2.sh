#!/bin/bash
#watch memery is any process eat mem more than 5M echo it to mem_log.txt
#it works as cron job

function watch_mem()
{
while :
do 
ps aux | awk '$4>5{"date"|getline date ;print date;printf "the process ID is : %d\n",$2;print $0 }' >> ./mem_log.txt;
sleep 5;

done;
}
count=`pgrep monitor_mem.sh | wc -l`
#echo $count
if [ $count -eq 2 ];then
	count=0
	watch_mem
else
	exit
fi
#exit
