群晖nas自用。

感谢以下项目:

https://github.com/binux/qiandao

设置：

卷：

本地文件夹1 映射 /dbpath (qiandao程序数据库database.db存储位置，设置后重装只要备份database.db即可，数据不会丢失)

端口：

本地端口1 映射 8923 （ qiandao程序web访问端口 ）

qiandao程序web访问: IP:本地端口1

环境变量：

TZ=Asia/Shanghai （系统时区设置,默认为Asia/Shanghai ）

DOMAIN=（站点域名，可不设置，设置后可发送验证mail，需同时设置MAIL_值，本地可设置为IP:端口）

MAIL_STMP=（邮件smtp地址-可不设置，设置后可发送签到失败提醒mail，需同时设置DOMAIN值）

MAIL_PORT=（邮件端口值）

MAIL_SSL=（邮件ssl开关）

MAIL_STARTTLS=（邮件starttls开关）

MAIL_USER=（邮件账户）

MAIL_PASSWORD=（邮件密码）

MAIL_DOMAIN=（邮件域名）

MAILGUN_KEY=（mailgun key）

ENV ADMINEMAIL=（设置管理员账户，第一次不会生效，只有注册用户才生效）

MAIL配置说明：

原程序并没有MAIL_PORT，MAIL_SSL，MAIL_STARTTLS这三项值，只有MAIL_SSL有值时才会开启此mail功能，否则调用原程序mail功能。

以hotmail邮箱配置为例：

MAIL_STMP=smtp-mail.outlook.com

MAIL_PORT=587

MAIL_SSL=True

MAIL_STARTTLS=True

MAIL_USER=**@hotmail.com

MAIL_PASSWORD=**

其它设置详见：https://github.com/binux/qiandao
