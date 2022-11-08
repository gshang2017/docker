## 群晖nas自用：

### GitHub:

[https://github.com/gshang2017/docker](https://github.com/gshang2017/docker)

### 感谢以下项目:

[https://github.com/aria2/aria2](https://github.com/aria2/aria2)                        
[https://github.com/mayswind/AriaNg](https://github.com/mayswind/AriaNg)             
[https://github.com/ngosang/trackerslist](https://github.com/ngosang/trackerslist)

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|Aria2|1.36.0|amd64;arm64v8;arm32v7,修改线程数至128，默认32，集成Trackers自动更新。|
|AriaNg|1.3.0|Aria2的web管理界面|

### docker命令行设置：

* 变量名变更

    |版本|1.36.0-1.2.3及以后|1.36.0及以前|
    |:-:|:-|:-|
    |1|ARIA2_RPC_SECRET|RPC_SECRET|
    |2|ARIANG_RPC_SECRET_AUTO|SECRETAUTO|
    |3|ARIA2_TRACKERS_UPDATE_AUTO|TRACKERSAUTO|
    |4|ARIA2_TRACKERS_LIST_URL|TRACKERS_LIST_URL|

1. 下载镜像

    |镜像源|命令|
    |:-|:-|
    |DockerHub|docker pull johngong/aria2:latest|
    |GitHub|docker pull ghcr.io/gshang2017/aria2:latest|

2. 创建aria2容器

        docker create \
           --name=aria2 \
           -p 6881:6881 \
           -p 6881:6881/udp \
           -p 6800:6800 \
           -p 8080:8080 \
           -e ARIA2_RPC_SECRET=不需要可不填 \
           -e ARIA2_RPC_LISTEN_PORT=6800 \
           -e ARIA2_LISTEN_PORT=6881 \
           -e UID=1000 \
           -e GID=1000 \
           -e UMASK=022 \
           -v /配置文件位置:/config \
           -v /下载位置:/Downloads \
           --restart unless-stopped \
           johngong/aria2:latest

3. 运行

       docker start aria2

4. 停止

       docker stop aria2

5. 删除容器

       docker rm aria2

6. 删除镜像

       docker image rm johngong/aria2:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=aria2` |容器名|
| `-p 6881:6881` |BT下载监听端口|
| `-p 6881:6881/udp` |BT下载DHT监听端口|
| `-p 8080:8080 ` | AriaNG web访问端口|
| `-p 6800:6800` |Aria2 RPC 默认端口|
| `-v /配置文件位置:/config` |Aria2配置文件位置|
| `-v /下载位置:/Downloads` |Aria2默认下载位置|
| `-e UID=1000` |uid设置,默认为1000|
| `-e GID=1000` |gid设置,默认为1000|
| `-e UMASK=022` |umask设置,默认为022|
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `-e ARIA2_RPC_SECRET=` |Aria2 RPC token值，默认为空|
| `-e ARIA2_RPC_LISTEN_PORT=6800` |Aria2 RPC 默认端口|
| `-e ARIA2_LISTEN_PORT=6881` |BT下载及DHT监听端口|
| `-e ARIA2_TRACKERS_UPDATE_AUTO=true` |(true\|false)自动更新Aria2的trackers,默认开启|
| `-e ARIA2_TRACKERS_LIST_URL=` |trackers更新地址设置,仅支持ngosang格式,默认为  </br>https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt |
| `-e ARIA2_CONF_LANGUAGE=zh_Hans` |(zh_Hans\|zh_Hant\|en)Aria2配置文件注释语言|
| `-e ARIANG_RPC_SECRET_AUTO=true` |(true\|false)自动添加AriaNG里RPC连接中token值,默认开启|
| `-e ARIANG_RPC_LISTEN_PORT_AUTO=true` |(true\|false)自动添加AriaNG里RPC连接中port值(本地与容器端口需一致),默认开启|

### 群晖docker设置：

1. 卷

|参数|说明|
|:-|:-|
| `本地文件夹1:/Downloads` |Aria2默认下载位置|
| `本地文件夹2:/config` |Aria2配置位置文件|

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:6881` |BT下载监听端口|
| `本地端口2:6881/udp` |BT下载DHT监听端口|
| `本地端口3:6800` |Aria2 RPC 默认端口|
| `本地端口4:8080` |AriaNG web访问端口|

3. 环境变量：

|参数|说明|
|:-|:-|
| `UID=1000` |uid设置,默认为1000|
| `GID=1000` |gid设置,默认为1000|
| `UMASK=022` |umask设置,默认为022|
| `TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `ARIA2_RPC_SECRET=` |Aria2 RPC token值，默认为空|
| `ARIA2_RPC_LISTEN_PORT=6800` |Aria2 RPC 默认端口|
| `ARIA2_LISTEN_PORT=6881` |BT下载及DHT监听端口|
| `ARIA2_TRACKERS_UPDATE_AUTO=true` |(true\|false)自动更新Aria2的trackers,默认开启|
| `ARIA2_TRACKERS_LIST_URL=` |trackers更新地址设置,仅支持ngosang格式,默认为  </br>https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt |
| `ARIA2_CONF_LANGUAGE=zh_Hans` |(zh_Hans\|zh_Hant\|en)Aria2配置文件注释语言|
| `ARIANG_RPC_SECRET_AUTO=true` |(true\|false)自动添加AriaNG里RPC连接中token值,默认开启|
| `ARIANG_RPC_LISTEN_PORT_AUTO=true` |(true\|false)自动添加AriaNG里RPC连接中port值(本地与容器端口需一致),默认开启|
