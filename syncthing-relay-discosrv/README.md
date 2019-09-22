群晖nas自用。

感谢以下项目:

https://github.com/syncthing

版本：

relaysrv 1.2.2  (amd64)

discosrv 1.2.2  (amd64)

设置：

卷：（可以不设置,设置后证书不变,重装后服务器地址也不会变）

本地文件夹1 映射 /discosrvdb  (同步发现服务器数据库位置)

本地文件夹2 映射 /certs (服务器证书位置)
  
端口：

本地端口1 映射 22067 （同步中继服务器协议监听端口）

本地端口2 映射 22070 （同步中继服务器服务状态监听端口）

本地端口3 映射 8443 （同步发现服务器监听端口）


环境变量：

GLOBAL_RATE=100000000（全局速率限制 单位为bytes/s）

PER_SESSION_RATE=10000000 （每个会话速率限制 单位为bytes/s）

MESSAGE_TIMEOUT=1m30s （等待相关消息到达的最长时间）

NATWORK_TIMEOUT=3m0s  （客户端和中继服务器之间的操作超时时间）

PING_INTERVAL=1m30s （ping的发送频率）

PROVIDED_BY="strelaysrv" （中继提供者）

POOLS="" （中继服务器地址列表,如果不填则为私有中继） 

DISCO_OTHER_OPTION= （同步发现服务器其它自添加选项，-debug|-http|-listen|-metrics-listen|-replicate|-replication-listen，选项说明详见：https://docs.syncthing.net/users/stdiscosrv.html）

RELAY_OTHER_OPTION= （同步中继服务器其它自添加选项，-debug|-ext-address|-listen|-nat|-nat-lease|-nat-renewal|-nat-timeout|-protocol|-status-srv，选项说明详见：https://docs.syncthing.net/users/strelaysrv.html）
           
客户端配置：

device ID 看docker日志

操作-设置-连接

1.协议监听地址 （relay://[ip或域名:本地端口1]/?id=[device ID]）

2.开启（启用NAT遍历 全球发现 本地发现 开启中继）

3.全球发现服务器 （https://[ip或域名:本地端口3]/?id=[device ID]）

远程设备

具体连接设备-选项-高级-地址列表 （relay://[ip或域名:本地端口1]/?id=[device ID]）

其它：

详见：https://docs.syncthing.net/users/










