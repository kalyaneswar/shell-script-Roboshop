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

dnf install redis -y &>>$LOGFILE
VALIDATE $? "Installing Redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>> $LOGFILE
VALIDATE $? "Remote server access"


systemctl enable redis &>>$LOGFILE
VALIDATE $? "Enabling Redis"

systemctl start redis &>>$LOGFILE
VALIDATE $? "Starting Redis"