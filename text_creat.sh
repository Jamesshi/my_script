#!/bin/bash
#use for enterin some special format line
#for example:
#northwest	NW  Charles Main        3.0	0.98	3	34
#western	WE  Sharon Gray         5.3	0.97	5	23
printf "%-8s\t%-4s%-20s%2.1f\t%0.2f\t%d\t%d\n" $1 $2 "$3" $4 $5 $6 $7
