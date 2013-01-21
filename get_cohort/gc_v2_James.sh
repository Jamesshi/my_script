#!/bin/bash

#建立临时文件
>./gctmp.txt
>./del_file_list.txt
>./diff_set.txt

#创建结果存放目录
mkdir ./result

#从所有的文件中抓取Cohort，将文件名添至其后，输出到gctmp.txt
for f in $(<$1)
do
	cat $f|grep -m 1 dbg_orig_request | cut -f2 -d'"' | cut -f4- -d','| tr -s '\n' '\ '
	printf "@%s\n" $f
done >> ./gctmp.txt



#比较重复的Cohort，将含有重复Cohort的文件名输出到del_file_list.txt
cat ./gctmp.txt | sort | awk -F@ 'BEGIN{last=""}{if(last==$1){print $2;}else{last=$1;}}'>>./del_file_list.txt


#删出被del_file_list.txt记录的文件
#for dfl in `cat del_file_list.txt`
#do
#rm $dfl
#done


#取得文件差集
cat $1 del_file_list.txt | sort | uniq -u >> ./diff_set.txt



#cp文件
for cp_file in $(<diff_set.txt)
do
	cp $cp_file ./result/
done
#删除临时文件
rm ./gctmp.txt ./del_file_list.txt ./diff_set.txt
