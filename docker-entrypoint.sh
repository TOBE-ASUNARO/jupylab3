#!/bin/bash

if [ ! -d "/tmp/check" ]; then
  mkdir /tmp/check
  echo `date` > /tmp/check/first_`date +%Y%m%d_%H%M%S`
else
  echo `date` > /tmp/check/second_`date +%Y%m%d_%H%M%S`
fi

# ------------- ここを編集 -------------
# 自身のPCでのUSER IDを設定。（win ubuntu は、1000：1000）
# 調べるには、自身のPCで、コマンド $ idで、確認
USER_ID=1000
GROUP_ID=1000
# ------------- ここを編集 -------------

groupmod -g $GROUP_ID users
usermod -g users jovyan
usermod -u $USER_ID -g $GROUP_ID jovyan
chown -R jovyan:users /home/jovyan
export HOME=/home/jovyan

# exec "$@"
exec /usr/sbin/gosu jovyan "$@"