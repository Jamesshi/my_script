#!/bin/bash

#该脚本应当运行在WFPrepayment目录
#该脚本将运行结果输出到stdout
#从fn30.txt fh30.txt g130.txt g230.txt fn15.txt fh15.txt g115.txt g215.txt文件中提取数据
#Aggregate行,从以上文件中提取出year是All，CPN也是All，Nov.的数据
#2.0%至6.5%的数据是year为All，CPN是对应的值，Nov.的数据
#如：下表中第4行第2列的值为0.3。fn30.txt中提取year为All，CPN为2.5%,Nov.所对应的值为0.3
#如果没有相应的值，直接打印TAB，如下表中第3行第1列
#下表中字段之间的分隔符为TAB

#该函数是输出结果示例，该函数不会被执行
function result_this_function_will_not_be_carried_out () {
Cpn	FN30	FH30	GI30	GII30	FN15	FH15	GI15	GII15	
Aggregate	1.1	1.0	0.5	0.4	0.5	0.2	0.1	-0.3	
2.0%			0.2	0.8	0.2	-0.3	0.2	-2.3	
2.5%	0.3	0.7	-0.3	0.2	-0.6	1.0	1.2	-0.8	
3.0%	-0.2	1.0	0.4	0.3	-0.6	-1.3	-0.2	1.1	
3.5%	-0.8	-0.7	1.5	1.5	1.5	0.7	2.8	0.4	
4.0%	1.6	1.3	-0.9	1.6	2.8	1.5	-0.1	-2.2	
4.5%	2.5	2.2	0.4	0.6	2.6	1.2	-1.0	1.5	
5.0%	2.4	1.7	0.5	0.5	1.0	1.2	-1.2	0.4	
5.5%	2.7	1.4	3.3	1.0	1.9	1.8	0.6	5.1	
6.0%	2.3	1.6	2.2	2.2	1.4	1.1	-1.4	3.9	
6.5%	1.8	1.0	0.9	4.0	1.7	1.2	6.3	9.5
}

#从txt文件中提取所需要的信息，生成临时文件
function get_info () {
for file in fn30.txt fh30.txt g130.txt g230.txt fn15.txt fh15.txt g115.txt g215.txt
do
	cat "$file" | awk '{if($2=="All"){printf("%s\t%s\n",$1,$5)}}'>tmp_$file
done
}

#删除临时文件
function del_tmp_file () {
for file in fn30.txt fh30.txt g130.txt g230.txt fn15.txt fh15.txt g115.txt g215.txt
do
	rm tmp_$file
done
}

#输出第二行，All All
function print_second_line () {
printf "%s\t" Aggregate
for file in fn30.txt fh30.txt g130.txt g230.txt fn15.txt fh15.txt g115.txt g215.txt
do
	cat tmp_$file | awk 'NR=1{if($1=="All"){printf("%s\t",$2)}}'
done
echo
}
#打印表头
function print_head () {
printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" Cpn FN30 FH30 GI30 GII30 FN15 FH15 GI15 GII15 
}

#打印主表
function print_main () {
for cpn in 2.00 2.50 3.00 3.50 4.00 4.50 5.00 5.50 6.00 6.50
do
	echo -n $cpn | awk -F "" '{print $1$2$3"%""\t"}'|tr -d '\n'
	for file in fn30.txt fh30.txt g130.txt g230.txt fn15.txt fh15.txt g115.txt g215.txt
	do
		cat tmp_$file | grep $cpn | awk -v cpn=$cpn -F"\t" '{
						printf("%s",$2)
	}'
		printf "\t"
	done
	printf "\n"
done
}
	
get_info
print_head
print_second_line
print_main
del_tmp_file


