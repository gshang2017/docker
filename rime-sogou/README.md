## 群晖nas自用：

### 简介

   自动更新sogou网络流行新词 <https://pinyin.sogou.com/dict/detail/index/4> ,生成rime输入法(拼音)使用文件luna_pinyin.sogou.dict.yaml(默认名称)。


### 感谢以下项目:

[https://github.com/studyzy/imewlconverter](https://github.com/studyzy/imewlconverter)   

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|rime-sogou|1.0|amd64;arm64v8|

### docker命令行设置：

1. 下载镜像

        docker pull johngong/rime-sogou:latest

2. 创建qbittorrent容器

        docker create  \
           --name=rime-sogou  \
           -v /dict位置:/output  \
           --restart unless-stopped  \
           johngong/rime-sogou:latest

3. 运行

       docker start rime-sogou

4. 停止

       docker stop rime-sogou

5. 删除容器

       docker rm  rime-sogou

6. 删除镜像

       docker image rm  johngong/rime-sogou:latest

### 变量:

|参数|说明|
|-|:-|
| `--name=rime-sogou` |容器名|
| `-v /dict位置:/output` |生成的sogou网络流行新词位置|
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `-e SOGOU_DICT_NAME=luna_pinyin.sogou` |词库名称,默认为luna_pinyin.sogou|

### 群晖docker设置：

1. 卷

|参数|说明|
|-|:-|
| `本地文件夹1:/output` |生成的sogou网络流行新词位置|

2. 环境变量：

|参数|说明|
|-|:-|
| `TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `SOGOU_DICT_NAME=luna_pinyin.sogou` |词库名称,默认为luna_pinyin.sogou|
