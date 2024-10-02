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

dnf module disable nodejs -y &>>$LOG_FILE
VALIDATE $? "disable default nodejs"

dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Enable nodejs:20"

dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Nodejs installation"

id expense &>>$LOG_FILE
if [ $? -ne 0 ]; then
    echo -e "expense user not exists...$G creating $N"
    useradd expense &>>$LOG_FILE
    VALIDATE $? "creating expense user"
else 
    echo -e "expense user already exists..$Y skipping $N"
fi

mkdir -p /app
VALIDATE $? "creating App directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE
VALIDATE $? "downloading backend app code"

cd /app
rm -rf /app/* 
unzip /tmp/backend.zip &>>$LOG_FILE
VALIDATE $? "extracting code"

npm install &>>$LOG_FILE

cp /home/ec2-user/Expense-shell/backend.service /etc/systemd/system/backend.service

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "Installing MySQL Client"

mysql -h mysql.daws81s.icu -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOG_FILE
VALIDATE $? "Schema loading"

systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "Daemon reload"

systemctl enable backend &>>$LOG_FILE
VALIDATE $? "Enabled backend"

systemctl restart backend &>>$LOG_FILE
VALIDATE $? "Restarted Backend"




