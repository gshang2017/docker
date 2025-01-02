## 群晖nas自用。

### GitHub:

[https://github.com/gshang2017/docker](https://github.com/gshang2017/docker)

### 感谢以下项目:

[https://github.com/qiandao-today/qiandao](https://github.com/qiandao-today/qiandao)

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|qiandao|v_fdcc02d|amd64;arm64v8;arm32v7|

### docker命令行设置：

1. 下载镜像

    |镜像源|命令|
    |:-|:-|
    |DockerHub|docker pull johngong/qiandao:latest|
    |GitHub|docker pull ghcr.io/gshang2017/qiandao:latest|

2. 创建qiandao容器

* 不配置MAIL

        docker create \
           --name=qiandao \
           -p 8923:8923 \
           -v /数据库位置:/config \
           -e UID=1000 \
           -e GID=1000 \
           --restart unless-stopped \
           johngong/qiandao:latest

* 配置MAIL

        docker create \
           --name=qiandao \
           -p 8923:8923 \
           -v /数据库位置:/config \
           -e UID=1000 \
           -e GID=1000 \
           -e DOMAIN=域名或ip:端口 \
           -e MAIL_SMTP=smtp.qq.com \
           -e MAIL_PORT=465 \
           -e MAIL_SSL=True \
           -e MAIL_USER=**@qq.com \
           -e MAIL_PASSWORD=** \
           --restart unless-stopped \
           johngong/qiandao:latest

3. 运行

       docker start qiandao

4. 停止

       docker stop qiandao

5. 删除容器

       docker rm qiandao

6. 删除镜像

       docker image rm johngong/qiandao:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=qiandao` |容器名|
| `-p 8923:8923` |web访问端口|
| `-v /数据库位置:/config ` |数据库database.db存储位置(旧版为/dbpath)|
| `-e UID=1000` |uid设置,默认为1000|
| `-e GID=1000` |gid设置,默认为1000|
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `-e DOMAIN=` |站点域名，可不设置，设置后可发送验证mail，需同时设置MAIL值，本地可设置为[IP:端口](ip:端口]);例:[192.168.1.111:8923](192.168.1.111:8923)|
| `-e MAIL_SMTP=` |邮件smtp地址，可不设置，设置后可发送签到失败提醒mail，需同时设置DOMAIN值|
| `-e MAIL_PORT=` |邮件端口值，ssl端口465 starttls端口587 非ssl端口25|
| `-e MAIL_SSL=True` |邮件ssl开关，(True\|False),默认开启此功能|
| `-e MAIL_STARTTLS=False` |邮件starttls开关，(True\|False),默认关闭此功能|
| `-e MAIL_USER=` |邮件账户|
| `-e MAIL_PASSWORD=` |邮件密码|
| `-e MAIL_FROM=` |发送时使用的邮箱，默认与MAIL_USER相同|
| `-e MAIL_DOMAIN=` |邮件域名|
| `-e ADMIN_MAIL=` |设置管理员账户，可不设置，系统默认第一个注册用户为管理员|
| `-e QIANDAO_UPDATE_AUTO=true` |自动更新qiandao(true\|false),默认开启此功能|

### 群晖docker设置：

1. 卷

|参数|说明|
|:-|:-|
| `本地文件夹1:/config` |数据库database.db存储位置(旧版为/dbpath)|

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:8923` |web访问端口|

3. 环境变量：

|参数|说明|
|:-|:-|
| `UID=1000` |uid设置,默认为1000|
| `GID=1000` |gid设置,默认为1000|
| `TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `DOMAIN=` |站点域名，可不设置，设置后可发送验证mail，需同时设置MAIL值，本地可设置为[IP:端口](ip:端口]);例:[192.168.1.111:8923](192.168.1.111:8923)|
| `MAIL_SMTP=` |邮件smtp地址，可不设置，设置后可发送签到失败提醒mail，需同时设置DOMAIN值|
| `MAIL_PORT=` |邮件端口值，ssl端口465 starttls端口587 非ssl端口25|
| `MAIL_SSL=True` |邮件ssl开关，(True\|False),默认开启此功能|
| `MAIL_STARTTLS=False` |邮件starttls开关，(True\|False),默认关闭此功能|
| `MAIL_USER=` |邮件账户|
| `MAIL_PASSWORD=` |邮件密码|
| `MAIL_FROM=` |发送时使用的邮箱，默认与MAIL_USER相同|
| `MAIL_DOMAIN=` |邮件域名|
| `ADMIN_MAIL=` |设置管理员账户，可不设置，系统默认第一个注册用户为管理员|
| `QIANDAO_UPDATE_AUTO=false` |自动更新qiandao(true\|false),默认关闭此功能|

* 公开模板：

1. https://qiandao.today/tpls/public
2. https://github.com/qd-today/templates

### MAIL配置说明：

1. 以hotmail邮箱配置为例：

       MAIL_SMTP=smtp-mail.outlook.com
       MAIL_PORT=587
       MAIL_STARTTLS=True
       MAIL_USER=**@hotmail.com
       MAIL_PASSWORD=**

2. 以qq邮箱配置为例：

       MAIL_SMTP=smtp.qq.com
       MAIL_PORT=465       
       MAIL_SSL=True
       MAIL_STARTTLS=False
       MAIL_USER=**@qq.com
       MAIL_PASSWORD=** （此值需入qq邮箱设置,开启POP3/SMTP服务并生成授权码）

### 其它设置

* 详见[https://github.com/qd-today/qd](https://github.com/qd-today/qd)
