## 群晖nas自用：

* calibre-web电子书管理集成calibre-server的ebook-convert转换功能

### 感谢以下项目:

[https://github.com/janeczku/calibre-web](https://github.com/janeczku/calibre-web)                                   
[https://github.com/kovidgoyal/calibre](https://github.com/kovidgoyal/calibre)

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|calibre-web|0.6.7|X86_64|
|calibre-server|3.48.0|X86_64|

### docker命令行设置：

1. 下载镜像

       docker pull johngong/calibre-web:latest  [带Limit标签为最少依赖版本]
 
2. 创建calibre-web容器

        docker create  \
           --name=calibre-web  \
           -p 8083:8083  \
           -p 8080:8080  \
           -v /配置文件位置:/config  \
           -v /书库:/library  \
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
| ` -p 8083:8083` |calibre-web web访问端口 [ip:8083](ip:8083),默认用户名: admin 默认密码: admin123|
| `-p 8080:8080` |calibre-server web访问端口 [ip:8080](ip:8080)|
| ` -v /配置文件位置:/config` |calibre-web与calibre-server配置位置文件|
| `-v /书库:/library` |calibre-web与calibre-server书库默认位置|
| `-e USER=用户名` |calibre-server 用户名|
| ` -e PASSWORD=用户密码` |calibre-server 用户密码|
| `-e WEBLANGUAGE=zh_CN` |calibre-server web界面语言，默认中文|

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

2. 端口

|参数|说明|
|:-|:-|
| `本地端口1:8083` |calibre-web web访问端口 [ip:8083](ip:8083),默认用户名: admin 默认密码: admin123|
| `本地端口2:8080` |calibre-server web访问端口 [ip:8080](ip:8080)|

3. 环境变量：

|参数|说明|
|:-|:-|
| `USER=` |calibre-server 用户名|
| `PASSWORD=` |calibre-server 用户密码|
| `WEBLANGUAGE=zh_CN` |calibre-server web界面语言，默认中文|

### 其它：

1. ebook-convert转换配置：管理-配置-基本设置-外部二进制-选择使用calibre的电子书转换器-转换工具路径：/opt/calibre/ebook-convert-提交
2. calibre-web自带上传功能并不好，可开启calibre-server，并用其上传。
3. ebook-convert转换其它格式到PDF时需要语言字体，不然转换后只有英文。

        PDF字体设置：
        复制字体到 config\calibre-server\calibrefonts （本地文件夹2\calibre-server\calibrefonts），重启docker。
        例如：将simsun.ttc 复制字体到 config\calibre-server\calibrefonts ，中文转换正常。
