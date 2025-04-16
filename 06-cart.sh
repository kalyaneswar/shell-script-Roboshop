#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi


dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling Node JS"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling NodeJS 20 version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing NodeJS"

useradd roboshop &>>$LOGFILE
VALIDATE $? "adding roboshop user"

mkdir -p /app &>>$LOGFILE
VALIDATE $? "Creating directory if not exit"

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOGFILE
VALIDATE $? "Downloading the zip file for the service"

cd /app &>>$LOGFILE
VALIDATE $? "changing to app current directory"

unzip /tmp/cart.zip &>>$LOGFILE
VALIDATE $? "Unzipping the code"

cd /app &>>$LOGFILE
VALIDATE $? "changing to app current directory"

npm install &>>$LOGFILE
VALIDATE $? "Installing Npm"

cp cart.service /etc/systemd/system/cart.service &>>$LOGFILE
VALIDATE $? "copying cart service file"

# ​The systemctl daemon-reload command is used in Linux systems to instruct the systemd system and service manager to reload its configuration files. This is particularly necessary after creating, modifying, or deleting unit files (such as .service files) so that systemd recognizes and applies the changes without requiring a system reboot. It re-reads all unit files and regenerates the dependency tree, ensuring that any updates to service configurations are acknowledged. ​

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "system demon reload"


systemctl enable cart &>>$LOGFILE
VALIDATE $? "cart service enabling"


systemctl start cart &>>$LOGFILE
VALIDATE $? "cart service start"



