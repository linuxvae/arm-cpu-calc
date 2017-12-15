#!/bin/sh
echo '$1 threads cpu'

for tid in `ls /proc/$1/task/`
do
	tm=`cat  /proc/$1/task/$tid/stat |awk  -F " " '{print $14+$15}'`
	echo $tm
done

total=`cat /proc/stat |awk -F " " 'NR==1{print  $2+$3+$4+$5+$6+$7+$8}'`
echo $total

sleep 10s

for tid in `ls /proc/$1/task/`
do
        tm2=`cat  /proc/$1/task/$tid/stat |awk  -F " " '{print $14+$15}'`
        echo $tm2
done

total2=`cat /proc/stat |awk -F " " 'NR==1{print  $2+$3+$4+$5+$6+$7+$8}'`
echo $total2

total3=`expr $total2 - $total`
tm3=`expr $tm2 - $tm`
cpus=`cat /proc/cpuinfo| grep "processor"| wc -l`
echo $cpus $total3 $tm3

tcpu=`expr $tm3 \* $cpus \* 100 / $total3`
echo "thread cps: $tcpu"
