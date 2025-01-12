#!/bin/sh

if [ `mpc outputs |grep "enabled" |wc -l` -eq 1   ] ; then
	OUTPUTS_NUM=$(mpc outputs |grep "enabled" | awk -F" " '{print $2}')
elif [ `mpc outputs |grep "enabled" |wc -l` -eq 0   ] ; then
	OUTPUTS_NUM=""
else
	mpc enable only 1
	OUTPUTS_NUM=$(mpc outputs |grep "enabled" | awk -F" " '{print $2}')
fi
while mpc idle output; do
	if [ `mpc outputs |grep "enabled" |wc -l` -eq 1   ] ; then
		OUTPUTS_NUM=$(mpc outputs |grep "enabled" | awk -F" " '{print $2}')
	elif [ `mpc outputs |grep "enabled" |wc -l` -eq 2   ] ; then
		mpc outputs |grep "enabled" |awk -F" " '{print $2}'| grep -v $OUTPUTS_NUM |xargs  mpc enable only
		OUTPUTS_NUM=$(mpc outputs |grep "enabled" | awk -F" " '{print $2}')
	elif [ `mpc outputs |grep "enabled" |wc -l` -gt 2   ] ; then
		mpc disable $OUTPUTS_NUM
		OUTPUTS_NUM=$(mpc outputs |grep "enabled" | awk -F" " '{print $2}')
	else
		OUTPUTS_NUM=""
	fi
done
