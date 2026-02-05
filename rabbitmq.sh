#!/bin/bash

app_name=rabbitmq

source ./common.sh

check_root

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
validate $? "installing repo"
dnf install rabbitmq-server -y
validate $? "installing server"

systemd_setup

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
validate $? "Adding user & giving permissions"

print_total_time

