#!/bin/bash

app_name=rabbitmq-server

source ./common.sh

check_root

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
validate $? "installing repo"
dnf install rabbitmq-server -y
validate $? "installing server"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
validate $? "Adding user & giving permissions"

systemctl daemon-reload


print_total_time


