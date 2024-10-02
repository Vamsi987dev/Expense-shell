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

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "Installing Nginx"

systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "Enabling Nginx"

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "starting Nginx"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE #Removing the default content of webserver
VALIDATE $? "Removing default web content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE
VALIDATE $? "Downloading frontend code"

cd /usr/share/nginx/html

unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "unzip"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "Copied expense conf"


systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "Restart nginx"