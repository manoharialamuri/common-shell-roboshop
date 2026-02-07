#!/bin/bash

USERID=$(id -u)

LOGS_FOLDER="/var/log/common-shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
SCRIPT_DIR=$PWD
START_TIME=$(date +%s)
MONGODB_HOST=mongodb.daws88s.store

mkdir -p $LOGS_FOLDER

echo "$(date "+%Y-%m-%d %H:%M:%S") | Script executed at : $(date)" | tee -a $LOGS_FILE 

check_root(){
    if [ $USERID -ne 0 ]; then
        echo "Please use root access" | tee -a $LOGS_FILE
        exit 12
    fi
}

validate(){
    if [ $1 -ne 0 ]; then
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") "$2... Failed" | tee -a $LOGS_FILE
        exit 30
    else
        echo -e "$(date "+%Y-%m-%d %H:%M:%S") "$2.. Success" | tee -a $LOGS_FILE
    fi
}

nodejs_setup(){
    dnf module disable nodejs -y &>> $LOGS_FILE
    validate $? "Disabling nodejs default version"

    dnf module enable nodejs:20 -y &>> $LOGS_FILE
    validate $? "Enabling nodejs version 20"

    dnf install nodejs -y &>> $LOGS_FILE
    validate $? "Installing nodejs"
    
    npm install
    validate $? "Installing Dependencies"
}

app_setup(){
    id roboshop &>> $LOGS_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
        validate $? "Creating system user"
    else
        echo -e "roboshop user already existed...$Y Skipping $N"
    fi
    mkdir -p /app 
    validate $? "Creating app directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>> $LOGS_FILE
    validate $? "Downloading $app_name file"

    cd /app
    validate $? "moving to app directory"

    rm -rf /app/*
    validate $? "removing existing code"

    unzip /tmp/$app_name.zip &>> $LOGS_FILE
    validate $? "unzipping $app_name file"
}

java_setup(){
    dnf install maven -y &>>$LOGS_FILE
    VALIDATE $? "Installing Maven"
    cd /app 
    mvn clean package &>>$LOGS_FILE
    VALIDATE $? "Installing and Building shipping"

    mv target/shipping-1.0.jar shipping.jar 
    VALIDATE $? "Moving and Renaming shipping"  
}

python_setup(){
    dnf install python3 gcc python3-devel -y
    validate $? "Installing python"
    cd /app
    pip3 install -r requirements.txt
    validate $? "installing requirements file"

}

nginx_setup(){
    dnf module disable nginx -y &>> $LOGS_FILE
    validate $? "Disabling nginx default version"
    dnf module enable nginx:1.24 -y &>> $LOGS_FILE
    validate $? "enable nginx 24"
    dnf install nginx -y &>> $LOGS_FILE
    validate $? "Installing nginx"

}
systemd_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    validate $? "Copying systemctl file"
    systemctl enable $app_name 
    systemctl start $app_name
    validate $? "Enabling and starting $app_name" 
}

app_restart(){
    systemctl restart $app_name
    validate $? "Restarted $app_name"
}

print_total_time(){
    End_time=$(date +%s)
    Total_Time=($End_time-$START_TIME)
    echo -e "$(date "+%Y-%m-%d %H:%M:%S") | "Script Executed in :$G $Total_time in seconds $N"" | tee -a $LOGS_FILE
}