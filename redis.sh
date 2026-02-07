#!/bin/bash

source ./common.sh

app_name=redis

check_root

dnf module enable redis:7 -y &>> $LOGS_FILE
validate $? "Enabling redis 7"
dnf install redis -y | tee -a $LOGS_FILE
validate $? "Installing redis"
sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
validate $? "Allowing remote connections"
systemctl daemon-reload
validate $? "reloaded"

app_restart
print_total_time

