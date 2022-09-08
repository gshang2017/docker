#! /bin/sh

while [ ! -e "/config/database.db" ]; do
  sleep 3
done
while [ "$(sqlite3 /config/database.db "SELECT id FROM user WHERE email='$ADMIN_MAIL';" |wc -l)" -eq 0 ]; do
  sleep 3
done
if [ "$(sqlite3 /config/database.db "SELECT role FROM user WHERE email='$ADMIN_MAIL';" |grep "admin" |wc -l)" -eq 0 ]; then
  python3 /usr/local/qiandao/app/chrole.py $ADMIN_MAIL admin
fi
