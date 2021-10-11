## 群晖nas自用。

### 感谢以下项目:

[https://github.com/binux/qiandao](https://github.com/binux/qiandao)

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|qiandao|v_380e25e|amd64;arm64v8;arm32v7|

### docker命令行设置：

1. 下载镜像

       docker pull johngong/qiandao:latest

2. 创建qiandao容器

* 不配置MAIL

        docker create  \
           --name=qiandao  \
           -p 8923:8923 \
           -v /数据库位置:/dbpath  \
           -e UID=1000  \
           -e GID=1000  \
           -e ADMINEMAIL=**@qq.com  \
           --restart unless-stopped  \
           johngong/qiandao:latest

* 配置MAIL

        docker create  \
           --name=qiandao  \
           -p 8923:8923 \
           -v /数据库位置:/dbpath  \
           -e UID=1000  \
           -e GID=1000  \
           -e DOMAIN=域名或ip:端口 \
           -e MAIL_STMP=smtp-mail.outlook.com \
           -e MAIL_PORT=587  \
           -e MAIL_SSL=True  \
           -e MAIL_STARTTLS=True  \
           -e MAIL_USER=**@hotmail.com \
           -e MAIL_PASSWORD=**  \
           -e ADMINEMAIL=**@qq.com  \
           --restart unless-stopped  \
           johngong/qiandao:latest

3. 运行

       docker start qiandao

4. 停止

       docker stop qiandao

5. 删除容器

       docker rm  qiandao

6. 删除镜像

       docker image rm  johngong/qiandao:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=qiandao` |容器名|
| `-p 8923:8923` |qiandao程序web访问端口  [IP:8923](IP:8923)|
| `-v /数据库位置:/dbpath ` |qiandao程序数据库database.db存储位置，设置后重装只要备份database.db即可，数据不会丢失|
| `-e UID=1000` |uid设置,默认为1000|
| `-e GID=1000` |gid设置,默认为1000|
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `-e DOMAIN=` |站点域名，可不设置，设置后可发送验证mail，需同时设置MAIL值，本地可设置为[IP:端口](ip:端口]);例:[192.168.1.111:8923](192.168.1.111:8923)|
| `-e MAIL_STMP=` |邮件smtp地址-可不设置，设置后可发送签到失败提醒mail，需同时设置DOMAIN值|
| `-e MAIL_PORT=` |邮件端口值，ssl端口465 starttls端口587 非ssl端口25|
| `-e MAIL_SSL=` |邮件ssl开关，空值或者MAIL_SSL=True |
| `-e MAIL_STARTTLS=` |邮件starttls开关，空值或者MAIL_STARTTLS=True|
| `-e MAIL_USER=` |邮件账户|
| `-e MAIL_PASSWORD=` |邮件密码|
| `-e MAIL_DOMAIN=` |邮件域名|
| `-e MAILGUN_KEY=` |mailgun key|
| `-e ADMINEMAIL=` |设置管理员账户，第一次不会生效，只有注册用户才生效，用管理员账户邮箱注册后重启容器后生效|

### 群晖docker设置：

1. 卷

|参数|说明|
|:-|:-|
| `本地文件夹1:/dbpath` |qiandao程序数据库database.db存储位置，设置后重装只要备份database.db即可，数据不会丢失|

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:8923` |qiandao程序web访问端口 [IP:8923](IP:8923)|

3. 环境变量：

|参数|说明|
|:-|:-|
| `UID=1000` |uid设置,默认为1000|
| `GID=1000` |gid设置,默认为1000|
| `TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `DOMAIN=` |站点域名，可不设置，设置后可发送验证mail，需同时设置MAIL值，本地可设置为[IP:端口](ip:端口]);例:[192.168.1.111:8923](192.168.1.111:8923)|
| `MAIL_STMP=` |邮件smtp地址-可不设置，设置后可发送签到失败提醒mail，需同时设置DOMAIN值|
| `MAIL_PORT=` |邮件端口值，ssl端口465 starttls端口587 非ssl端口25|
| `MAIL_SSL=` |邮件ssl开关，空值或者MAIL_SSL=True |
| `MAIL_STARTTLS=` |邮件starttls开关，空值或者MAIL_STARTTLS=True|
| `MAIL_USER=` |邮件账户|
| `MAIL_PASSWORD=` |邮件密码|
| `MAIL_DOMAIN=` |邮件域名|
| `MAILGUN_KEY=` |mailgun key|
| `ADMINEMAIL=` |设置管理员账户，第一次不会生效，只有注册用户才生效，用管理员账户邮箱注册后重启容器后生效|

* 公开模板：https://qiandao.today/

### MAIL配置说明：

* 原程序并没有MAIL_STARTTLS这项值，只有MAIL_STARTTLS有值时才会开启此mail功能，否则调用原程序mail功能。

1. 以hotmail邮箱配置为例：

       MAIL_STMP=smtp-mail.outlook.com
       MAIL_PORT=587
       MAIL_SSL=True
       MAIL_STARTTLS=True
       MAIL_USER=**@hotmail.com
       MAIL_PASSWORD=**

2. 以qq邮箱配置为例：

       MAIL_STMP=smtp.qq.com
       MAIL_PORT=465
       MAIL_SSL=True
       MAIL_STARTTLS=
       MAIL_USER=**@qq.com
       MAIL_PASSWORD=** （此值需入qq邮箱设置,开启POP3/SMTP服务并生成授权码）

### 其它设置

* 详见[https://github.com/binux/qiandao](https://github.com/binux/qiandao)
