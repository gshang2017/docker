群晖nas自用。

感谢以下项目:

https://gitlab.com/gothfox/tt-rss

https://github.com/docker-library/postgres

https://github.com/HenryQW/mercury-parser-api

https://github.com/HenryQW/mercury_fulltext

https://github.com/feediron/ttrss_plugin-feediron

https://github.com/DigitalDJ/tinytinyrss-fever-plugin

https://github.com/jangernert/FeedReader

https://github.com/levito/tt-rss-feedly-theme

版本：

tt-rss：19.8 (amd64)

Postgres数据库导入导出：db.sql为导出导入的数据库文件

导出  pg_dump  -U  PostgreSQL用户名 -f /var/lib/postgresql/data/db.sql PostgreSQL数据库名称 

例如： pg_dump  -U  ttrss -f /var/lib/postgresql/data/db.sql ttrss 

导入  psql -d PostgreSQL用户名 -f /var/lib/postgresql/data/db.sql PostgreSQL数据库名称 

例如： psql -d ttrss -f /var/lib/postgresql/data/db.sql ttrss

注意：Postgres数据库不同版本不兼容。导入数据库后全新安装,tt-rss配置界面需选择 Skip initialization。

1.无插件版设置：

卷：

本地文件夹1 映射 /config ( tt-rsst配置文件位置，初次配置时config.php会生成在容器内部，重启一次会自动移到本地映射的文件夹 )

端口：

本地端口1 映射 80 （ tt-rss服务器web端口 ）

ttrss web访问: IP:本地端口1 ( 默认用户名:admin 默认密码:password )

群晖域名反代会出现：

Please set SELF_URL_PATH to the correct value detected for your server:XXXXXXXXX

解决方法：

config.php 配置文件末尾添加 define('_SKIP_SELF_URL_PATH_CHECKS', true); 即可。

数据库：

需自己搭建,tt-rss官方建议使用PostgreSQL

支持 PostgreSQL 9.1及以上 ( https://hub.docker.com/_/postgres/ )

支持 mysql 5.6 ( https://hub.docker.com/_/mysql/ )

以PostgreSQL配置为例：

卷：

本地文件夹1 映射 /var/lib/postgresql/data （ PostgreSQL存储数据的位置 ）

环境变量：

自行添加

POSTGRES_DB （ PostgreSQL数据库名称 例如:ttrss ）

POSTGRES_USER （ PostgreSQL用户名 例如:ttrss ）

POSTGRES_PASSWORD （ PostgreSQL密码 例如:ttrss ）

端口：

本地端口1 映射 5432 （ PostgreSQL服务器端口 ）

2.集成数据库(PostgreSQL-12)及插件版设置：

卷：

本地文件夹1 映射 /config ( tt-rsst配置文件位置，初次配置时config.php会生成在容器内部，重启一次会自动移到本地映射的文件夹 )

本地文件夹2 映射 /var/lib/postgresql/data  ( PostgreSQL存储数据的位置 ） 需配置环境变量

端口：

本地端口1 映射 80 （ tt-rss服务器web端口 ）

ttrss web访问: IP:本地端口1 ( 默认用户名:admin 默认密码:password )

本地端口2 映射 3000 （mercury-parser-api 服务端口 ）

本地端口3 映射 5432（ postgres数据库服务端口 ）

群晖域名反代会出现：

Please set SELF_URL_PATH to the correct value detected for your server:XXXXXXXXX

解决方法：

config.php 配置文件末尾添加 define('_SKIP_SELF_URL_PATH_CHECKS', true); 即可。


环境变量：

POSTGRES_DB （ PostgreSQL数据库名称 例如:ttrss ）

POSTGRES_USER （ PostgreSQL用户名 例如:ttrss ）

POSTGRES_PASSWORD （ PostgreSQL密码 例如:ttrss ）

插件设置：

mercury_fulltext：1.偏好设置启用插件 2.信息源栏 Mercury Fulltext settings 填入 ip：本地端口2 （mercury-parser-api 服务端口 ）

api_feedreader：1.启用插件需修改config.php文件添加 api_feedreader；define('PLUGINS', 'auth_internal, note, api_feedreader');        

客服端软件：

android：feedme (免费)

windowns 10 应用商店：Tiny Tiny RSS   (免费)

linux：FeedReader  (免费)

mac os x ：Reeder 4 


其它：

详见：https://tt-rss.org/
