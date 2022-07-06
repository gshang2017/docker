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
|ttrss|plugins-22.06-b148d2f51|amd64;arm64v8;arm32v7,集成postgres数据库(PostgreSQL-14.1),mercury-parser-api及一些常用插件|

#### 版本升级注意：

* 22.01升级postgres数据库到14.1，并添加自动更新tt-rss及postgres数据库导入导出脚本。
* 从21.02开始ttrss不再支持以前配置文件，需用环境变量重新设置，更新前请备份数据并清空tt-rss配置文件夹。
* 从20.09开始ttrss不再支持非80及443端口订阅。
* plugins-19.8升级新版需重新导入导出数据库(旧数据库不兼容)，移除配置文件夹themes.local(feedly旧主题不兼容)。

### Postgres数据库导入导出

#### 例如：数据库配置为[postgre:/var/lib/postgresql/data]

#### 群晖步骤：

1. 旧版ttrss容器-终端机新增-bash-执行导出命令[完成后config里会出现db.sql]
2. 清空postgre文件夹，预防意外可重命名(例如:postgre.bak)，再新建一个
3. 新建新版容器[配置与旧版一样(需暂时更改环境变量端口[TTRSS_DB_PORT=5432]防止tt-rss对postgre初始化)
4. 启动容器-终端机新增-bash-执行导入命令[需PostgreSQL初始化完成(空文件夹postgre重新有内容)]
5. 更改回环境变量端口[TTRSS_DB_PORT=5432]，重启容器登录ttrss按提示更新数据库

#### 注意：

* db.sql为导出导入的数据库文件,Postgres数据库不同版本不兼容。导入数据库后全新安装,tt-rss配置界面需选择 Skip initialization。

|标题|命令|举例|
|:-|:-|:-|
|导出|pg_dump -U PostgreSQL用户名 -f /config/db.sql -d PostgreSQL数据库名称| pg_dump -U ttrss -f /config/db.sql -d ttrss|
|导入|psql -d PostgreSQL数据库名称 -f /config/db.sql -U PostgreSQL用户名|psql -d ttrss -f /config/db.sql -U ttrss|

### docker命令行设置：

1. 下载镜像

       docker pull johngong/tt-rss:latest

2. 创建ttrss容器

        docker create  \
           --name=ttrss  \
           -p 80:80 \
           -p 5432:5432 \
           -p 3000:3000 \
           -v /配置文件位置:/config  \
           -v /PostgreSQL存储数据的位置:/var/lib/postgresql/data  \
           -e UID=1000  \
           -e GID=1000  \
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

       docker rm ttrss

6. 删除镜像

       docker image rm johngong/tt-rss:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=ttrss` |容器名|
| `-p 80:80` |tt-rss服务器web端口; 默认用户名:admin,默认密码:password|
| `-p 5432:5432` |PostgreSQL服务器端口|
| `-p 3000:3000` |mercury-parser-api 服务端口|
| ` -v /配置文件位置:/config` |tt-rss配置文件位置|
| `-v /PostgreSQL存储数据的位置:/var/lib/postgresql/data` |PostgreSQL存储数据的位置|
| `-e UID=1000` |uid设置,默认为1000,不支持设定为0|
| `-e GID=1000` |gid设置,默认为1000,不支持设定为0|
| `-e POSTGRES_UID` |PostgreSQL的uid设置,默认和UID一样，可单独设定|
| `-e POSTGRES_GID` |PostgreSQL的gid设置,默认和GID一样，可单独设定|
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
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `-e TTRSS_ALLOW_PORTS=80,443` |ttrss可订阅的端口，如需1200，可替换80,443为1200|
| `-e TTRSS_UPDATE_AUTO=true` |自动更新tt-rss(true\|false),默认开启此功能|
| `-e POSTGRES_DB_DUMP=false` |PostgreSQL备份(true\|false)，不能与还原同时使用，仅启动时执行|
| `-e POSTGRES_DB_RESTORE=false` |PostgreSQL还原(true\|false)，不能与备份同时使用，仅启动时执行|

### 群晖docker设置：

1. 卷

|参数|说明|
|:-|:-|
| `本地文件夹1:/config` |tt-rss配置文件位置|
| `本地文件夹2:/var/lib/postgresql/data` |PostgreSQL存储数据的位置|

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:80` |tt-rss服务器web端口; 默认用户名:admin,默认密码:password|
| `本地端口2:3000` |mercury-parser-api 服务端口|
| `本地端口3:5432` |postgres数据库服务端口|

3. 环境变量：

|参数|说明|
|:-|:-|
| `UID=1000` |uid设置,默认为1000,不支持设定为0|
| `GID=1000` |gid设置,默认为1000,不支持设定为0|
| `POSTGRES_UID` |PostgreSQL的uid设置,默认用UID值，可单独设定|
| `POSTGRES_GID` |PostgreSQL的gid设置,默认用GID值，可单独设定|
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
| `TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `TTRSS_ALLOW_PORTS=80,443` |ttrss可订阅的端口，如需1200，可替换80,443为1200|
| `TTRSS_UPDATE_AUTO=true` |自动更新tt-rss(true\|false),默认开启此功能|
| `POSTGRES_DB_DUMP=false` |PostgreSQL备份(true\|false)，不能与还原同时使用，仅启动时执行|
| `POSTGRES_DB_RESTORE=false` |PostgreSQL还原(true\|false)，不能与备份同时使用，仅启动时执行|

### 插件设置：

* mercury_fulltext：

  1. 偏好设置启用插件
  2. 信息源栏 Mercury Fulltext settings 填入 [ip:本地端口2](ip:本地端口2)

### 中文搜索设置：

* zhparser(用于简体中文全文搜索)：

  1. 偏好设置-信息源-默认语言-Chinese_simplified

#### 注意：

* 手动添加zhparser扩展：

|标题|命令|举例|
|:-|:-|:-|
|添加zhparser扩展|psql -U PostgreSQL用户名 -d PostgreSQL数据库名称 -a -f /docker-entrypoint-initdb.d/install_extension.sql| psql -U ttrss -d ttrss -a -f /docker-entrypoint-initdb.d/install_extension.sql|
|更新旧数据库(可选)|psql -U PostgreSQL用户名 -d PostgreSQL数据库名称 -c "update ttrss_entries set tsvector_combined = to_tsvector( 'chinese_simplified' , content)"| psql -U ttrss -d ttrss -c "update ttrss_entries set tsvector_combined = to_tsvector( 'chinese_simplified' , content)"|

### 常见问题:

* https反代：

|问题|解决方法|
|:-|:-|
|Please set SELF_URL_PATH to the correct value detected for your server: http://domain.com (you're using: https://domain.com)|config.php 配置文件里添加 $_SERVER['HTTP_X_FORWARDED_PROTO'] = 'https';|

### 客户端软件：

|平台|软件|
|:-|:-|
|android|feedme (免费)|
|linux|NewsFlash(免费),fluent-reader(免费)|
|mac os x|Reeder 4,fluent-reader(免费)|
|windows|fluent-reader(免费)|

### 其它：

  * 详见：[https://tt-rss.org/](https://tt-rss.org/)
