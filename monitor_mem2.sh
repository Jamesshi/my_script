#!/bin/bash
function watch_cpu(){
ps aux | awk 'NR>2{print $3, $2, $1 }' | sort -rnk 1,3 | awk '$1>2.0{"date"|getline date;print date;print "These prosess used cpu more than 2%"; printf "%d\n",$2}' >> ./cpu_log.txt
}

function watch_mem()
{
ps aux | awk '$4>5{"date"|getline date ;print date;printf "this process used mem more than 5M the ID is : %d\n",$2;print $0 }' >> ./mem_log.txt;
}


count=`pgrep monitor_mem2.sh | wc -l`
if [ $count -eq 2 ];then
	watch_mem
	watch_cpu
else
	exit
fi
