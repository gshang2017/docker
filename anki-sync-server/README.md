群晖nas自用：

感谢以下项目:

https://github.com/dae/anki

https://github.com/tsudoko/anki-sync-server

目前支持的版本范围是2.1.1〜2.1.11 (2.1.9除外)，其它版本自测。

设置：

升级安装需移除配置文件夹内auth.db和session.db文件,并暂时重命名collections文件夹内的用户名文件夹。等程序重建auth.db后，即可将collections内重命名后的文件夹改为用户名。

卷：

本地文件夹1 映射 /config （anki-sync-server配置位置文件)

端口：

本地端口1 映射 27701 （ anki-sync-server同步端口 ）

环境变量：

USER=（ anki-sync-server同步服务器用户名，建议用邮箱格式，例如：XXXXXXX@XX.com，不然android无法使用。）

PASSWORD=（ anki-sync-server同步服务器密码 ）

具体设置：

Android：

设置-偏好设置-高级设置-自定义同步服务器：

1.启用 使用自定义同步服务器选项

2.同步地址：ip:本地端口1/ (http:/192.168.1.xxx:27701/)

3.媒体文件同步地址：ip:本地端口1/msync (http:/192.168.1.xxx:27701/msync)

4.点击同步按钮，输入邮箱格式用户名以及密码。(请忽略AnkiWeb这几个字）

windows：(需重启Anki才生效)

1.找到C:\Users\用户名\AppData\Roaming\Anki2\addons21文件夹(具体位置请自己找) 在addons21下创建ankisyncd新目录，并创建文件__init__.py，在文件中写入以下代码(需改其中http://ip:27701/)：

import anki.sync

addr = "http://ip:27701/" # put your server address here

anki.sync.SYNC_BASE = addr + "%s"

2.点击同步按钮，输入邮箱格式用户名以及密码。(请忽略AnkiWeb这几个字）

具体设置可看：

https://github.com/tsudoko/anki-sync-server/blob/master/README.md
