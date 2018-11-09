#! /bin/sh

if [ "$TRACKERSAUTO" == "YES" ];then

wget -qP  /tmp  https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt --no-check-certificate 
Newtrackers="bt-tracker=`awk NF /tmp/trackers_all.txt|sed ":a;N;s/\n/,/g;ta"`"
Oldtrackers="`grep bt-tracker=  /usr/local/aria2/aria2.conf`" 

if [ $Newtrackers == $Oldtrackers ];then
echo trackers文件一样,不需要更新。
else
sed -i 's@'"$Oldtrackers"'@'"$Newtrackers"'@g'   /usr/local/aria2/aria2.conf 
#kill aria2
ps -ef |grep aria2.conf |grep -v grep|awk '{print $1}'|xargs kill -9
#重启aria2
if [ ! -n "$RPC_SECRET" ] ;  then 
aria2c --conf-path=/usr/local/aria2/aria2.conf --enable-rpc --rpc-listen-all   -D
elif  [ "$SECRETAUTO" == "YES" ]; then
aria2c --conf-path=/usr/local/aria2/aria2.conf --enable-rpc --rpc-listen-all --rpc-secret="$RPC_SECRET" -D
else 
aria2c --conf-path=/usr/local/aria2/aria2.conf --enable-rpc --rpc-listen-all --rpc-secret="$RPC_SECRET" -D
fi
echo 已更新trackers。
fi

rm  /tmp/trackers_all.txt

else

echo 未设定自动更新trackers。

fi


