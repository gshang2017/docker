群晖nas自用：

感谢以下项目:

https://github.com/qbittorrent/qBittorrent

https://github.com/c0re100/qBittorrent-Enhanced-Edition

https://github.com/ngosang/trackerslist

版本：

qBittorrent：4.1.8 (X86_64) 集成Trackers自动更新。

qBittorrent：qee_4.1.7.1 增强版 (X86_64) 集成Trackers自动更新。 




设置：


卷：

本地文件夹1 映射 /Downloads (qBittorrent下载位置)

本地文件夹2 映射 /config (qBittorrent配置文件位置)

qBittorrent-Enhanced-Edition 增强版 需下载对应版本ipfilter.dat放入qBittorrent配置文件夹才能屏蔽离线下载 https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases

端口：

本地端口1 映射 6881 （ BT下载监听端口 ）

本地端口2 映射 6881/udp （ BT下载DTH监听端口 ）

本地端口3 映射 8989 （ qBittorrent web访问端口 ）-此端口需与容器端口保持一致，否则无法访问。如更改需同时要改掉环境变量中的端口值。

qBittorrent web访问: IP:8989

环境变量：

TRACKERSAUTO=YES （自动更新qBittorrent的trackers,默认开启此功能）

TZ=Asia/Shanghai （系统时区设置,默认为Asia/Shanghai ）

WEBUIPORT=8989 （qBittorrent的web访问端口,默认为8989）

搜索：

开启：视图-搜索引擎

说明：

1.自带 http://plugins.qbittorrent.org/ 部分搜索插件

2.全新安装默认只开启官方自带部分和一个中文搜索插件。其它可到 视图-搜索引擎-界面右侧搜索-搜索插件-启动栏(双击)开启

3.一些搜索插件网站需过墙才能用

4.jackett搜索插件需配置jackett.json(位置config/qBittorrent/data/nova3/engines)，插件需配合jackett服务的api_key。可自行搭建docker版jackett(例如linuxserver/jackett)。

其它:

Trackers只有一个工作,新增的Trackers显示还未联系，需在qBittorrent.conf里[Preferences]下增加Advanced\AnnounceToAllTrackers=true。
