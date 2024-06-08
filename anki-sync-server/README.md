## 群晖nas自用

### GitHub:

[https://github.com/gshang2017/docker](https://github.com/gshang2017/docker)

### 感谢以下项目:

[https://github.com/dae/anki](https://github.com/dae/anki "https://github.com/dae/anki")    

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|Anki-sync-server|24.06.1|amd64;arm64v8|

### 注意:

* 2.1.65使用anki官方内置同步服务器。
* ankicommunity版设置 https://github.com/gshang2017/docker/blob/0bbdc35f73d535be477fc64f8490ac50e56422b9/anki-sync-server/README.md

### docker命令行设置：

* 变量名变更

    |版本|2.4.0|2.3.0及以前|
    |:-:|:-|:-|
    |1|ANKI_SYNC_SERVER_USER|USER|
    |2|ANKI_SYNC_SERVER_PASSWORD|PASSWORD|

1. 下载镜像

    |镜像源|命令|
    |:-|:-|
    |DockerHub|docker pull johngong/anki-sync-server:latest|
    |GitHub|docker pull ghcr.io/gshang2017/anki-sync-server:latest|

2. 创建anki容器

        docker create \
           --name=anki \
           -p 8080:8080 \
           -v /同步文件位置:/ankisyncdir \
           -e SYNC_USER1=user:pass\
           -e UID=1000 \
           -e GID=1000 \
           --restart unless-stopped \
           johngong/anki-sync-server:latest

3. 运行

       docker start anki

4. 停止

       docker stop anki

5. 删除容器

       docker rm anki

6. 删除镜像

       docker image rm johngong/anki-sync-server:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=anki` |容器名|
| `-p 8080:8080` |anki-sync-server同步端口|
| `-v /同步文件位置:/ankisyncdir` |anki-sync-server同步文件位置|
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `-e SYNC_USER1=user:pass` |anki-sync-server同步服务器用户名及密码，建议用邮箱格式，例如：example@domain.com:password，方便AnkiDroid使用,配置多用户SYNC_USER2，SYNC_USER3|
| `-e SYNC_BASE=/ankisyncdir` |anki-sync-server同步文件位置，默认为/ankisyncdir|
| `-e UID=1000` |uid设置,默认为1000|
| `-e GID=1000` |gid设置,默认为1000|
| `-e SYNC_PORT=8080` |anki-sync-server同步端口,默认8080|
| `-e SYNC_HOST=0.0.0.0` |anki-sync-server同步服务器绑定到的主机，默认0.0.0.0|
| `-e MAX_SYNC_PAYLOAD_MEGS=100` |anki-sync-server同步服务器上传限制设置，默认100(100M大小)|

### 群晖docker设置：

1. 卷

|参数|说明|
|:-|:-|
| `本地文件夹1:/ankisyncdir` |anki-sync-server同步文件位置，默认为/ankisyncdir|

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:8080` |anki-sync-server同步端口|

3. 环境变量

|参数|说明|
|:-|:-|
| `TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `SYNC_USER1=user:pass` |anki-sync-server同步服务器用户名及密码，建议用邮箱格式，例如：example@domain.com:password，方便AnkiDroid使用,配置多用户SYNC_USER2，SYNC_USER3|
| `SYNC_BASE=/ankisyncdir` |anki-sync-server同步文件位置，默认为/ankisyncdir|
| `UID=1000` |uid设置,默认为1000|
| `GID=1000` |gid设置,默认为1000|
| `SYNC_PORT=8080` |anki-sync-server同步端口,默认8080|
| `SYNC_HOST=0.0.0.0` |anki-sync-server同步服务器绑定到的主机，默认0.0.0.0|
| `MAX_SYNC_PAYLOAD_MEGS=100` |anki-sync-server同步服务器上传限制设置，默认100(100M大小)|

### 客户端设置:

##### 注意:

    * AnkiDroid自定义同步服务器需配置https，无法使用ip地址。请设置反向代理。

* AnkiDroid

1. 设置-同步-自定义同步服务器-同步地址 [http://ip:本地端口1](http://ip:本地端口1 "http://ip:本地端口1")
2. 点击同步按钮,输入邮箱格式用户名以及密码

* windows

1. 工具-设置-网络-私人同步服务器 [http://ip:本地端口1](http://ip:本地端口1 "http://ip:本地端口1")
2. 点击同步按钮,输入邮箱格式用户名以及密码

### 设置详见:

[https://github.com/ankitects/anki-manual/blob/main/src/sync-server.md](https://github.com/ankitects/anki-manual/blob/main/src/sync-server.md "https://github.com/ankitects/anki-manual/blob/main/src/sync-server.md")
