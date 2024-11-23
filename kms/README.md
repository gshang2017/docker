## 群晖nas自用

### GitHub:

[https://github.com/gshang2017/docker](https://github.com/gshang2017/docker)

### 感谢以下项目:

[https://github.com/Wind4/vlmcsd](https://github.com/Wind4/vlmcsd "https://github.com/Wind4/vlmcsd")

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|vlmcsd|1113|amd64;arm64v8;arm32v7|

#### 版本升级注意：

* web访问默认端口更改为8080。

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
           -p 8080:8080 \
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
| `-p 8080:8080` |KMS使用说明web访问端口|
| `-e UID=1000` |uid设置,默认为1000|
| `-e GID=1000` |gid设置,默认为1000|
| `-e KMS_README_WEB=true` |(true\|false)KMS使用说明，默认开启|
| `-e KMS_README_WEB_PORT=8080` |KMS使用说明web访问端口|
| `-e VLMCSD_SERVER_PORT=1688` |kms服务器端口，默认1688|

### 群晖docker设置：

1. 端口

|参数|说明|
|:-|:-|
| `本地端口1:1688` |kms服务器端口|
| `本地端口2:8080` |KMS使用说明web访问端口|

2. 环境变量

|参数|说明|
|:-|:-|
| `UID=1000` |uid设置,默认为1000|
| `GID=1000` |gid设置,默认为1000|
| `KMS_README_WEB=true` |(true\|false)KMS使用说明，默认开启|
| `KMS_README_WEB_PORT=8080` |KMS使用说明web访问端口|
| `VLMCSD_SERVER_PORT=1688` |kms服务器端口，默认1688|
