#判断进程是否正在运行
#
#
#!/bin/bash

while :
do
#	msg=`ps -ef | grep ./yCatServer |awk '{ print $4 }'`
#	echo "A:" $msg		
#	[[ "$msg" =~ "./yCatServer" ]]  ||`date>>/home/yCatServer/1.txt` `service yCatServerD start >>/home/yCatServer/1.txt`
#	[[ "$msg" =~ "./yCatServer" ]]  ||`date>>/home/yCatServer/1.txt` `/etc/init.d/S99yCatServerD start >>/home/yCatServer/1.txt`
	used=`free -m|awk 'NR==2'|awk '{print $3}'`
	free=`free -m|awk 'NR==2'|awk '{print $4}'`
	if [ $free -le 100 ]; then
		sync && echo 1 > /proc/sys/vm/drop_caches
		sync && echo 2 > /proc/sys/vm/drop_caches
		sync && echo 3 > /proc/sys/vm/drop_caches
		echo "dorp OK| [Use: ${used}MB [Free: ${free}MB]]" >> /var/log/mem.log
	fi
	sleep 100
done

exit 0
