## 群晖nas自用：

### 简介

* 自动更新sogou网络流行新词 <https://pinyin.sogou.com/dict/detail/index/4> ,生成rime输入法(拼音)使用文件luna_pinyin_simp.sogou_pop.dict.yaml(默认名称)。
* 自动更新带词频(腾讯AI向量词库逆序)rime词库(包含英语，基础，维基，搜狗等词库) <https://github.com/gshang2017/rime-dict> ,生成rime输入法(拼音)使用文件。

### GitHub:

   [https://github.com/gshang2017/docker](https://github.com/gshang2017/docker)      
   [https://github.com/gshang2017/rime-dict](https://github.com/gshang2017/rime-dict)

### 感谢以下项目:

[https://github.com/studyzy/imewlconverter](https://github.com/studyzy/imewlconverter)   

### 版本：

|名称|版本|说明|
|:-|:-|:-|
|rime-sogou|2.2|amd64;arm64v8;arm32v7|

### docker命令行设置：

1. 下载镜像

    |镜像源|命令|
    |:-|:-|
    |DockerHub|docker pull johngong/rime-sogou:latest|
    |GitHub|docker pull ghcr.io/gshang2017/rime-sogou:latest|

2. 创建rime-sogou容器

        docker create  \
           --name=rime-sogou  \
           -v /dict位置:/output  \
           -v /rime词库版本存储位置:/config  \
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
| `-v /dict位置:/output` |生成新词位置|
| `-v /rime词库版本存储位置:/config` |rime词库版本存储位置|
| `-e TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `-e SOGOU_SCEL_UPDATE_AUTO=true` |(true\|false)自动更新搜狗流行词库,默认开启|
| `-e RIME_DICT_UPDATE_AUTO=true` |(true\|false)自动更新rime词库,默认开启|
| `-e SOGOU_DICT_NAME=luna_pinyin_simp.sogou_pop` |词库名称,默认为luna_pinyin_simp.sogou_pop|
| `-e RIME_FREQ=2000001` |词库词频,默认为2000001|
| `-e ENGLISH_DICT_SET=True` |英语词库|
| `-e BASIC_DICT_SET=True` |基础词库|
| `-e WIKI_DICT_SET` |维基词库|
| `-e LETTERED_WORD_DICT_SET` |字母词词库|
| `-e CHAIZI_DICT_SET` |拆字词库|
| `-e SOGOU_TOTAL_OFFICIAL_DICT_SET=True` |搜狗官方推荐所有类别词库|
| `-e SOGOU_TOTAL_UNOFFICIAL_DICT_SET=True` |搜狗非官方推荐所有类别词库(需开启自用词库)|
| `-e SOGOU_UNOFFICIAL_DICT_SET=True` |非搜狗官方推荐词库|
| `-e SOGOU_SINGLE_FILE=True` |合并非搜狗官方推荐词库|
| `-e ORDER=True` |对合并的非搜狗官方推荐词库排序|
| `-e DEDUPLICATION=True` |对合并的非搜狗官方推荐词库去重|
| `-e LEN_NUM=0` |搜狗词库限制长度|
| `-e RIME_OPENCC=False` |opencc设定|
| `-e RIME_OPENCC_CONFIG=s2t.json` |opencc配置设定|
| `-e PREFIX_DICT_NAME=luna_pinyin_simp.` |词库前缀|
| `-e SOGOU_ENGINEERING_APPLICATION=True` |非搜狗官方推荐工程应用词库|
| `-e SOGOU_AGRICULTURE_AND_FISHING_LIVESTOCK=True` |非搜狗官方推荐农业渔畜词库|
| `-e SOGOU_SOCIAL_SCIENCES=True` |非搜狗官方推荐社会科学词库|
| `-e SOGOU_NATURAL_SCIENCE=True` |非搜狗官方推荐自然科学词库|
| `-e SOGOU_CITY_INFORMATION=True` |非搜狗官方推荐城市信息词库|
| `-e SOGOU_ENTERTAINMENT_AND_LEISURE=True` |非搜狗官方推荐娱乐休闲词库|
| `-e SOGOU_HUMANITIES=True` |非搜狗官方推荐人文科学词库|
| `-e SOGOU_SPORTS_AND_LEISURE=True` |非搜狗官方推荐运动休闲词库|
| `-e SOGOU_LIFE_ENCYCLOPEDIA=True` |非搜狗官方推荐生活百科词库|
| `-e SOGOU_ART_DESIGN=True` |非搜狗官方推荐艺术设计词库|
| `-e SOGOU_VIDEO_GAMES=True` |非搜狗官方推荐电子游戏词库|
| `-e SOGOU_MEDICINE_AND_MEDICINE=True` |非搜狗官方推荐医学医药词库|
| `-e RIME_DICT_NON_TENGXUN_DEL_SET=False` |自用词库仅含有腾讯词频的词(搜狗推荐词库除外)|
| `-e QQ_URL_SET=False` |用qq拼音输入法流行词网址替代下载|
| `-e GITHUB_PROXY` |github代理|

### 群晖docker设置：

1. 卷

|参数|说明|
|-|:-|
| `本地文件夹1:/output` |生成新词位置|
| `本地文件夹2:/config` |rime词库版本存储位置|

2. 环境变量：

|参数|说明|
|-|:-|
| `TZ=Asia/Shanghai` |系统时区设置,默认为Asia/Shanghai|
| `SOGOU_SCEL_UPDATE_AUTO=true` |(true\|false)自动更新搜狗流行词库,默认开启|
| `RIME_DICT_UPDATE_AUTO=true` |(true\|false)自动更新rime词库,默认开启|
| `SOGOU_DICT_NAME=luna_pinyin_simp.sogou_pop` |词库名称,默认为luna_pinyin_simp.sogou_pop|
| `RIME_FREQ=2000001` |词库词频,默认为2000001|
| `ENGLISH_DICT_SET=True` |英语词库|
| `BASIC_DICT_SET=True` |基础词库|
| `WIKI_DICT_SET` |维基词库|
| `LETTERED_WORD_DICT_SET` |字母词词库|
| `CHAIZI_DICT_SET` |拆字词库|
| `SOGOU_TOTAL_OFFICIAL_DICT_SET=True` |搜狗官方推荐所有类别词库|
| `SOGOU_TOTAL_UNOFFICIAL_DICT_SET=True` |搜狗非官方推荐所有类别词库(需开启自用词库)|
| `SOGOU_UNOFFICIAL_DICT_SET=True` |非搜狗官方推荐词库|
| `SOGOU_SINGLE_FILE=True` |合并非搜狗官方推荐词库|
| `ORDER=True` |对合并的非搜狗官方推荐词库排序|
| `DEDUPLICATION=True` |对合并的非搜狗官方推荐词库去重|
| `LEN_NUM=0` |搜狗词库限制长度|
| `RIME_OPENCC=False` |opencc设定|
| `RIME_OPENCC_CONFIG=s2t.json` |opencc配置设定|
| `PREFIX_DICT_NAME=luna_pinyin_simp.` |词库前缀|
| `SOGOU_ENGINEERING_APPLICATION=True` |非搜狗官方推荐工程应用词库|
| `SOGOU_AGRICULTURE_AND_FISHING_LIVESTOCK=True` |非搜狗官方推荐农业渔畜词库|
| `SOGOU_SOCIAL_SCIENCES=True` |非搜狗官方推荐社会科学词库|
| `SOGOU_NATURAL_SCIENCE=True` |非搜狗官方推荐自然科学词库|
| `SOGOU_CITY_INFORMATION=True` |非搜狗官方推荐城市信息词库|
| `SOGOU_ENTERTAINMENT_AND_LEISURE=True` |非搜狗官方推荐娱乐休闲词库|
| `SOGOU_HUMANITIES=True` |非搜狗官方推荐人文科学词库|
| `SOGOU_SPORTS_AND_LEISURE=True` |非搜狗官方推荐运动休闲词库|
| `SOGOU_LIFE_ENCYCLOPEDIA=True` |非搜狗官方推荐生活百科词库|
| `SOGOU_ART_DESIGN=True` |非搜狗官方推荐艺术设计词库|
| `SOGOU_VIDEO_GAMES=True` |非搜狗官方推荐电子游戏词库|
| `SOGOU_MEDICINE_AND_MEDICINE=True` |非搜狗官方推荐医学医药词库|
| `RIME_DICT_NON_TENGXUN_DEL_SET=False` |自用词库仅含有腾讯词频的词(搜狗推荐词库除外)|
| `QQ_URL_SET=False` |用qq拼音输入法流行词网址替代下载|
| `GITHUB_PROXY` |github代理|
