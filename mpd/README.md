## 群晖nas自用：

### GitHub:

[https://github.com/gshang2017/docker](https://github.com/gshang2017/docker)

### 感谢以下项目:

[https://github.com/jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui)     
[https://github.com/MusicPlayerDaemon/MPD](https://github.com/MusicPlayerDaemon/MPD)  
[https://github.com/jcorporation/myMPD](https://github.com/jcorporation/myMPD)             
[https://github.com/eonpatapon/mpDris2](https://github.com/eonpatapon/mpDris2)

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|mpd|0.24.4|amd64;arm64v8;arm32v7,集成蓝牙(bluetooth)。|
|myMPD|22.0.2|mpd的web管理界面|

#### 注意：

* 需关闭系统上蓝牙服务(ubuntu: sudo systemctl stop bluetooth && sudo systemctl disable bluetooth),重启系统。恢复系统上蓝牙服务(ubuntu: sudo systemctl enable bluetooth)。
* 默认配置倍速播放功能，可用Android远程控制服务端连蓝牙播放，可自动切换输出设备（需开启ENABLE_MPC_IDLE）。
* 群晖DSM7以后去除了蓝牙功能，需手动添加。安装[synology-bluetooth](https://github.com/kcsoft/synology-bluetooth)，apollolake可以参考[dsm-bluetooth](https://github.com/gshang2017/dsm-bluetooth)

### docker命令行设置：

1. 下载镜像

    |镜像源|命令|
    |:-|:-|
    |DockerHub|docker pull johngong/mpd:latest|
    |GitHub|docker pull ghcr.io/gshang2017/mpd:latest|

2. 创建mpd容器

        docker create \
           --name=mpd \
           --net=host \
           --cap-add=NET_ADMIN \
           --device /dev/bus/usb \
           -e USER_ID=1000 \
           -e GROUP_ID=1000 \
           -e WEB_LISTENING_PORT=5800 \
           -e VNC_LISTENING_PORT=5900 \
           -e MPD_PORT=6600 \
           -e MYMPD_HTTP_PORT=80 \
           -e LC_ALL=C \
           -e NOVNC_LANGUAGE=en \
           -e ENABLE_MPC_IDLE=true \
           -v /配置文件位置:/config \
           -v /音乐文件夹:/config/music \
           -v /配置文件位置/bluetooth:/var/lib/bluetooth \
           --restart unless-stopped \
           johngong/mpd:latest

3. 运行

       docker start mpd

4. 停止

       docker stop mpd

5. 删除容器

       docker rm mpd

6. 删除镜像

       docker image rm johngong/mpd:latest

### docker-compose：

       参考或下载docker-compose.yml

### 变量:

|参数|说明|
|:-|:-|
| `--name=mpd` |容器名|
| `--net=host` |bluetooth需要host网络|
| `--cap-add=NET_ADMIN`|bluetooth需要NET_ADMIN权限|
| `--device /dev/bus/usb` |bluetooth设备|
| `-v /配置文件位置:/config` |mpd配置文件位置|
| `-v /音乐文件夹:/config/music` |音乐文件位置|
| `-v /配置文件位置/bluetooth:/var/lib/bluetooth` |蓝牙配对信息存储位置|
| `-e USER_ID=1000` |uid设置,默认为1000|
| `-e GROUP_ID=1000` |gid设置,默认为1000|
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `-e HOME=/config` |mpd配置文件位置|
| `-e WEB_AUDIO=1` |支持web音频,需用到pulse服务，必须开启|
| `-e WEB_LISTENING_PORT=5800` |blueman Web界面访问端口,[ip:5800](ip:5800)|
| `-e VNC_LISTENING_PORT=5900` |blueman VNC协议访问端口.如果未使用VNC客户端,则为可选,[ip:5900](ip:5900)|
| `-e MPD_PORT=6600` |mpd监听端口|
| `-e ENABLE_MYMPD=true` |(true\|false)开启mympd,默认开启|
| `-e MYMPD_HTTP=true` |(true\|false)开启mympd的http访问,默认开启|
| `-e MYMPD_HTTP_PORT=80` |mympd的http访问端口,默认80|
| `-e MYMPD_SSL=false` |(true\|false)开启mympd的ssl访问,默认关闭|
| `-e MYMPD_SSL_PORT=443` |mympd的ssl访问端口,默认443|
| `-e ENABLE_MPC_IDLE=true` |(true\|false)开启mpd(output输出设备仅有一个)进程,默认开启|
| `-e BLUETOOTHD_OPTION=` |bluez选项(例如 --plugin=a2dp,avrcp)|
| `-e ENABLE_FIX_OPENBOX_DECOR=false` |(true\|false)关闭窗口最大化,默认关闭|
| `-e VNC_PASSWORD=password` |VNC密码|
| `-e LC_ALL=C` |blueman界面语言设置,默认为英语,(中文需设置为zh_CN.UTF-8)|
| `-e NOVNC_LANGUAGE=en` |(zh_Hans\|en)设定novnc语言,默认为英文,中文需设置为zh_Hans|
| `-e BLUEMAN_LOGLEVEL=error` |blueman日志等级,默认为error|

更多参数设置详见:[https://github.com/jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui)

### 群晖docker设置：

#### 注意：

* 因需要使用usb设备，需要用命令行或docker-compose创建容器。

1. 卷

|参数|说明|
|:-|:-|
| `/本地文件夹1:/config` |mpd配置文件位置|
| `/本地文件夹2:/config/music` |音乐文件位置|
| `/本地文件夹1/bluetooth:/var/lib/bluetooth` |蓝牙配对信息存储位置|

2. 环境变量：

|参数|说明|
|:-|:-|
| `USER_ID=1000` |uid设置,默认为1000|
| `GROUP_ID=1000` |gid设置,默认为1000|
| `TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `HOME=/config` |mpd配置文件位置|
| `WEB_AUDIO=1` |支持web音频,需用到pulse服务，必须开启|
| `WEB_LISTENING_PORT=5800` |blueman Web界面访问端口,[ip:5800](ip:5800)|
| `VNC_LISTENING_PORT=5900` |blueman VNC协议访问端口.如果未使用VNC客户端,则为可选,[ip:5900](ip:5900)|
| `MPD_PORT=6600` |mpd监听端口|
| `ENABLE_MYMPD=true` |(true\|false)开启mympd,默认开启|
| `MYMPD_HTTP=true` |(true\|false)开启mympd的http访问,默认开启|
| `MYMPD_HTTP_PORT=80` |mympd的http访问端口,默认80|
| `MYMPD_SSL=false` |(true\|false)开启mympd的ssl访问,默认关闭|
| `MYMPD_SSL_PORT=443` |mympd的ssl访问端口,默认443|
| `ENABLE_MPC_IDLE=true` |(true\|false)开启mpd(output输出设备仅有一个)进程,默认开启|
| `BLUETOOTHD_OPTION=` |bluez选项(例如 --plugin=a2dp,avrcp)|
| `ENABLE_FIX_OPENBOX_DECOR=false` |(true\|false)关闭窗口最大化,默认关闭|
| `VNC_PASSWORD=password` |VNC密码|
| `LC_ALL=C` |blueman界面语言设置,默认为英语,(中文需设置为zh_CN.UTF-8)|
| `NOVNC_LANGUAGE=en` |(zh_Hans\|en)设定novnc语言,默认为英文,中文需设置为zh_Hans|
| `BLUEMAN_LOGLEVEL=error` |blueman日志等级,默认为error|

### 常见问题:

* 蓝牙：

|问题|解决方法|
|:-|:-|
|群晖里docker能识别蓝牙，但无法正常工作|此蓝牙无驱动，需要手动安装驱动或者用vmm安装虚拟机在里面激活|

### 远程控制软件：

|平台|软件|
|:-|:-|
|android|[MPDroid](https://github.com/abarisain/dmix)(中文需自行编译或者[下载](https://github.com/gshang2017/dmix))|
|android|[avnc](https://github.com/gujjwal00/avnc)|
