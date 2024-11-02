## 群晖nas自用：

### GitHub:

[https://github.com/gshang2017/docker](https://github.com/gshang2017/docker)

### 感谢以下项目:

[https://github.com/qbittorrent/qBittorrent](https://github.com/qbittorrent/qBittorrent)   
[https://github.com/c0re100/qBittorrent-Enhanced-Edition](https://github.com/c0re100/qBittorrent-Enhanced-Edition)    
[https://github.com/ngosang/trackerslist]( https://github.com/ngosang/trackerslist)

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|qBittorrent-qBittorrentEE|5.0.1-5.0.0.10|(amd64;arm64v8;arm32v7) 集成Trackers自动更新|

#### 版本升级注意：

* 新版更改了变量名[TRACKERSAUTO WEBUIPORT TRACKERS_LIST_URL(4.4.0、4.4.0.10及以前)]，</br>新增QB_EE_BIN=true设定使用qBittorrent-EE。

### docker命令行设置：

* 变量名变更

    |版本|4.4.1-4.4.1.10及以后|4.4.0、4.4.0.10及以前|
    |:-:|:-|:-|
    |1|QB_TRACKERS_UPDATE_AUTO=true|TRACKERSAUTO=YES|
    |2|QB_WEBUI_PORT|WEBUIPORT|
    |3|QB_TRACKERS_LIST_URL|TRACKERS_LIST_URL|

1. 下载镜像

    |镜像源|命令|
    |:-|:-|
    |DockerHub|docker pull johngong/qbittorrent:latest|
    |GitHub|docker pull ghcr.io/gshang2017/qbittorrent:latest|

2. 创建qbittorrent容器

        docker create \
           --name=qbittorrent \
           -e QB_WEBUI_PORT=8989 \
           -e QB_EE_BIN=false \
           -e UID=1000 \
           -e GID=1000 \
           -e UMASK=022 \
           -p 6881:6881 \
           -p 6881:6881/udp \
           -p 8989:8989 \
           -v /配置文件位置:/config \
           -v /下载位置:/Downloads \
           --restart unless-stopped \
           johngong/qbittorrent:latest

3. 运行

       docker start qbittorrent

4. 停止

       docker stop qbittorrent

5. 删除容器

       docker rm qbittorrent

6. 删除镜像

       docker image rm johngong/qbittorrent:latest

### 变量:

|参数|说明|
|-|:-|
| `--name=qbittorrent` |容器名|
| `-p 8989:8989` |web访问端口 [IP:8989](IP:8989);(默认用户名:admin;默认密码:adminadmin);</br>此端口需与容器端口和环境变量保持一致，否则无法访问|
| `-p 6881:6881` |BT下载监听端口|
| `-p 6881:6881/udp` |BT下载DHT监听端口
| `-v /配置文件位置:/config` |qBittorrent配置文件位置|
| `-v /下载位置:/Downloads` |qBittorrent下载位置|
| `-e UID=1000` |uid设置,默认为1000|
| `-e GID=1000` |gid设置,默认为1000|
| `-e UMASK=022` |umask设置,默认为022|
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `-e QB_WEBUI_PORT=8989` |web访问端口环境变量|
| `-e QB_EE_BIN=false` |(true\|false)设置使用qBittorrent-EE,默认不使用|
| `-e LIBTORRENT2=false` |(true\|false)设置使用libtorrent2.0编译版,默认不使用|
| `-e QB_TRACKERS_UPDATE_AUTO=true` |(true\|false)自动更新qBittorrent的trackers,默认开启|
| `-e QB_TRACKERS_LIST_URL=` |trackers更新地址设置,仅支持ngosang格式,默认为 </br>https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt |
| `-e ENABLE_CHOWN_DOWNLOADS=true` |(true\|false)设定修复Downloads文件夹拥有者，默认开启|
| `-e ENABLE_CHOWN_R_DOWNLOADS=true` |(true\|false)设定递归修复Downloads文件夹拥有者，默认开启|
| `-e QB_DOWNLOADS_DIRECTORY=/Downloads` |qBittorrent下载位置，默认/Downloads(仅用于修复权限)|

### 群晖docker设置：

1. 卷

|参数|说明|
|-|:-|
| `本地文件夹1:/Downloads` |qBittorrent下载位置|
| `本地文件夹2:/config` |qBittorrent配置文件位置|

2. 端口

|参数|说明|
|-|:-|
| `本地端口1:6881` |BT下载监听端口|
| `本地端口2:6881/udp` |BT下载DHT监听端口|
| `本地端口3:8989` |web访问端口 [IP:8989](IP:8989);(默认用户名:admin;默认密码:adminadmin);</br>此端口需与容器端口和环境变量保持一致，否则无法访问|

3. 环境变量：

|参数|说明|
|-|:-|
| `UID=1000` |uid设置,默认为1000|
| `GID=1000` |gid设置,默认为1000|
| `UMASK=022` |umask设置,默认为022|
| `TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `QB_WEBUI_PORT=8989` |web访问端口环境变量|
| `QB_EE_BIN=false` |(true\|false)设置使用qBittorrent-EE,默认不使用|
| `LIBTORRENT2=false` |(true\|false)设置使用libtorrent2.0编译版,默认不使用|
| `QB_TRACKERS_UPDATE_AUTO=true` |(true\|false)自动更新qBittorrent的trackers,默认开启|
| `QB_TRACKERS_LIST_URL=` |trackers更新地址设置,仅支持ngosang格式,默认为 </br>https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt |
| `ENABLE_CHOWN_DOWNLOADS=true` |(true\|false)设定修复Downloads文件夹拥有者，默认开启|
| `ENABLE_CHOWN_R_DOWNLOADS=true` |(true\|false)设定递归修复Downloads文件夹拥有者，默认开启|
| `QB_DOWNLOADS_DIRECTORY=/Downloads` |qBittorrent下载位置，默认/Downloads(仅用于修复权限)|

### 搜索：

#### 开启：视图-搜索引擎:
##### 说明：

1. 自带 [https://github.com/qbittorrent/search-plugins/tree/master/nova3/engines](https://github.com/qbittorrent/search-plugins/tree/master/nova3/engines) 搜索插件
2. 其它搜索插件下载地址 [https://github.com/qbittorrent/search-plugins/wiki/Unofficial-search-plugins](https://github.com/qbittorrent/search-plugins/wiki/Unofficial-search-plugins)
3. 一些搜索插件网站需过墙才能用
4. jackett搜索插件需配置jackett.json(位置config/qBittorrent/data/nova3/engines)，插件需配合jackett服务的api_key。</br>可自行搭建docker版jackett(例如linuxserver/jackett)。

### 其它:

1. Trackers只有一个工作,新增的Trackers显示还未联系，需在qBittorrent.conf里 </br>旧：[Preferences]下增加Advanced\AnnounceToAllTrackers=true，</br>新：[BitTorrent]下增加Session\AnnounceToAllTrackers=true。
