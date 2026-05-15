#!/bin/sh
#
# Initialize Linux users and groups, by (re)writing /etc/passwd, /etc/group and
# /etc/shadow.
#

set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.

#fix passwd
cp -f /etc/bak.passwd /tmp/bak.passwd
cat /etc/passwd|while read rows
do
   echo "$rows"|cut -d':' -f1|xargs -I {} sed -i '/^{}/d' /tmp/bak.passwd
done
cat /tmp/bak.passwd >> /etc/passwd

#fix group
cp -f /etc/bak.group /tmp/bak.group
cat /etc/group|while read rows
do
   echo "$rows"|cut -d':' -f1|xargs -I {} sed -i '/^{}/d' /tmp/bak.group
done
cat /tmp/bak.group >> /etc/group

#fix shadow
cp -f /etc/bak.shadow /tmp/bak.shadow
cat /etc/shadow|while read rows
do
   echo "$rows"|cut -d':' -f1|xargs -I {} sed -i '/^{}/d' /tmp/bak.shadow
done
cat /tmp/bak.shadow >> /etc/shadow

chmod 644 /etc/passwd
chmod 644 /etc/group
chown root:shadow /etc/shadow
chmod 644 /etc/shadow

rm /tmp/bak.*

# vim:ft=sh:ts=4:sw=4:et:sts=4
