## 群晖nas自用：

### 感谢以下项目:

[https://github.com/iikira/BaiduPCS-Go](https://github.com/iikira/BaiduPCS-Go "https://github.com/iikira/BaiduPCS-Go")                                       
[https://github.com/liuzhuoling2011/baidupcs-web](https://github.com/liuzhuoling2011/baidupcs-web "https://github.com/liuzhuoling2011/baidupcs-web")


### 版本：

    baidupcs-web：3.7.0 (amd64)

### docker命令行设置：

1. 下载镜像

       docker pull   johngong/baidupcs-web:latest


2. 创建 baidupcs容器

        docker create  \
           --name=baidupcs  \
           -p 5299:5299  \
           -v /配置文件位置:/config  \
           -v /下载位置:/root/Downloads  \
           --restart unless-stopped  \
           johngong/baidupcs-web:latest


3. 运行

       docker start baidupcs

4. 停止

       docker stop baidupcs

5. 删除容器

       docker rm  baidupcs

6. 删除镜像

       docker image rm johngong/baidupcs-web:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=baidupcs` |容器名|
| `-p 5299:5299` |BaiduPCS-Go web访问端口,[ip:5299](ip:5299)|
| `-v /配置文件位置:/config` |BaiduPCS-Go配置文件位置|
| `-v /下载位置:/root/Downloads ` |BaiduPCS-Go默认下载路径|

### 群晖docker设置：

1. 卷

|参数|说明|
|:-|:-|
| `本地文件夹1: /root/Downloads` |BaiduPCS-Go默认下载路径|
| `本地文件夹2:/config` |BaiduPCS-Go配置文件位置|

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:5299` |BaiduPCS-Go web访问端口,[ip:本地端口1](ip:本地端口1)|

