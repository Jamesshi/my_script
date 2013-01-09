#!/bin/bash

function watch_mem()
{
while :
do 
ps aux | awk '$4>5{"date"|getline date ;print date;printf "the process ID is : %d\n",$2;print $0 }' >> ./mem_log.txt;
sleep 5;

done;
}
count=`pgrep monitor_mem2.sh | wc -l`
if [ $count -eq 2 ];then
	count=0
	watch_mem
else
	exit
fi
