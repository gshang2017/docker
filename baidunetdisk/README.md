## 群晖nas自用：

### 感谢以下项目:

[https://github.com/jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui "https://github.com/jlesage/docker-baseimage-gui")                                       

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|baidunetdisk|4.3.0|amd64|

#### 注意：

   * 重启群晖，网盘(baidunetdisk:3.0.1.2)不能登陆：只需要删除配置文件夹下baidunetdiskdata.db(下载进度会保留)，如果网盘设置闪退需删除帐户文件夹下userConf.db，重启docker。

   * 升级 baidunetdisk:3.5.0，下载位置需手动配置(右上角-设置)。

### docker命令行设置：

1. 下载镜像

       docker pull  johngong/baidunetdisk:latest

2. 创建 baidunetdisk容器

        docker create  \
           --name=baidunetdisk  \
           -p 5800:5800  \
           -p 5900:5900  \
           -v /配置文件位置:/config  \
           -v /下载位置:/config/baidunetdiskdownload  \
           --restart unless-stopped  \
           johngong/baidunetdisk:latest

3. 运行

       docker start baidunetdisk

4. 停止

       docker stop baidunetdisk

5. 删除容器

       docker rm  baidunetdisk

6. 删除镜像

       docker image rm johngong/baidunetdisk:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=baidunetdisk` |容器名|
| `-p 5800:5800` |Web界面访问端口,[ip:5800](ip:5800)|
| `-p 5900:5900` |VNC协议访问端口.如果未使用VNC客户端,则为可选,[ip:5900](ip:5900)|
| `-v /配置文件位置:/config` |baidunetdisk配置文件位置|
| `-v /下载位置:/config/baidunetdiskdownload` |baidunetdisk下载路径(3.3.2需手动设置)|
| `-e VNC_PASSWORD=VNC密码` |VNC密码|
| `-e USER_ID=1000` |uid设置,默认为1000|
| `-e GROUP_ID=1000` |gid设置,默认为1000|
| `-e DISPLAY_WIDTH=1100` |显示宽度,默认为1100|
| `-e DISPLAY_HEIGHT=800` |显示高度,默认为800|

更多参数设置详见:[https://registry.hub.docker.com/r/jlesage/baseimage-gui](https://registry.hub.docker.com/r/jlesage/baseimage-gui "https://registry.hub.docker.com/r/jlesage/baseimage-gui")                                     


### 群晖docker设置：

1. 卷

|参数|说明|
|:-|:-|
| `本地文件夹1:/config/baidunetdiskdownload` |baidunetdisk下载路径(3.3.2需手动设置)|
| `本地文件夹2:/config` |baidunetdisk配置文件位置|

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:5800`  |Web界面访问端口,[ip:本地端口1](ip:本地端口1)|
| `本地端口2:5900`  |VNC协议访问端口.如果未使用VNC客户端,则为可选,[ip:本地端口2](ip:本地端口2)|

3. 环境变量

|参数|说明|
|:-|:-|
| `VNC_PASSWORD=VNC密码` |VNC密码|
| `USER_ID=1000` |uid设置,默认为1000|
| `GROUP_ID=1000` |gid设置,默认为1000|
| `DISPLAY_WIDTH=1100` |显示宽度,默认为1100|
| `DISPLAY_HEIGHT=800` |显示高度,默认为800|

### 注意：

1. 剪贴板无法使用中文
