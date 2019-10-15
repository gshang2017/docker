## 群晖nas自用：

### 感谢以下项目:

[https://github.com/aria2/aria2](https://github.com/aria2/aria2)                        
[https://github.com/mayswind/AriaNg](https://github.com/mayswind/AriaNg)             
[https://github.com/ngosang/trackerslist](https://github.com/ngosang/trackerslist)

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|Aria2|1.35.0|X86_64,修改线程数至128，默认32。集成Trackers自动更新。|
|AriaNg|1.1.4|Aria2的web管理界面|

### docker命令行设置：

1. 下载镜像

       docker pull   johngong/aria2:latest

2. 创建aria2容器

        docker create  \
           --name=aria2  \
           -p 6881:6881  \
           -p 6881:6881/udp  \
           -p 6800:6800  \
           -p 80:80  \
           -e RPC_SECRET=不需要可不填 \
           -v /配置文件位置:/config  \
           -v /下载位置:/Downloads  \
           --restart unless-stopped  \
           johngong/aria2:latest


3. 运行

       docker start aria2

4. 停止

       docker stop aria2

5. 删除容器

       docker rm  aria2

6. 删除镜像

       docker image rm  johngong/aria2:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=aria2` |容器名|
| `-p 6881:6881` |BT下载监听端口|
| `-p 6881:6881/udp` |BT下载DHT监听端口
| `-p 80:80 ` | Aria2NG web访问端口 [IP:80](IP:80)|
| `-p 6800:6800` |Aria2 RPC 默认端口|
| `-v /配置文件位置:/config` |Aria2配置文件位置|
| `-v /下载位置:/Downloads` |Aria2默认下载位置|
| `-e RPC_SECRET=` |Aria2 RPC token值，默认为空|
| `-e SECRETAUTO=YES` |添加Aria2NG里RPC连接设置中token值为设置的默认值,默认开启此功能|
| `-e TRACKERSAUTO=YES` |自动更新Aria2的trackers,默认开启此功能|
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|

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
| `本地端口4:80` |Aria2NG web访问端口 [IP:80](IP:80)|

3. 环境变量：

|参数|说明|
|:-|:-|
| `RPC_SECRET=` |Aria2 RPC token值，默认为空|
| `SECRETAUTO=YES` |添加Aria2NG里RPC连接设置中token值为设置的默认值,默认开启此功能|
| `TRACKERSAUTO=YES` |自动更新Aria2的trackers,默认开启此功能|
| `TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai |


