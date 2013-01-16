#!/bin/bash

#Function Description
#This script download all of pdf file in a designated webpage
#it will check the time , this script only run in 18:30 to 3:00 ,if not it will exit 1.if run in any time please comment line 48.
#if a file already downlad ,it will skips it. 
#it is design run as cron job

#please add the following line without # to /etc/crontab 
#30 18	* * *	user  this_script_path_and_name /etc/cron.daily

#Exiting codes
#exit 1	not in right time 
#exit 2	The script already runing or last time exit abnormal

#what is the time? The script will run in local time 18:30 to 3:00. If the time is not in it ,the script will exit 1
function check_time () {
ctime=$(date +%H%M)
if [[ $ctime -gt 300 || $ctime -lt 1830 ]]
then
exit 1
fi
}

#check the script itself status,if it's runing,exit 2
function check_script_status () {
if ls -a | grep .it_is_a_very_long_name_and_some_meaningless_words_fjdshngiuhuiqwfh_djhnujewh > /dev/null 2>&1
then
echo The script already runing or last time exit abnormal.If it is not runing please do this:
echo rm ./.it_is_a_very_long_name_and_some_meaningless_words_fjdshngiuhuiqwfh_djhnujewh
echo then run it agen
exit 2
fi
touch ./.it_is_a_very_long_name_and_some_meaningless_words_fjdshngiuhuiqwfh_djhnujewh
}

function del_wget_tmp_file(){
(cd ./all_of_pdf;
if ls | grep '.*\..*\.1'
then
rm $(ls| grep '.*\..*\.1' | awk -F"." 'BEGIN{OFS="."}{print $1,$2}');
rm $(ls | grep '.*\..*\.1')
fi
)
}

#check environment
check_time
check_script_status

#creat temporary file
>./.the_web_page.txt
>./.the_pdf_url.txt

#creat the directory save pdf file
#and check wget temporary file,if it's exist delete it.
if ls -l | grep -e '^d.*all_of_pdf$' > /dev/null 2>&1 
then
	echo The dir all_of_pdf already exists,do not creat it agen.
	del_wget_tmp_file
	echo

else
	mkdir all_of_pdf
	echo mkdir all_of_pdf OK.
fi

#download webpage save as txt
echo Downloading the webpage...
lynx -dump 'http://www.fanniemae.com/mbs/documents/remic/remicprospectussupplements.jhtml?p=Mortgage-Backed+Securities&s=Prospectuses+%26+Related+Documents&t=REMICs+%26+Structured+Transactions&q=Prospectus+Supplements' | grep " http://www.efanniemae.com/syndicated/documents/mbs/remicsupp/" > ./.the_web_page.txt 
echo Download webpage OK.
echo

#extact pdf file url frome the webpage
echo Extracting pdf url...
cat ./.the_web_page.txt | cut -b 6- > ./.the_pdf_url.txt
echo Extract the pdf url OK.
echo

#use wget download the pdf file
#check local pdf file ,if one pdf file exist ,skip it ,download next.
echo Downloading the pdf file...
for pdf_url in $(<.the_pdf_url.txt)
do
down_url=$(echo $pdf_url | awk -F'/' '{print $8}')
if ls ./all_of_pdf | awk -F'.' 'BEGIN{OFS="."}{print $1,$2}' | grep $down_url
then
	echo $dwon_url already download,skip it.
	continue
fi
wget -P ./all_of_pdf $pdf_url
done
echo Download the pdf file OK.

#delete temporary file
echo Deleting temporary file
rm ./.the_pdf_url.txt
rm ./.the_web_page.txt
rm ./.it_is_a_very_long_name_and_some_meaningless_words_fjdshngiuhuiqwfh_djhnujewh
echo Delete temporary file OK.
