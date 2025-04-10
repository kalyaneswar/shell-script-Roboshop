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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE
VALIDATE $? ""Erlang script installation"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE
VALIDATE $? ""Server script installation"

dnf install rabbitmq-server -y &>>$LOGFILE
VALIDATE $? "Installing RabbitMQ"

systemctl enable rabbitmq-server &>>$LOGFILE
VALIDATE $? "Enabling RabbitMQ"

systemctl start rabbitmq-server &>>$LOGFILE
VALIDATE $? "Starting RabbitMQ"

# rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE
# VALIDATE $? "Adding user in RabbitMQ "

# rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE
# VALIDATE $? "Setting permissions RabbitMQ "