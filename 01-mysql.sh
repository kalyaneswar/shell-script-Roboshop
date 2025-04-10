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

# Installing Mysql
dnf install mysql-server -y >>$LOGFILE
VALIDATE $? "Installing MySQL"

# Enabling Mysql
systemctl enable mysqld  >>$LOGFILE
VALIDATE $? "Enabling MySQL"

# Starting the mysql service
systemctl start mysqld >>$LOGFILE
VALIDATE $? "Starting MySQL"

# setting the password
mysql_secure_installation --set-root-pass RoboShop@1 >>$LOGFILE
VALIDATE $? "Setting Password for MySQL"

mysql -uroot -pRoboShop@1 >>$LOGFILE