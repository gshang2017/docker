## 群晖nas自用

### GitHub:

[https://github.com/gshang2017/docker](https://github.com/gshang2017/docker)

### 感谢以下项目:

[https://github.com/koreader/koreader-sync-server](https://github.com/koreader/koreader-sync-server)                 

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|koreader-sync-server|2.0|amd64;arm64v8;arm32v7|

### docker命令行设置：

1. 下载镜像

    |镜像源|命令|
    |:-|:-|
    |DockerHub|docker pull johngong/koreader-sync-server:latest|
    |GitHub|docker pull ghcr.io/gshang2017/koreader-sync-server:latest|

2. 创建anki容器

        docker create \
           --name=koreader-sync-server \
           -p 7200:7200 \
           -v ./config:/config \
           -v ./logs/app:/app/koreader-sync-server/logs \
           -v ./logs/redis:/var/log/redis \
           -v ./data/redis:/var/lib/redis \
           -e UID=1000 \
           -e GID=1000 \     
           --restart unless-stopped \
           johngong/koreader-sync-server:latest

3. 运行

       docker start koreader-sync-server

4. 停止

       docker stop koreader-sync-server

5. 删除容器

       docker rm koreader-sync-server

6. 删除镜像

       docker image rm johngong/koreader-sync-server:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=koreader-sync-server` |容器名|
| `-p 7200:7200` |koreader-sync-server监听端口|
| `-v ./config:/config` |koreader-sync-server配置文件位置|
| `-v ./logs/app:/app/koreader-sync-server/logs` |koreader-sync-server日志文件位置|
| `-v ./logs/redis:/var/log/redis` |redis日志文件位置|
| `-v ./data/redis:/var/lib/redis` |redis数据库位置|
| `-e UID=1000` |uid设置,默认为1000|
| `-e GID=1000` |gid设置,默认为1000|
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|

### 群晖docker设置：

1. 卷

|参数|说明|
|:-|:-|
| `./config:/config` |koreader-sync-server配置文件位置|
| `./logs/app:/app/koreader-sync-server/logs` |koreader-sync-server日志文件位置|
| `./logs/redis:/var/log/redis` |redis日志文件位置|
| `./data/redis:/var/lib/redis` |redis数据库位置|

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:7200` |koreader-sync-server监听端口|

3. 环境变量

|参数|说明|
|:-|:-|
| `UID=1000` |uid设置,默认为1000|
| `GID=1000` |gid设置,默认为1000|
| `TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|

### 客户端设置:

* koreader

1. 打开书籍-进度同步-自定义同步服务器[http://ip:本地端口1](http://ip:本地端口1)
