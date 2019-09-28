## 群晖nas自用

### 感谢以下项目:

[https://gitlab.com/gothfox/tt-rss](https://gitlab.com/gothfox/tt-rss "https://gitlab.com/gothfox/tt-rss")               
[https://github.com/docker-library/postgres](https://github.com/docker-library/postgres "https://github.com/docker-library/postgres")    
[https://github.com/HenryQW/mercury-parser-api](https://github.com/HenryQW/mercury-parser-api "https://github.com/HenryQW/mercury-parser-api")     
[https://github.com/HenryQW/mercury_fulltext](https://github.com/HenryQW/mercury_fulltext "https://github.com/HenryQW/mercury_fulltext")     
[https://github.com/feediron/ttrss_plugin-feediron](https://github.com/feediron/ttrss_plugin-feediron "https://github.com/feediron/ttrss_plugin-feediron")     
[https://github.com/DigitalDJ/tinytinyrss-fever-plugin](https://github.com/DigitalDJ/tinytinyrss-fever-plugin "https://github.com/DigitalDJ/tinytinyrss-fever-plugin")      
[https://github.com/jangernert/FeedReader](https://github.com/jangernert/FeedReader "https://github.com/jangernert/FeedReader")       
[https://github.com/levito/tt-rss-feedly-theme](https://github.com/levito/tt-rss-feedly-theme "https://github.com/levito/tt-rss-feedly-theme")

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|ttrss|plugins-19.8|X86_64,集成postgres数据库(PostgreSQL-12),mercury-parser-api及一些常用插件|
|ttrss|19.8|X86_64,需自建数据库|

### Postgres数据库导入导出

#### 注意：

* db.sql为导出导入的数据库文件,Postgres数据库不同版本不兼容。导入数据库后全新安装,tt-rss配置界面需选择 Skip initialization。

|标题|命令|举例|
|:-|:-|:-|
|导出|pg_dump -U PostgreSQL用户名 -f /var/lib/postgresql/data/db.sql PostgreSQL数据库名称| pg_dump -U ttrss -f /var/lib/postgresql/data/db.sql ttrss|
|导入|psql -d PostgreSQL用户名 -f /var/lib/postgresql/data/db.sql PostgreSQL数据库名称|psql -d ttrss -f /var/lib/postgresql/data/db.sql ttrss|

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
           johngong/ttrss:19.8

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
           -e POSTGRES_PASSWORD =ttrss   \
           --restart unless-stopped  \
           johngong/ttrss:latest

3. 运行

       docker start ttrss

4. 停止

       docker stop ttrss

5. 删除容器

       docker rm  ttrss

6. 删除镜像

       docker image rm  johngong/ttrss:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=ttrss` |容器名|
| `-p 80:80` |tt-rss服务器web端口 [IP:80](IP:80); 默认用户名:admin,默认密码:password|
| `-p 5432:5432` |PostgreSQL服务器端口|
| `-p 3000:3000` |mercury-parser-api 服务端口|
| ` -v /配置文件位置:/config` |tt-rss配置文件位置，初次配置时config.php会生成在容器内部，重启一次会自动移到本地映射的文件夹|
| `-v /PostgreSQL存储数据的位置:/var/lib/postgresql/data` |PostgreSQL存储数据的位置|

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

### 插件设置：

* mercury_fulltext：

  1. 偏好设置启用插件 
  2. 信息源栏 Mercury Fulltext settings 填入 [ip:本地端口2](ip:本地端口2)

* api_feedreader：
  1. 启用插件需修改config.php文件添加 api_feedreader；
  define('PLUGINS', 'auth_internal, note, api_feedreader');

### 常见问题:

|问题|解决方法|
|:-|:-|
|群晖域名反代会出现: Please set SELF_URL_PATH to the correct value detected for your server:XXXXXXXXX|config.php 配置文件末尾添加 define('_SKIP_SELF_URL_PATH_CHECKS', true); 即可。|

### 客服端软件：

|平台|软件|
|:-|:-|
|android|feedme (免费)|
|windowns 10 应用商店|Tiny Tiny RSS (免费)|
|linux|FeedReader (免费)|
|mac os x|Reeder 4|


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
