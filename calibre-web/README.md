## 群晖nas自用：

* calibre-web电子书管理带ebook-convert转换，并集成calibre的calibre-server服务。

### GitHub:

[https://github.com/gshang2017/docker](https://github.com/gshang2017/docker)

### 感谢以下项目:

[https://github.com/janeczku/calibre-web](https://github.com/janeczku/calibre-web)                                   
[https://github.com/kovidgoyal/calibre](https://github.com/kovidgoyal/calibre)

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|calibre-web|0.6.24|amd64;arm64v8;arm32v7|
|calibre-server|7.9.0|amd64;arm64v8;arm32v7|
|kepubify|4.0.4|amd64;arm64v8;arm32v7|

#### 版本升级注意：

* 0.6.22新增(基本配置-功能配置-Embed Metadata to Ebook File on Download)导致calibre-server与calibre-web冲突。如同时使用新增功能与calibre-server需开启环境变量ENABLE_CALIBREDB_URLLIBRARYPATH=true。
* 新版更改了变量名[USER PASSWORD WEBLANGUAGE(0.6.16-5.10.1及以前)]。</br>新增CALIBRE_ASCII_FILENAME=false设定calibre支持中文目录。
* 新增自动添加图书(配置autoaddbooks文件夹，图书添加后会自动删除)。使用此功能请备份图书。
* arm版ebook-convert可能无法转换成PDF格式。
* CN版(旧)修改了calibre，支持中文目录(非拼音)。替换前请备份书库，新版通过环境变量设置此功能。
* 0.6.16及以前未安装新增的Google Scholar元数据搜索。
* 豆瓣搜索 0.6.18及以前:ENABLE_DOUBAN_SEARCH=true 0.6.16及以前:需自行安装 </br>https://hub.docker.com/r/fugary/simple-boot-douban-api ，并配置环境变量DOUBANIP。

### docker命令行设置：

* 变量名变更

    |版本|0.6.16-5.35.0及以后|0.6.16-5.10.1及以前|
    |:-:|:-|:-|
    |1|CALIBRE_SERVER_USER|USER|
    |2|CALIBRE_SERVER_PASSWORD|PASSWORD|
    |3|CALIBRE_SERVER_WEB_LANGUAGE|WEBLANGUAGE|

1. 下载镜像

    |镜像源|命令|
    |:-|:-|
    |DockerHub|docker pull johngong/calibre-web:latest|
    |GitHub|docker pull ghcr.io/gshang2017/calibre-web:latest|

2. 创建calibre-web容器

        docker create  \
           --name=calibre-web  \
           -p 8083:8083  \
           -p 8080:8080  \
           -v /配置文件位置:/config  \
           -v /书库:/library  \
           -v /自动添加文件夹:/autoaddbooks  \
           -e UID=1000  \
           -e GID=1000  \
           -e CALIBRE_SERVER_USER=用户名  \
           -e CALIBRE_SERVER_PASSWORD=用户密码 \
           --restart unless-stopped  \
           johngong/calibre-web:latest

3. 运行

       docker start calibre-web

4. 停止

       docker stop calibre-web

5. 删除容器

       docker rm calibre-web

6. 删除镜像

       docker image rm johngong/calibre-web:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=calibre-web` |容器名|
| `-p 8083:8083` |calibre-web web访问端口,默认用户名: admin 默认密码: admin123|
| `-p 8080:8080` |calibre-server web访问端口|
| `-v /配置文件位置:/config` |calibre-web与calibre-server配置位置文件|
| `-v /书库:/library` |calibre-web与calibre-server书库默认位置|
| `-v /自动添加文件夹:/autoaddbooks` |calibre自动添加图书文件夹位置|
| `-e UID=1000` |uid设置,默认为1000|
| `-e GID=1000` |gid设置,默认为1000|
| `-e ENABLE_CALIBRE_SERVER=false` |(true\|false)设定开启calibre-server，默认关闭|
| `-e ENABLE_CALIBRE_SERVER_OPDS=false` |(true\|false)开启calibre-server的OPDS功能，默认不开启，arm可能不可用|
| `-e ENABLE_CALIBREDB_URLLIBRARYPATH=true` |(true\|false)开启calibre-server与calibre-web共存补丁，默认开启|
| `-e CALIBRE_SERVER_RESTART_AUTO=true` |(true\|false)开启calibre-server定时重启(0点)，默认开启|
| `-e CALIBRE_SERVER_USER=用户名` |calibre-server 用户名|
| `-e CALIBRE_SERVER_PASSWORD=用户密码` |calibre-server 用户密码|
| `-e CALIBRE_SERVER_WEB_LANGUAGE=zh_CN` |calibre-server web界面语言，默认中文，详见calibre-server其它语言|
| `-e CALIBRE_SERVER_PORT=8080` |calibre-server web访问端口，默认8080|
| `-e CALIBRE_PORT=8083` |calibre-web访问端口，默认8083|
| `-e CALIBRE_ASCII_FILENAME=true` |(true\|false)设定false时calibre支持中文目录|
| `-e CALIBRE_WEB_LANGUAGE=zh_Hans_CN` |(zh_Hans_CN\|en)calibre-web初始界面语言，详见calibre-web其它语言|
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `-e CALIBREDB_OTHER_OPTION=` |为自动添加脚本中calibredb命令添加其它参数,例如：duplicates命令[-d]|
| `-e DISABLE_GOOGLE_SEARCH=false` |(true\|false)设定禁用google搜索，默认不开启|
| `-e DISABLE_SCHOLAR_SEARCH=false` |(true\|false)设定禁用scholar搜索，默认不开启|
| `-e ENABLE_CHOWN_LIBRARY=true` |(true\|false)设定修复library文件夹拥有者，默认开启|
| `-e CALIBRE_LOCALHOST=true` |(true\|false)设定从本地主机和本地网络加载封面，默认开启|
| `-e ENABLE_FIX_COVER_COLOR=false` |(true\|false)设定修复封面颜色偏暗，默认关闭|

### 群晖docker设置：

1. 卷

|参数|说明|
|:-|:-|
| `本地文件夹1:/library` |calibre-web与calibre-server书库默认位置|
| `本地文件夹2:/config` |calibre-web与calibre-server配置位置文件|
| `本地文件夹3:/autoaddbooks` |calibre自动添加图书文件夹位置|

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:8083` |calibre-web web访问端口,默认用户名: admin 默认密码: admin123|
| `本地端口2:8080` |calibre-server web访问端口|

3. 环境变量：

|参数|说明|
|:-|:-|
| `UID=1000` |uid设置,默认为1000|
| `GID=1000` |gid设置,默认为1000|
| `ENABLE_CALIBRE_SERVER=false` |(true\|false)设定开启calibre-server，默认关闭|
| `ENABLE_CALIBRE_SERVER_OPDS=false` |(true\|false)开启calibre-server的OPDS功能，默认不开启，arm可能不可用|
| `ENABLE_CALIBREDB_URLLIBRARYPATH=true` |(true\|false)开启calibre-server与calibre-web共存补丁，默认开启|
| `CALIBRE_SERVER_RESTART_AUTO=true` |(true\|false)开启calibre-server定时重启(0点)，默认开启|
| `CALIBRE_SERVER_USER=` |calibre-server 用户名|
| `CALIBRE_SERVER_PASSWORD=` |calibre-server 用户密码|
| `CALIBRE_SERVER_WEB_LANGUAGE=zh_CN` |calibre-server web界面语言，详见calibre-server其它语言|
| `CALIBRE_SERVER_PORT=8080` |calibre-server web访问端口，默认8080|
| `CALIBRE_PORT=8083` |calibre-web访问端口，默认8083|
| `CALIBRE_ASCII_FILENAME=true` |(true\|false)设定false时calibre支持中文目录|
| `CALIBRE_WEB_LANGUAGE=zh_Hans_CN` |(zh_Hans_CN\|en)calibre-web初始界面语言，详见calibre-web其它语言|
| `TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `CALIBREDB_OTHER_OPTION=` |为自动添加脚本中calibredb命令添加其它参数,例如：duplicates命令[-d]|
| `DISABLE_GOOGLE_SEARCH=false` |(true\|false)设定禁用google搜索，默认不开启|
| `DISABLE_SCHOLAR_SEARCH=false` |(true\|false)设定禁用scholar搜索，默认不开启|
| `ENABLE_CHOWN_LIBRARY=true` |(true\|false)设定修复library文件夹拥有者，默认开启|
| `CALIBRE_LOCALHOST=true` |(true\|false)设定从本地主机和本地网络加载封面，默认开启|
| `ENABLE_FIX_COVER_COLOR=false` |(true\|false)设定修复封面颜色偏暗，默认关闭|

#### 其它：

* 配置calibre-server用户名及密码，可用其上传图书。
* ebook-convert转换其它格式到PDF时需要语言字体。

        PDF字体设置：复制字体到文件夹，重启docker。
        旧：/config/calibre-server/calibrefonts（本地文件夹2/calibre-server/calibrefonts）
        新：/config/fonts（本地文件夹2/fonts）

* calibre-web其它语言:

        CALIBRE_WEB_ALL_LANGUAGE=("en" "cs" "de" "el" "es" "fi" "fr" "hu" "it" "ja" "km" "ko" "nl" "pl"
        "pt_BR" "ru" "sv" "tr" "uk" "zh_Hans_CN" "zh_Hant_TW")

* calibre-server其它语言:

        CALIBRE_SERVER_WEB_ALL_LANGUAGE=("en" "af" "am" "ar" "ast" "az" "be" "bg" "bn" "bn_BD" "bn_IN"
        "br" "bs" "ca" "crh" "cs" "cy" "da" "de" "el" "en_AU" "en_CA" "en_GB" "eo" "es" "es_MX" "et"
        "eu" "fa" "fi" "fil" "fo" "fr" "fr_CA" "fur" "ga" "gl" "gu" "he" "hi" "hr" "hu" "hy" "id" "is"
        "it" "ja" "jv" "ka" "km" "kn" "ko" "ku" "lt" "ltg" "lv" "mi" "mk" "ml" "mn" "mr" "ms" "mt" "my"
        "nb" "nds" "nl" "nn" "nso" "oc" "or" "pa" "pl" "ps" "pt" "pt_BR" "ro" "ru" "rw" "sc" "si" "sk"
        "sl" "sq" "sr"
