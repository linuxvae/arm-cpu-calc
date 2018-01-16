#!/bin/sh
echo '$1 threads cpu'

i=0
for tid in `ls /proc/$1/task/`
do
	tm1[$i]=`cat  /proc/$1/task/$tid/stat |awk  -F " " '{print $14+$15}'`
	let i++
done
total=`cat /proc/stat |awk -F " " 'NR==1{print  $2+$3+$4+$5+$6+$7+$8}'`
echo $total

sleep 10s

i=0
for tid in `ls /proc/$1/task/`
do
        tm2[$i]=`cat  /proc/$1/task/$tid/stat |awk  -F " " '{print $14+$15}'`
        let i++
done

total2=`cat /proc/stat |awk -F " " 'NR==1{print  $2+$3+$4+$5+$6+$7+$8}'`
echo $total2

i=0
total3=`expr $total2 - $total`
for tid in `ls /proc/$1/task/`
do
	tm3=`expr ${tm2[$i]} - ${tm1[$i]}`
	cpus=`cat /proc/cpuinfo| grep "processor"| wc -l`
	tcpu=`expr $tm3 \* $cpus \* 100 / $total3`
	echo "thread $tid cps: $tcpu"
	let i++
done
