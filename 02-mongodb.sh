#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log

# Color codes for terminal output
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# Function to validate the success of commands
VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

# Ensure the script is being run as root
if [ $USERID -ne 0 ]; then
    echo "Please run this script with root access."
    exit 1
else
    echo "You are super user."
fi


cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Creating Mongo Repo"

dnf install mongodb-org -y &>>$LOGFILE
VALIDATE $? "Installing MongoDB"

systemctl enable mongod &>>$LOGFILE
VALIDATE $? "Enabling MongoDB"

systemctl start mongod &>>$LOGFILE
VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "Remote server access"

systemctl restart mongod &>>$LOGFILE
VALIDATE $? "Restarting MongoDB"