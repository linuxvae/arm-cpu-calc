#!/bin/bash 
if (( $# < 1 )) 
then 
    echo "usage: `basename $0` pid" 1>&2 
    exit 1 
fi

if [[ ! -r /proc/$1 ]] 
then 
    echo "Process $1 not found." 1>&2 
    exit 1 
fi

backtrace="bt" 
if [[ -d /proc/$1/task ]] 
then 
    if [[ `ls /proc/$1/task 2>/dev/null | wc -l` > 1 ]] 
    then 
        backtrace="thread apply all bt" 
    fi  ; 
elif [[ -f /proc/$1/maps ]] 
then 
        if grep -e libpthread /proc/$1/maps > /dev/null 2>&1 
    then 
                backtrace="thread apply all bt" 
        fi 
fi

GDB=gdb

for id in `(ls /proc/$1/task/)`
do
    $GDB -quiet -nx /proc/$1/exe -p $id <<<"$backtrace" | 
        sed -n  \
        -e 's/^(gdb) //' \
        -e '/^#/p' \
        -e '/^Thread/p'
done
