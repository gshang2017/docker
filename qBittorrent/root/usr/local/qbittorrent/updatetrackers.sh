#! /bin/sh

if [ "$QB_TRACKERS_UPDATE_AUTO" == "true" ]; then
  curl -so /tmp/trackers_all.txt $QB_TRACKERS_LIST_URL
  if [ -e "/tmp/trackers_all.txt" ]; then
    Newtrackers="Session\AdditionalTrackers=$(awk '{if(!NF){next}}1' /tmp/trackers_all.txt|sed ':a;N;s/\n/\\n/g;ta' )"
    Oldtrackers="`grep AdditionalTrackers= /config/qBittorrent/config/qBittorrent.conf`"
    echo $Newtrackers >/tmp/Newtrackers.txt
    if [ "$Newtrackers" == "$Oldtrackers" ]; then
      echo trackers文件一样,不需要更新。
    else
      sed -i '/Session\\AdditionalTrackers=/r /tmp/Newtrackers.txt' /config/qBittorrent/config/qBittorrent.conf
      sed -i '1,/^Session\\AdditionalTrackers=.*/{//d;}' /config/qBittorrent/config/qBittorrent.conf
      chown qbittorrent:qbittorrent /config/qBittorrent/config/qBittorrent.conf
      #kill qBittorrent
      if [ `ps -ef |grep profile |grep -v grep |wc -l` -ne 0 ]; then
        ps -ef |grep profile |grep -v grep |awk '{print $1}'|xargs kill -9
      fi
      echo 已更新trackers。
    fi
    rm /tmp/trackers_all.txt /tmp/Newtrackers.txt
  else
    echo 更新文件未正确下载，更新未成功，请检查网络。
  fi
else
  echo 未设定自动更新trackers。
fi
