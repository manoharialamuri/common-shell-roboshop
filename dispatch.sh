#!/bin/bash

app_name=dispatch
source ./common.sh

check_root

dnf install golang -y
validate $? "Installing golang"
app_setup
cd /app 
go mod init dispatch
validate $? "Init dispatch"
go get 
go build
validate $? "get and buils dispatch"
systemd_setup
app_setup
app_restart

print_total_time

