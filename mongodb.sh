#!/bin/bash

app_name=mongod

source ./common.sh

check_root

cp mongodb.repo /etc/yum.repos.d/mongo.repo | tee -a $LOGS_FILE
validate $? "copying mongo repo"

dnf install mongodb-org -y | tee -a $LOGS_FILE
validate $? "Installing mongodb server"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "Allowing remote users"

app_restart

print_total_time

