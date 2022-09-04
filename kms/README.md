## 群晖nas自用

### GitHub:

[https://github.com/gshang2017/docker](https://github.com/gshang2017/docker)

### 感谢以下项目:

[https://github.com/Wind4/vlmcsd](https://github.com/Wind4/vlmcsd "https://github.com/Wind4/vlmcsd")

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|vlmcsd|1113|amd64;arm64v8;arm32v7|

### docker命令行设置：

* 变量名变更

    |版本|1113|1112|
    |:-:|:-|:-|
    |1|KMS_README_WEB|WEB|

1. 下载镜像

    |镜像源|命令|
    |:-|:-|
    |DockerHub|docker pull johngong/kms:latest|
    |GitHub|docker pull ghcr.io/gshang2017/kms:latest|

2. 创建 kms容器

        docker create \
           --name=kms \
           -p 1688:1688 \
           -p 80:80 \
           --restart unless-stopped \
          johngong/kms:latest

3. 运行

       docker start kms

4. 停止

       docker stop kms

5. 删除容器

       docker rm kms

6. 删除镜像

       docker image rm johngong/kms:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=kms` |容器名|
| `-p 1688:1688 ` |kms服务器端口|
| `-p 80:80` |KMS使用说明web访问端口|
| `-e KMS_README_WEB=true` |(true\|false)KMS使用说明，默认开启|

### 群晖docker设置：

1. 端口

|参数|说明|
|:-|:-|
| `本地端口1:1688` |kms服务器端口|
| `本地端口2:80` |KMS使用说明web访问端口|

2. 环境变量

|参数|说明|
|:-|:-|
| `KMS_README_WEB=true` |(true\|false)KMS使用说明，默认开启|
