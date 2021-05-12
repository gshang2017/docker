## 群晖nas自用

### 感谢以下项目:

[https://github.com/syncthing](https://github.com/syncthing "https://github.com/syncthing")

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|relaysrv|1.15.0|amd64;arm64v8;arm32v7|
|discosrv|1.8.0|amd64;arm64v8;arm32v7|

### docker命令行设置：

1. 下载镜像

       docker pull  johngong/syncthing-relay-discosrv:latest

2. 创建syncthing-relay-discosrv容器

        docker create  \
           --name=syncthing-relay-discosrv \
           -p 22067:22067 \
           -p 22070:22070  \
           -p 8443:8443  \
           --restart unless-stopped  \
           johngong/syncthing-relay-discosrv:latest

3. 运行

       docker start syncthing-relay-discosrv

4. 停止

       docker stop syncthing-relay-discosrv

5. 删除容器

       docker rm  syncthing-relay-discosrv

6. 删除镜像

       docker image rm  johngong/syncthing-relay-discosrv:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=syncthing-relay-discosrv` |容器名|
| `-p 22067:22067` |同步中继服务器协议监听端口|
| `-p 22070:22070` |同步中继服务器服务状态监听端口|
| `-p 8443:8443` |同步发现服务器监听端口|
| `-v /发现服务器数据库位置:/discosrvdb` |同步发现服务器数据库位置,可不设置|
| `-v /服务器证书位置:/certs` |服务器证书位置,可不设置,设置后证书不变,重装后 device ID不变|
| `-e GLOBAL_RATE=100000000` |全局速率限制 单位为bytes/s|
| `-e PER_SESSION_RATE=10000000` | 每个会话速率限制 单位为bytes/s|
| `-e MESSAGE_TIMEOUT=1m30s` |等待相关消息到达的最长时间|
| `-e NATWORK_TIMEOUT=3m0s` | 客户端和中继服务器之间的操作超时时间|
| `-e PING_INTERVAL=1m30s` | ping的发送频率|
| `-e PROVIDED_BY="strelaysrv"` |中继提供者|
| `-e POOLS=` |中继服务器地址列表,如果不填则为私有中继|
| `-e DISCO_OTHER_OPTION=` |同步发现服务器其它自添加选项,`-debug -http -listen -metrics -listen -replicate -replication-listen`，选项说明详见:[https://docs.syncthing.net/users/stdiscosrv.html](https://docs.syncthing.net/users/stdiscosrv.html "https://docs.syncthing.net/users/stdiscosrv.html")|
| `-e RELAY_OTHER_OPTION=` |同步中继服务器其它自添加选项,`-debug -ext-address -listen -nat -nat-lease -nat-renewal -nat-timeout -protocol -status-srv`，选项说明详见:[https://docs.syncthing.net/users/strelaysrv.html](https://docs.syncthing.net/users/strelaysrv.html "https://docs.syncthing.net/users/strelaysrv.html")|

### 群晖docker设置：

1. 卷

|参数|说明|
|:-|:-|
| `本地文件夹1:/discosrvdb` |同步发现服务器数据库位置,可不设置|
| `本地文件夹2:/certs` |服务器证书位置,可不设置,设置后证书不变,重装后 device ID不变|

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:22067` |同步中继服务器协议监听端口|
| `本地端口2:22070` |同步中继服务器服务状态监听端口|
| `本地端口3:8443` |同步发现服务器监听端口|

3. 环境变量：

|参数|说明|
|:-|:-|
| `GLOBAL_RATE=100000000` |全局速率限制 单位为bytes/s|
| `PER_SESSION_RATE=10000000` | 每个会话速率限制 单位为bytes/s|
| `MESSAGE_TIMEOUT=1m30s` |等待相关消息到达的最长时间|
| `NATWORK_TIMEOUT=3m0s` | 客户端和中继服务器之间的操作超时时间|
| `PING_INTERVAL=1m30s` | ping的发送频率|
| `PROVIDED_BY="strelaysrv"` |中继提供者|
| `POOLS=` |中继服务器地址列表,如果不填则为私有中继|
| `DISCO_OTHER_OPTION=` |同步发现服务器其它自添加选项,`-debug -http -listen -metrics -listen -replicate -replication-listen`，选项说明详见:[https://docs.syncthing.net/users/stdiscosrv.html](https://docs.syncthing.net/users/stdiscosrv.html "https://docs.syncthing.net/users/stdiscosrv.html")|
| `RELAY_OTHER_OPTION=` |同步中继服务器其它自添加选项,`-debug -ext-address -listen -nat -nat-lease -nat-renewal -nat-timeout -protocol -status-srv`，选项说明详见:[https://docs.syncthing.net/users/strelaysrv.html](https://docs.syncthing.net/users/strelaysrv.html "https://docs.syncthing.net/users/strelaysrv.html")|

### 客户端配置：

* deviceID

1. 群晖看docker日志
2. 命令
        docker logs syncthing-relay-discosrv

* 界面- 操作-设置-连接

1. 协议监听地址:[ relay://ip或域名:本地端口1/?id=deviceID]( relay://ip或域名:本地端口1/?id=deviceID " relay://ip或域名:本地端口1/?id=deviceID"),例:[relay://private-relay-1.example.com:22067/?id=ITZRNXE-YNROGBZ-HXTH5P7-VK5NYE5-QHRQGE2-7JQ6VNJ-KZUEDIU-5PPR5AM](relay://private-relay-1.example.com:22067/?id=ITZRNXE-YNROGBZ-HXTH5P7-VK5NYE5-QHRQGE2-7JQ6VNJ-KZUEDIU-5PPR5AM "relay://private-relay-1.example.com:22067/?id=ITZRNXE-YNROGBZ-HXTH5P7-VK5NYE5-QHRQGE2-7JQ6VNJ-KZUEDIU-5PPR5AM")
2. 开启（启用NAT遍历 全球发现[自用可不开启] 本地发现 开启中继）
3. 全球发现服务器:[https://ip或域名:本地端口3/?id=deviceID](https://ip或域名:本地端口3/?id=deviceID "https://ip或域名:本地端口3/?id=deviceID"),例:[https://disco.example.com:8443/?id=ITZRNXE-YNROGBZ-HXTH5P7-VK5NYE5-QHRQGE2-7JQ6VNJ-KZUEDIU-5PPR5AM](https://disco.example.com:8443/?id=ITZRNXE-YNROGBZ-HXTH5P7-VK5NYE5-QHRQGE2-7JQ6VNJ-KZUEDIU-5PPR5AM "https://disco.example.com:8443/?id=ITZRNXE-YNROGBZ-HXTH5P7-VK5NYE5-QHRQGE2-7JQ6VNJ-KZUEDIU-5PPR5AM")

*  界面- 远程设备

1. 具体连接设备-选项-高级-地址列表:[relay://private-relay-1.example.com:22067/?id=ITZRNXE-YNROGBZ-HXTH5P7-VK5NYE5-QHRQGE2-7JQ6VNJ-KZUEDIU-5PPR5AM](relay://private-relay-1.example.com:22067/?id=ITZRNXE-YNROGBZ-HXTH5P7-VK5NYE5-QHRQGE2-7JQ6VNJ-KZUEDIU-5PPR5AM "relay://private-relay-1.example.com:22067/?id=ITZRNXE-YNROGBZ-HXTH5P7-VK5NYE5-QHRQGE2-7JQ6VNJ-KZUEDIU-5PPR5AM")

### 其它：

详见[https://docs.syncthing.net/users/](https://docs.syncthing.net/users/ "https://docs.syncthing.net/users/")
