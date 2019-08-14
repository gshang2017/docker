群晖nas自用。

感谢以下项目:

https://gitlab.com/gothfox/tt-rss

版本：

tt-rss：19.8 (amd64)

设置：

卷：

本地文件夹1 映射 /config ( tt-rsst配置文件位置，初次配置时config.php会生成在容器内部，重启一次会自动移到本地映射的文件夹 )

端口：

本地端口1 映射 80 （ tt-rss服务器web端口 ）

访问教程: IP:本地端口1 ( 默认用户名:admin 默认密码:password )

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

其它：

详见：https://tt-rss.org/
