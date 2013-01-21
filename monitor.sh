#!/bin/bash

#Exiting codes
#exit 1 this script already runing or last time exit abnormal 
#exit 2 fail to delete the lock file


#please add the following line without # to /etc/crontab and set it 
#* *  * * *   user  this_script_path_and_name /etc/cron.daily

#check the script itself status,if it's runing,exit 2
function check_script_status () {
if ls -a | grep .monitor_it_is_a_very_long_name_and_some_meaningless_words_fjdshngiuhuiqwfh_djhnujewh > /dev/null 2>&1
then
echo The script already runing or last time exit abnormal.If it is not runing please do this:
echo rm ./.monitor_it_is_a_very_long_name_and_some_meaningless_words_fjdshngiuhuiqwfh_djhnujewh
echo then run it agen
exit 1
fi
touch ./.monitor_it_is_a_very_long_name_and_some_meaningless_words_fjdshngiuhuiqwfh_djhnujewh
}

#delete lock file
function delete_lock_file () {
if rm ./.monitor_it_is_a_very_long_name_and_some_meaningless_words_fjdshngiuhuiqwfh_djhnujewh
then
	exit 0
else
	exit 2
fi
}

#监视cpu使用率，如果某个进程cpu使用率超过1%就把该进程PID和cpu使用率输出到./monitor.txt文件
#监视内存使用率，如果某个进程内存使用率超过1M就把该进程PID和内存占用输出到./monitor.txt文件
function watch_cpu_mem () {
date >> ./monitor.txt
ps aux | awk 'NR<2{
pritnf ("Process used cpu more than 1\% used mem more than 1M\n")
printf ("%s\t%s\t%s\n",$2,$3,$4)
}'>>./monitor.txt
ps aux | awk 'NR>1{ 
	if ($3>1)
{
	printf ("%s\t%s\n",$2,$3)
}
	if ($4>1){
	printf ("%s\t\t%s\n",$2,$4) 
}
}'>>./monitor.txt 
}
function watch_mem () {
ps aux | awk 'NR<2{
print $2,$4
}'>>mem_log.txt
ps aux | awk 'NR>1{
	if ($4>1)
{
	print $2,$4
}
}'>>mem_log.txt
}
check_script_status
watch_cpu_mem
#watch_mem 
delete_lock_file
