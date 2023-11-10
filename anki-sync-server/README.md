## 群晖nas自用

### GitHub:

[https://github.com/gshang2017/docker](https://github.com/gshang2017/docker)

### 感谢以下项目:

[https://github.com/dae/anki](https://github.com/dae/anki "https://github.com/dae/anki")    
[https://github.com/ankicommunity/anki-sync-server](https://github.com/ankicommunity/anki-sync-server "https://github.com/ankicommunity/anki-sync-server")

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|Anki-sync-server|23.10.1(official)|amd64;arm64v8|
|Anki-sync-server|2.4.0(ankicommunity)|amd64;arm64v8;arm32v7,支持(Anki:2.1.49、AnkiDroid:2.15.6)|

### 注意:

* 2.1.65使用anki官方内置同步服务器。
* 2.4.0更改了变量名[USER PASSWORD(2.3.0及以前)]，新增arm32v7架构。
* 从2.1.0升级安装ankicommunity版需移除配置文件夹内ankisyncd.conf文件或者修改ankisyncd.conf里端口号为27702。

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

        * official

        docker create \
           --name=anki \
           -p 8080:8080 \
           -v /同步文件位置:/ankisyncdir \
           -e SYNC_USER1=user:pass\
           -e UID=1000 \
           -e GID=1000 \
           --restart unless-stopped \
           johngong/anki-sync-server:latest

        * ankicommunity

        docker create \
           --name=anki \
           -p 27701:27701 \
           -v /配置文件位置:/config \
           -e ANKI_SYNC_SERVER_USER=example@domain.com \
           -e ANKI_SYNC_SERVER_PASSWORD=password \
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

* official

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

* ankicommunity

|参数|说明|
|:-|:-|
| `--name=anki` |容器名|
| `-p 27701:27701` |anki-sync-server同步端口|
| `-v /配置文件位置:/config` |anki-sync-server配置文件位置|
| `-e ANKI_SYNC_SERVER_USER=` |anki-sync-server同步服务器用户名，建议用邮箱格式，例如：example@domain.com，方便AnkiDroid使用|
| `-e ANKI_SYNC_SERVER_PASSWORD=` |anki-sync-server同步服务器密码|
| `-e ENABLE_NGINX_PROXY_SERVER=true` |(true\|false)设置nginx代理，默认开启|
| `-e UID=1000` |uid设置,默认为1000|
| `-e GID=1000` |gid设置,默认为1000|

### 群晖docker设置：

1. 卷

* official

|参数|说明|
|:-|:-|
| `本地文件夹1:/ankisyncdir` |anki-sync-server同步文件位置，默认为/ankisyncdir|

* ankicommunity

|参数|说明|
|:-|:-|
| `本地文件夹1:/config` |anki-sync-server配置文件位置|

2. 端口

* official

|参数|说明|
|:-|:-|
| `本地端口1:8080` |anki-sync-server同步端口|

* ankicommunity

|参数|说明|
|:-|:-|
| `本地端口1:27701` |anki-sync-server同步端口|

3. 环境变量

* official

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

* ankicommunity

|参数|说明|
|:-|:-|
| `ANKI_SYNC_SERVER_USER=` |anki-sync-server同步服务器用户名，建议用邮箱格式，例如：example@domain.com，方便AnkiDroid使用|
| `ANKI_SYNC_SERVER_PASSWORD=` |anki-sync-server同步服务器密码|
| `ENABLE_NGINX_PROXY_SERVER=true` |(true\|false)设置nginx代理，默认开启|
| `UID=1000` |uid设置,默认为1000|
| `GID=1000` |gid设置,默认为1000|

### 客户端设置:

##### 注意:

    * AnkiDroid(2.15.6)自定义同步服务器需配置https，无法使用ip地址。请设置反向代理。

* AnkiDroid(最新)

1. 设置-同步-自定义同步服务器-同步地址 [http://ip:本地端口1](http://ip:本地端口1 "http://ip:本地端口1")
2. 点击同步按钮,输入邮箱格式用户名以及密码

* AnkiDroid(2.15.6)

1. 设置-偏好设置-高级设置-自定义同步服务器-启用 使用自定义同步服务器选项
2. 同步地址:[https://域名:反代端口](https://域名:反代端口 "https://域名:反代端口");例:[https://domain.com:proxyport/](https://domain.com:proxyport/ "https://domain.com:proxyport/")
3. 媒体文件同步地址:[https://域名:反代端口/msync](https://域名:反代端口/msync "https://域名:反代端口/msync");例:[https://domain.com:proxyport/msync](https://domain.com:proxyport/msync "https://domain.com:proxyport/msync")
4. 点击同步按钮,输入邮箱格式用户名以及密码

* windows(最新)

1. 工具-设置-网络-私人同步服务器 [http://ip:本地端口1](http://ip:本地端口1 "http://ip:本地端口1")

* windows(旧)

1. 通过工具-插件-获取插件(358444159)安装或者找到C:\Users\用户名\AppData\Roaming\Anki2\addons21文件夹,在addons21下创建ankisyncd新目录,并创建文件\_\_init\_\_.py,在文件中写入以下代码(需改其中[http://ip:本地端口1/](http://ip:本地端口1/ "http://ip:本地端口1/"))：

    Anki  ≥2.1.28:

       import os
       addr = "http://ip:本地端口1/" # put your server address here
       os.environ["SYNC_ENDPOINT"] = addr + "sync/"
       os.environ["SYNC_ENDPOINT_MEDIA"] = addr + "msync/"

2. 重启Anki
3. 点击同步按钮,输入邮箱格式用户名以及密码

### 设置详见:

[https://github.com/ankicommunity/anki-sync-server/blob/develop/README.md](https://github.com/ankicommunity/anki-sync-server/blob/develop/README.md "https://github.com/ankicommunity/anki-sync-server/blob/develop/README.md")  

[https://github.com/ankitects/anki-manual/blob/main/src/sync-server.md](https://github.com/ankitects/anki-manual/blob/main/src/sync-server.md "https://github.com/ankitects/anki-manual/blob/main/src/sync-server.md")
