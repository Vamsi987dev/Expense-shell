#!/bin/bash

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

logs_folder="/var/log/expense"
script_name=$( echo $0 | cut -d "." -f1 )
timestamp=$( date +%Y-%m-%d-%H-%M-%S )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $logs_folder

USERID=$(id -u)

check_root() {
    if [ $USERID -ne 0 ]; then
        echo -e "$R please run this script with root previleges $N" | tee -a $LOG_FILE
        exit 1
        
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]; then                     # Check if the first argument ($1) is not equal to 0 (failure)
        echo -e "$2 is...$R FAILED $N"  | tee -a $LOG_FILE  # Print a failure message in red and append it to the log file
        exit 1                           # Exit the script with error status 1
    else
        echo -e "$2 is... $G SUCCESS $N" | tee -a $LOG_FILE  # Print a success message in green and append it to the log file
    fi
}
echo "Script started executing at: $(date)" | tee -a $LOG_FILE

check_root

# Check if MySQL server is already installed
dnf list installed | grep mysql-server &>>$LOG_FILE

# Capture the exit status of the grep command
if [ $? -eq 0 ]; then
    echo "MySQL Server is already installed." &>>$LOG_FILE
else
    echo "MySQL Server is not installed. Installing now..." &>>$LOG_FILE
    dnf install mysql-server -y &>>$LOG_FILE
    VALIDATE $? "Installing MySQL Server"
fi

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabled MySQL Server"

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Started MySQL server"

mysql -h mysql.daws81s.icu -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE

if [ $? -ne 0 ]
then
    echo "MySQL root password is not setup, setting now" &>>$LOG_FILE
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "Setting UP root password"
else
    echo -e "MySQL root password is already setup...$Y SKIPPING $N" | tee -a $LOG_FILE
fi









