群晖nas自用：

感谢以下项目:

https://github.com/kovidgoyal/calibre

版本：3.39.1

设置：

卷：

本地文件夹1 映射 /library (calibre-server书库默认位置)

本地文件夹2 映射 /config (calibre-server配置位置文件)

端口：

本地端口1 映射 8080（ calibre-server web访问端口 ）

calibre-server web访问: IP:本地端口1

环境变量：

USER= （ calibre-server 用户名 ）

PASSWORD= （ calibre-server 用户密码 ）

WEBLANGUAGE=zh_CN （ calibre-server web界面语言，默认中文）

其它语言:

ALLLANGUAGE=("af" "am" "ar" "ast" "az" "be" "bg" "bn" "bn_BD" "bn_IN" "br" "bs" "ca" "crh" "cs" "cy" "da" "de" "el" "en_AU" "en_CA" "en_GB" "eo" "es" "es_MX" "et" "eu" "fa" "fi" "fil" "fo" "fr" "fr_CA" "fur" "ga" "gl" "gu" "he" "hi" "hr" "hu" "hy" "id" "is" "it" "ja" "jv" "ka" "km" "kn" "ko" "ku" "lt" "ltg" "lv" "mi" "mk" "ml" "mn" "mr" "ms" "mt" "my" "nb" "nds" "nl" "nn" "nso" "oc" "or" "pa" "pl" "ps" "pt" "pt_BR" "ro" "ru" "rw" "sc" "si" "sk" "sl" "sq" "sr" "sr@latin" "sv" "ta" "te" "th" "ti" "tr" "tt" "ug" "uk" "ur" "uz@Latn" "ve" "vi" "wa" "xh" "yi" "zh_CN" "zh_HK" "zh_TW" "zu")

ebook-convert转换其它格式到PDF时需要语言字体，不然转换后只有英文。

PDF字体设置：

复制字体到 config\calibre-server\calibrefonts （本地文件夹2\calibre-server\calibrefonts），重启docker。 例如：将simsun.ttc 复制字体到 config\calibre-server\calibrefonts ，中文转换正常。
