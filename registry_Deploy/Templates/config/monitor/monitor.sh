#!/bin/bash

step=2

MoniPath=$1
monitor=${MoniPath}/monitor.py
echo $monitor

for (( i = 0; i < 60; i=(i+step) )); do
    python $monitor
    #echo "$monitor" >> ${MoniPath}/test.log
    sleep $step
done

exit 0
