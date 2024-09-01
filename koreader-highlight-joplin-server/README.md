## 群晖nas自用

### GitHub:

[https://github.com/gshang2017/docker](https://github.com/gshang2017/docker)

### 感谢以下项目:

[https://github.com/koreader/koreader](https://github.com/koreader/koreader "https://github.com/koreader/koreader")                 
[https://github.com/laurent22/joplin](https://github.com/laurent22/joplin "https://github.com/laurent22/joplin")  

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|koreader-highlight-joplin-server|3.0.1|amd64;arm64v8|

#### 同步说明：

* 导出标注1分钟后自动同步。

### docker命令行设置：

1. 下载镜像

    |镜像源|命令|
    |:-|:-|
    |DockerHub|docker pull johngong/koreader-highlight-joplin-server:latest|
    |GitHub|docker pull ghcr.io/gshang2017/koreader-highlight-joplin-server:latest|

2. 创建anki容器

        docker create \
           --name=koreader-highlight-joplin-server \
           -p 41185:41185 \
           -v /配置文件位置:/config \
           -e UID=1000 \
           -e GID=1000 \
           -e JOPLIN_SYNC_PATH=joplin同步服务器地址 \
           -e JOPLIN_SYNC_USERNAME=joplin用户名 \
           -e JOPLIN_SYNC_PASSWORD=joplin密码 \           
           --restart unless-stopped \
           johngong/koreader-highlight-joplin-server:latest

3. 运行

       docker start koreader-highlight-joplin-server

4. 停止

       docker stop koreader-highlight-joplin-server

5. 删除容器

       docker rm koreader-highlight-joplin-server

6. 删除镜像

       docker image rm johngong/koreader-highlight-joplin-server:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=koreader-highlight-joplin-server` |容器名|
| `-p 41185:41185` |koreader-highlight-joplin-server监听端口|
| `-v /同步文件位置:/config` |koreader-highlight-joplin-server配置文件位置|
| `-e UID=1000` |uid设置,默认为1000|
| `-e GID=1000` |gid设置,默认为1000|
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `-e JOPLIN_SYNC_PATH=` |joplin同步服务器地址|
| `-e JOPLIN_SYNC_USERNAME=` |joplin用户名|
| `-e JOPLIN_SYNC_PASSWORD=` |joplin密码|
| `-e HOME=/config` |用户主目录|
| `-e SOCAT_TCP_LISTEN_PORT=41185` |koreader-highlight-joplin-server监听端口|

### 群晖docker设置：

1. 卷

|参数|说明|
|:-|:-|
| `/同步文件位置:/config` |koreader-highlight-joplin-server配置文件位置|

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:41185` |koreader-highlight-joplin-server监听端口|

3. 环境变量

|参数|说明|
|:-|:-|
| `UID=1000` |uid设置,默认为1000|
| `GID=1000` |gid设置,默认为1000|
| `TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `JOPLIN_SYNC_PATH=` |joplin同步服务器地址|
| `JOPLIN_SYNC_USERNAME=` |joplin用户名|
| `JOPLIN_SYNC_PASSWORD=` |joplin密码|
| `HOME=/config` |用户主目录|
| `SOCAT_TCP_LISTEN_PORT=41185` |koreader-highlight-joplin-server监听端口|

### 客户端设置:

* koreader

1. 导出标注-选择格式与服务-Joplin
2. 设置Joplin的IP和端口 [http://ip:本地端口1](http://ip:本地端口1 "http://ip:本地端口1")
3. 设置认证信息(/config/.config/joplin/settings.json里api.token或者/config/token.txt)

### 详见:

[https://github.com/koreader/koreader/wiki/Joplin](https://github.com/koreader/koreader/wiki/Joplin "https://github.com/koreader/koreader/wiki/Joplin")
