## 群晖nas自用

### 感谢以下项目:

[https://hub.docker.com/r/cthulhoo/ttrss-fpm-pgsql-static](https://hub.docker.com/r/cthulhoo/ttrss-fpm-pgsql-static "https://hub.docker.com/r/cthulhoo/ttrss-fpm-pgsql-static")  
[https://github.com/docker-library/postgres](https://github.com/docker-library/postgres "https://github.com/docker-library/postgres")   
[https://github.com/HenryQW/mercury-parser-api](https://github.com/HenryQW/mercury-parser-api "https://github.com/HenryQW/mercury-parser-api")  
[https://github.com/HenryQW/mercury_fulltext](https://github.com/HenryQW/mercury_fulltext "https://github.com/HenryQW/mercury_fulltext")  
[https://github.com/feediron/ttrss_plugin-feediron](https://github.com/feediron/ttrss_plugin-feediron "https://github.com/feediron/ttrss_plugin-feediron")     
[https://github.com/DigitalDJ/tinytinyrss-fever-plugin](https://github.com/DigitalDJ/tinytinyrss-fever-plugin "https://github.com/DigitalDJ/tinytinyrss-fever-plugin")      
[https://github.com/levito/tt-rss-feedly-theme](https://github.com/levito/tt-rss-feedly-theme "https://github.com/levito/tt-rss-feedly-theme")

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|ttrss|plugins-21.05-92c78beb9|amd64;arm64v8;arm32v7,集成postgres数据库(PostgreSQL-12.0),mercury-parser-api及一些常用插件|
|ttrss|plugins-19.8|amd64,集成postgres数据库(PostgreSQL-12beta4),mercury-parser-api及一些常用插件|
|ttrss|19.8|amd64,需自建数据库|

#### 版本升级注意：

* 从21.02开始ttrss不再支持以前配置文件，需用环境变量重新设置，更新前请备份数据并清空tt-rss配置文件夹。
* 从20.09开始ttrss不再支持非80及443端口订阅
* plugins-19.8升级到plugins-20.12需重新导入导出数据库(旧数据库不兼容)，移除配置文件夹themes.local(feedly旧主题不兼容)

### Postgres数据库导入导出

#### 例如：数据库配置为[postgre:/var/lib/postgresql/data]

#### 群晖步骤：

1. 旧版ttrss容器-终端机新增-bash-执行导出命令[完成后postgre里会出现db.sql]

2. 新建新版容器[新版容器配置与旧版一样，将postgre文件夹重命名为其它(例如:postgre.bak)，再新建一个postgre空文件夹。]-启动容器-将导出的db.sql文件复制到新建的postgre文件夹[需新版PostgreSQL初始化完成后才能复制(空文件夹postgre重新有内容)]-终端机新增-bash-执行导入命令

3. 重启容器登录ttrss按提示更新数据库

#### 注意：

* db.sql为导出导入的数据库文件,Postgres数据库不同版本不兼容。导入数据库后全新安装,tt-rss配置界面需选择 Skip initialization。

|标题|命令|举例|
|:-|:-|:-|
|导出|pg_dump -U PostgreSQL用户名 -f /var/lib/postgresql/data/db.sql -d PostgreSQL数据库名称| pg_dump -U ttrss -f /var/lib/postgresql/data/db.sql -d ttrss|
|导入|psql -d PostgreSQL数据库名称 -f /var/lib/postgresql/data/db.sql -U PostgreSQL用户名|psql -d ttrss -f /var/lib/postgresql/data/db.sql -U ttrss|

### docker命令行设置：

1. 下载镜像

|版本|命令|
|:-|:-|
|普通版|docker pull johngong/tt-rss:19.8|
|插件版|docker pull johngong/tt-rss:latest|

2. 创建ttrss容器

* 普通版，需自行搭建数据库，详见后文

        docker create  \
           --name=ttrss  \
           -p 80:80 \
           -v /配置文件位置:/config  \
           --restart unless-stopped  \
           johngong/tt-rss:19.8

* 插件版

        docker create  \
           --name=ttrss  \
           -p 80:80 \
           -p 5432:5432 \
           -p 3000:3000 \
           -v /配置文件位置:/config  \
           -v /PostgreSQL存储数据的位置:/var/lib/postgresql/data  \
           -e POSTGRES_DB=ttrss   \
           -e POSTGRES_USER=ttrss   \
           -e POSTGRES_PASSWORD=ttrss   \
           -e TTRSS_DB_NAME=ttrss   \
           -e TTRSS_DB_USER=ttrss   \
           -e TTRSS_DB_PASS=ttrss   \
           -e TTRSS_SELF_URL_PATH=http://localhost:80/   \
           --restart unless-stopped  \
           johngong/tt-rss:latest

3. 运行

       docker start ttrss

4. 停止

       docker stop ttrss

5. 删除容器

       docker rm  ttrss

6. 删除镜像

       docker image rm  johngong/tt-rss:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=ttrss` |容器名|
| `-p 80:80` |tt-rss服务器web端口 [IP:80](IP:80); 默认用户名:admin,默认密码:password|
| `-p 5432:5432` |PostgreSQL服务器端口|
| `-p 3000:3000` |mercury-parser-api 服务端口|
| ` -v /配置文件位置:/config` |tt-rss配置文件位置，初次配置时config.php会生成在容器内部，重启一次会自动移到本地映射的文件夹|
| `-v /PostgreSQL存储数据的位置:/var/lib/postgresql/data` |PostgreSQL存储数据的位置|
| `-e POSTGRES_DB=ttrss` |PostgreSQL数据库名称 例如:ttrss|
| `-e POSTGRES_USER=ttrss` |PostgreSQL用户名 例如:ttrss|
| `-e POSTGRES_PASSWORD=ttrss` |PostgreSQL密码 例如:ttrss|
| `-e TTRSS_DB_NAME=ttrss` |PostgreSQL数据库名称(POSTGRES_DB) 例如:ttrss|
| `-e TTRSS_DB_USER=ttrss` |PostgreSQL用户名(POSTGRES_USER) 例如:ttrss|
| `-e TTRSS_DB_PASS=ttrss` |PostgreSQL密码(POSTGRES_PASSWORD) 例如:ttrss|
| `-e TTRSS_DB_TYPE=pgsql` |tt-rss使用的数据库类型,默认设置为pgsql，无需更改|
| `-e TTRSS_DB_PORT=5432` |tt-rss使用的数据库端口,默认设置为容器内部端口，无需更改|
| `-e TTRSS_DB_HOST=0.0.0.0` |tt-rss使用的数据库IP,默认设置为容器内部IP，无需更改|
| `-e TTRSS_SELF_URL_PATH=http://localhost:80/` |tt-rss访问地址,需更改为IP或域名加tt-rss服务器web端口|
| `-e TTRSS_PLUGINS=auth_internal,fever,mercury_fulltext` |tt-rss默认开启插件|

### 群晖docker设置：

1. 卷

|参数|说明|
|:-|:-|
| `本地文件夹1:/config` |tt-rss配置文件位置，初次配置时config.php会生成在容器内部，重启一次会自动移到本地映射的文件夹|
| `本地文件夹2:/var/lib/postgresql/data` |PostgreSQL存储数据的位置|

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:80` |tt-rss服务器web端口 [IP:80](IP:80); 默认用户名:admin,默认密码:password|
| `本地端口2:3000` |mercury-parser-api 服务端口|
| `本地端口3:5432` |postgres数据库服务端口|

3. 环境变量：

|参数|说明|
|:-|:-|
| `POSTGRES_DB` |PostgreSQL数据库名称 例如:ttrss|
| `POSTGRES_USER` |PostgreSQL用户名 例如:ttrss|
| `POSTGRES_PASSWORD` |PostgreSQL密码 例如:ttrss|
| `TTRSS_DB_NAME` |PostgreSQL数据库名称(POSTGRES_DB) 例如:ttrss|
| `TTRSS_DB_USER` |PostgreSQL用户名(POSTGRES_USER) 例如:ttrss|
| `TTRSS_DB_PASS` |PostgreSQL密码(POSTGRES_PASSWORD) 例如:ttrss|
| `TTRSS_DB_TYPE=pgsql` |tt-rss使用的数据库类型,默认设置为pgsql，无需更改|
| `TTRSS_DB_PORT=5432` |tt-rss使用的数据库端口,默认设置为容器内部端口，无需更改|
| `TTRSS_DB_HOST=0.0.0.0` |tt-rss使用的数据库IP,默认设置为容器内部IP，无需更改|
| `TTRSS_SELF_URL_PATH=http://localhost:80/` |tt-rss访问地址,需更改为IP或域名加tt-rss服务器web端口|
| `TTRSS_PLUGINS=auth_internal,fever,mercury_fulltext` |tt-rss默认开启插件|

### 插件设置：

* mercury_fulltext：

  1. 偏好设置启用插件
  2. 信息源栏 Mercury Fulltext settings 填入 [ip:本地端口2](ip:本地端口2)

### 中文搜索设置：

* zhparser(用于简体中文全文搜索)：

  1. 偏好设置-信息源-默认语言-Chinese_simplified

#### 注意：

* 升级安装需手动添加zhparser扩展：

|标题|命令|举例|
|:-|:-|:-|
|添加zhparser扩展|psql -U PostgreSQL用户名 -d  PostgreSQL数据库名称 -a -f  /docker-entrypoint-initdb.d/install_extension.sql| psql -U ttrss -d  ttrss -a -f  /docker-entrypoint-initdb.d/install_extension.sql|
|更新旧数据库(可选)|psql -U PostgreSQL用户名 -d  PostgreSQL数据库名称 -c "update ttrss_entries set tsvector_combined = to_tsvector( 'chinese_simplified' , content)"| psql -U ttrss -d  ttrss -c "update ttrss_entries set tsvector_combined = to_tsvector( 'chinese_simplified' , content)"|

### 常见问题:

|问题|解决方法|
|:-|:-|
|群晖域名反代会出现: Please set SELF_URL_PATH to the correct value detected for your server:XXXXXXXXX|config.php 配置文件末尾添加 define('_SKIP_SELF_URL_PATH_CHECKS', true); 即可。[plugins-21.02失效]|

### 客服端软件：

|平台|软件|
|:-|:-|
|android|feedme (免费)|
|linux|NewsFlash(免费),fluent-reader(免费)|
|mac os x|Reeder 4,fluent-reader(免费)|
|windows|fluent-reader(免费)|

###  无插件版数据库搭建：

* tt-rss官方建议使用PostgreSQL

   1. 支持 PostgreSQL 9.1及以上 [https://hub.docker.com/_/postgres/ ](https://hub.docker.com/_/postgres/ )
   2. 支持 mysql 5.6 [https://hub.docker.com/_/mysql/ ](https://hub.docker.com/_/mysql/ )

* 以PostgreSQL配置为例,群晖docker设置：

1. 卷

|参数|说明|
|:-|:-|
| `本地文件夹1:/var/lib/postgresql/data` |PostgreSQL存储数据的位置|

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:5432` |postgres数据库服务端口|

3. 环境变量：

|参数|说明|
|:-|:-|
| `POSTGRES_DB` |PostgreSQL数据库名称 例如:ttrss|
| `POSTGRES_USER` |PostgreSQL用户名 例如:ttrss|
| `POSTGRES_PASSWORD` |PostgreSQL密码 例如:ttrss|

### 其它：

  * 详见：[https://tt-rss.org/](https://tt-rss.org/)
