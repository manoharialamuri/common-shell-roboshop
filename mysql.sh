#!/bin/bash

source ./common.sh
app_name=mysql
check_root

dnf install mysql-server -y &>> $LOGS_FILE
validate $? "installing mysql"

systemd_setup

mysql_secure_installation --set-root-pass RoboShop@1
validate $? "creating password"

print_total_time
