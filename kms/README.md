## 群晖nas自用

### 感谢以下项目:

[https://github.com/Wind4/vlmcsd](https://github.com/Wind4/vlmcsd "https://github.com/Wind4/vlmcsd")

### 版本：

    vlmcsd:1112 (amd64)

### docker命令行设置：

1. 下载镜像

       docker pull  johngong/kms:latest


2. 创建 kms容器

        docker create  \
           --name=kms  \
           -p 1688:1688  \
           -p 80:80  \
           --restart unless-stopped  \
          johngong/kms:latest


3. 运行

       docker start  kms

4. 停止

       docker stop  kms

5. 删除容器

       docker rm   kms

6. 删除镜像

       docker image rm   johngong/kms:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=kms` |容器名|
| `-p 1688:1688 ` |kms服务器端口|
| `-p 80:80` |激活教程web访问端口,[ip:80](ip:80)|
| `-e  WEB=YES` |添加教程访问功能，默认开启。如不需要删除值即可|

### 群晖docker设置：

1. 端口

|参数|说明|
|:-|:-|
| `本地端口1:1688` |kms服务器端口|
| `本地端口2:80` |激活教程web访问端口,[ip:本地端口2](ip:本地端口2)|

2. 环境变量

|参数|说明|
|:-|:-|
| `WEB=YES` |添加教程访问功能，默认开启。如不需要删除值即可|


