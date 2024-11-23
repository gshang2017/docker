#! /usr/bin/with-contenv bash

#修改用户UID GID
groupmod -o -g "$GID" kms
usermod -o -u "$UID" kms
