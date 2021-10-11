## 群晖nas自用

### 感谢以下项目:

[https://github.com/dae/anki](https://github.com/dae/anki "https://github.com/dae/anki")    
[https://github.com/ankicommunity/anki-sync-server](https://github.com/ankicommunity/anki-sync-server "https://github.com/ankicommunity/anki-sync-server")   
[https://github.com/tsudoko/anki-sync-server](https://github.com/tsudoko/anki-sync-server "https://github.com/tsudoko/anki-sync-server")

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|Anki-sync-server|v_e719131(ankicommunity)|amd64;arm64v8,目前支持的版本范围是Anki:2.1.43、AnkiDroid:2.15.6,其它自测。|
|Anki-sync-server|2.1.0(tsudoko)|amd64;arm64v8;arm32v7,目前支持的版本范围是Anki:2.0.27~2.1.15(2.1.9除外)、AnkiDroid:2.14.6,其它自测。|

### 注意:

* 从2.1.0升级安装ankicommunity版需移除配置文件夹内ankisyncd.conf文件或者修改ankisyncd.conf里端口号为27702。

* 升级安装需移除配置文件夹内auth.db和session.db文件,并暂时重命名collections文件夹内的用户名文件夹。等程序重建auth.db后，即可将collections内重命名后的文件夹改为用户名。

### docker命令行设置：

1. 下载镜像

       docker pull   johngong/anki-sync-server:latest

2. 创建anki容器

        docker create  \
           --name=anki  \
           -p 27701:27701  \
           -v /配置文件位置:/config  \
           -e USER=***  \
           -e PASSWORD=***  \
           -e UID=1000  \
           -e GID=1000  \
           --restart unless-stopped  \
           johngong/anki-sync-server:latest

3. 运行

       docker start anki

4. 停止

       docker stop anki

5. 删除容器

       docker rm  anki

6. 删除镜像

       docker image rm  johngong/anki-sync-server:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=anki` |容器名|
| `-p 27701:27701` |anki-sync-server同步端口(2.1.0),新版为nginx端口|
| `-v /配置文件位置:/config` |anki-sync-server配置位置文件|
| `-e USER=` |anki-sync-server同步服务器用户名，建议用邮箱格式，例如：XXXXXXX@XX.com，不然android无法使用|
| `-e PASSWORD=` |anki-sync-server同步服务器密码|
| `-e UID=1000` |uid设置,默认为1000|
| `-e GID=1000` |gid设置,默认为1000|

### 群晖docker设置：

1. 卷

|参数|说明|
|:-|:-|
| `本地文件夹1:/config` |anki-sync-server配置位置文件|

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:27701` |anki-sync-server同步端口(2.1.0),新版为nginx端口|

3. 环境变量

|参数|说明|
|:-|:-|
| `USER=` |anki-sync-server同步服务器用户名，建议用邮箱格式，例如：XXXXXXX@XX.com，不然android无法使用|
| `PASSWORD=` |anki-sync-server同步服务器密码|
| `UID=1000` |uid设置,默认为1000|
| `GID=1000` |gid设置,默认为1000|

### 客户端设置:

* Android

1. 设置-偏好设置-高级设置-自定义同步服务器-启用 使用自定义同步服务器选项
2. 同步地址:[ip:本地端口1](ip:本地端口1 "ip:本地端口1");例:[http:/192.168.1.xxx:27701/](http:/192.168.1.xxx:27701/ "http:/192.168.1.xxx:27701/")
3. 媒体文件同步地址:[ip:本地端口1/msync](ip:本地端口1/msync "ip:本地端口1/msync");例:[http:/192.168.1.xxx:27701/msync](http:/192.168.1.xxx:27701/msync "http:/192.168.1.xxx:27701/msync")
4. 点击同步按钮,输入邮箱格式用户名以及密码,请忽略AnkiWeb这几个字。

* windows

1. 找到C:\Users\用户名\AppData\Roaming\Anki2\addons21文件夹(具体位置请自己找) 在addons21下创建ankisyncd新目录,并创建文件\_\_init\_\_.py,在文件中写入以下代码(需改其中[http://ip:27701/](http://ip:27701/ "http://ip:27701/"))：

    Anki 2.1:

       import anki.sync
       addr = "http://ip:27701/" # put your server address here
       anki.sync.SYNC_BASE = addr + "%s"

    Anki  ≥2.1.28:

       import os
       addr = "http://ip:27701/" # put your server address here
       os.environ["SYNC_ENDPOINT"] = addr + "sync/"
       os.environ["SYNC_ENDPOINT_MEDIA"] = addr + "msync/"

2. 重启Anki
3. 点击同步按钮,输入邮箱格式用户名以及密码,请忽略AnkiWeb这几个字。

### 设置详见:

[https://github.com/ankicommunity/anki-sync-server/blob/develop/README.md](https://github.com/ankicommunity/anki-sync-server/blob/develop/README.md "https://github.com/ankicommunity/anki-sync-server/blob/develop/README.md")   
[https://github.com/tsudoko/anki-sync-server/blob/master/README.md](https://github.com/tsudoko/anki-sync-server/blob/master/README.md "https://github.com/tsudoko/anki-sync-server/blob/master/README.md")
