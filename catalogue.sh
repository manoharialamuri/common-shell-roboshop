#!/bin/bash

app_name=catalogue

source ./common.sh

check_root

nodejs_setup

app_setup

systemd_setup

cp $SCRIPT_DIR/mongodb.repo /etc/yum.repos.d/mongo.repo
validate $? "copying mongo repo"

dnf install mongodb-mongosh -y
validate $? "Installinh mongosh"

INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval 'db.getMongo().getDBNames().indexOf("catalogue")')
if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js
    validate $? "products loading"
else
    echo -e "products already loaded...$Y Skipping $N"
fi

app_restart

print_total_time

