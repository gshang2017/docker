## 群晖nas自用：

* calibre-web电子书管理集成calibre-server的ebook-convert转换功能

### 感谢以下项目:

[https://github.com/janeczku/calibre-web](https://github.com/janeczku/calibre-web)                                   
[https://github.com/kovidgoyal/calibre](https://github.com/kovidgoyal/calibre)

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|calibre-web|0.6.16|amd64;arm64v8;arm32v7|
|calibre-server|5.10.1|amd64;arm64v8;arm32v7|
|kepubify|4.0.3|amd64;arm64v8;arm32v7|

#### 版本升级注意：

* 0.6.8新增kepubify(Epub转换Kepub)，默认路径/usr/local/bin/kepubify(基本配置-外部二进制)。升级安装需自己设置。
* 新增容器启动时自动添加图书(配置autoaddbooks文件夹，图书添加后会自动删除)。使用此功能请备份图书。
* 容器启动后添加至autoaddbooks文件夹的图书30s后会自动添加至书库，图书添加后会自动删除。使用此功能请备份图书。
* arm32v7版ebook-convert可能无法转换成PDF格式。
* CN版本修改了calibre，支持中文目录(非拼音)。修改了calibre-web的下载函数,支持中文(非拼音)下载。可能有bug，请慎用此版本。替换前请备份书库。
* 未安装0.6.13新增的Google Scholar元数据搜索。
* 豆瓣搜索需自行安装 https://hub.docker.com/r/fugary/simple-boot-douban-api ，并配置环境变量DOUBANIP。

### docker命令行设置：

1. 下载镜像

       docker pull johngong/calibre-web:latest

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
           -e USER=用户名  \
           -e PASSWORD=用户密码 \
           --restart unless-stopped  \
           johngong/calibre-web:latest

3. 运行

       docker start calibre-web

4. 停止

       docker stop calibre-web

5. 删除容器

       docker rm  calibre-web

6. 删除镜像

       docker image rm  johngong/calibre-web:latest

### 变量:

|参数|说明|
|:-|:-|
| `--name=calibre-web` |容器名|
| `-p 8083:8083` |calibre-web web访问端口 [ip:8083](ip:8083),默认用户名: admin 默认密码: admin123|
| `-p 8080:8080` |calibre-server web访问端口 [ip:8080](ip:8080)|
| `-v /配置文件位置:/config` |calibre-web与calibre-server配置位置文件|
| `-v /书库:/library` |calibre-web与calibre-server书库默认位置|
| `-v /自动添加文件夹:/autoaddbooks` |calibre自动添加图书文件夹位置|
| `-e UID=1000` |uid设置,默认为1000|
| `-e GID=1000` |gid设置,默认为1000|
| `-e USER=用户名` |calibre-server 用户名|
| `-e PASSWORD=用户密码` |calibre-server 用户密码|
| `-e WEBLANGUAGE=zh_CN` |calibre-server web界面语言，默认中文|
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `-e CALIBREDB_OTHER_OPTION=` |为自动添加脚本中calibredb命令添加其它参数,例如：duplicates命令[-d]|
| `-e DOUBANIP=` |自定义豆瓣搜索IP,例如 http://IP:8085 |

* 其它语言:

        ALLLANGUAGE=("af" "am" "ar" "ast" "az" "be" "bg" "bn" "bn_BD" "bn_IN" "br" "bs" "ca" "crh" "cs" "cy"
        "da" "de" "el" "en_AU" "en_CA" "en_GB" "eo" "es" "es_MX" "et" "eu" "fa" "fi" "fil" "fo" "fr" "fr_CA"
        "fur" "ga" "gl" "gu" "he" "hi" "hr" "hu" "hy" "id" "is" "it" "ja" "jv" "ka" "km" "kn" "ko" "ku" "lt"
        "ltg" "lv" "mi" "mk" "ml" "mn" "mr" "ms" "mt" "my" "nb" "nds" "nl" "nn" "nso" "oc" "or" "pa" "pl" "ps"
        "pt" "pt_BR" "ro" "ru" "rw" "sc" "si" "sk" "sl" "sq" "sr" "sr@latin" "sv" "ta" "te" "th" "ti" "tr" "tt"
        "ug" "uk" "ur" "uz@Latn" "ve" "vi" "wa" "xh" "yi" "zh_CN" "zh_HK" "zh_TW" "zu")

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
| `本地端口1:8083` |calibre-web web访问端口 [ip:8083](ip:8083),默认用户名: admin 默认密码: admin123|
| `本地端口2:8080` |calibre-server web访问端口 [ip:8080](ip:8080)|

3. 环境变量：

|参数|说明|
|:-|:-|
| `UID=1000` |uid设置,默认为1000|
| `GID=1000` |gid设置,默认为1000|
| `USER=` |calibre-server 用户名|
| `PASSWORD=` |calibre-server 用户密码|
| `WEBLANGUAGE=zh_CN` |calibre-server web界面语言，默认中文|
| `TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `CALIBREDB_OTHER_OPTION=` |为自动添加脚本中calibredb命令添加其它参数,例如：duplicates命令[-d]|
| `DOUBANIP=` |自定义豆瓣搜索IP,例如 http://IP:8085 |

### 其它：

1. calibre-server的用户名和密码需在容器初次配置时或者web界面语言设置为en时才能自动配置。
2. ebook-convert转换配置：管理-配置-基本设置-外部二进制-选择使用calibre的电子书转换器-转换工具路径：/opt/calibre/ebook-convert-提交
3. calibre-web自带上传功能并不好，可开启calibre-server，并用其上传。
4. ebook-convert转换其它格式到PDF时需要语言字体，不然转换后只有英文。

        PDF字体设置：
        复制字体到 config\calibre-server\calibrefonts （本地文件夹2\calibre-server\calibrefonts），重启docker。
        例如：将simsun.ttc 复制字体到 config\calibre-server\calibrefonts ，中文转换正常。
