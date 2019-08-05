群晖nas自用：

感谢以下项目:

https://github.com/aria2/aria2

https://github.com/mayswind/AriaNg

https://github.com/ngosang/trackerslist

版本：

X86_64,修改线程数至128，默认32。集成Trackers自动更新。

Aria2：1.34.0

AriaNg：1.1.2

设置：

卷：

本地文件夹1 映射 /Downloads (Aria2默认下载位置)

本地文件夹2 映射 /config (Aria2配置位置文件)

端口：

本地端口1 映射 6800 （ Aria2 RPC 默认端口 ）

本地端口2 映射 6881 （ BT下载监听端口 ）

本地端口3 映射 6881/udp （ BT下载DTH监听端口 ）

本地端口4 映射 80 （ Aria2NG web访问端口 ）

Aria2NG web访问: IP:本地端口4

环境变量：

RPC_SECRET= （Aria2 RPC token值，默认为空）

SECRETAUTO=YES （添加Aria2NG里RPC连接设置中token值为设置的默认值,默认开启此功能）

TRACKERSAUTO=YES （自动更新Aria2的trackers,默认开启此功能）

TZ=Asia/Shanghai （系统时区设置,默认为Asia/Shanghai ）
