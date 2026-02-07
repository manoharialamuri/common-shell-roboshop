#!/bin/bash

app_name=nginx

source ./common.sh

check_root
nginx_setup

rm -rf /usr/share/nginx/html/* 
validate $? "removing content from the file"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
validate $? "Downloading code"
cd /usr/share/nginx/html 
validate $? "moving to html directory"
unzip /tmp/frontend.zip
validate $? "unzipping frontend code"
rm -rf /etc/nginx/nginx.conf
cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
validate $? "copying nginx content"

app_restart

print_total_time

