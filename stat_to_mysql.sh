#!/bin/sh

PROJECT=LLLL
IP=10.2
BACKDIR=/hhhhhh
BASEBACKDIR=$BACKDIR/base
INCRBACKDIR=$BACKDIR/incr

DB_HOST='host'
DB_USER='backup'
DB_PASSWD='pass'
DB_NAME='backupdb'
TABLE='log'


LAST_BASE_BACKUP_TIME=$(find $BASEBACKDIR -type f -name "*.gz" -exec stat --format '%Y :%y %n %s' "{}" \; | sort -nr | cut -d: -f2- | head | awk '{print $1" "$2; exit}')
LAST_BASE_BACKUP_FILE_NAME=$(find $BASEBACKDIR -type f -name "*.gz" -exec stat --format '%Y :%y %n %s' "{}" \; | sort -nr | cut -d: -f2- | head | awk '{print $4; exit}')
LAST_BASE_BACKUP_FILE_SIZE=$(find $BASEBACKDIR -type f -name "*.gz" -exec stat --format '%Y :%y %n %s' "{}" \; | sort -nr | cut -d: -f2- | head | awk '{print $5; exit}')

LAST_INCR_BACKUP_TIME=$(find $INCRBACKDIR -type f -name "*.gz" -exec stat --format '%Y :%y %n %s' "{}" \; | sort -nr | cut -d: -f2- | head | awk '{print $1" "$2; exit}')
LAST_INCR_BACKUP_FILE_NAME=$(find $INCRBACKDIR -type f -name "*.gz" -exec stat --format '%Y :%y %n %s' "{}" \; | sort -nr | cut -d: -f2- | head | awk '{print $4; exit}')
LAST_INCR_BACKUP_FILE_SIZE=$(find $INCRBACKDIR -type f -name "*.gz" -exec stat --format '%Y :%y %n %s' "{}" \; | sort -nr | cut -d: -f2- | head | awk '{print $5; exit}')


echo "LAST_BASE_BACKUP_TIME $LAST_BASE_BACKUP_TIME"
echo "LAST_BASE_BACKUP_FILE_NAME $LAST_BASE_BACKUP_FILE_NAME"
echo "LAST_BASE_BACKUP_FILE_SIZE $LAST_BASE_BACKUP_FILE_SIZE"

echo "LAST_INCR_BACKUP_TIME $LAST_INCR_BACKUP_TIME"
echo "LAST_INCR_BACKUP_FILE_NAME $LAST_INCR_BACKUP_FILE_NAME"
echo "LAST_INCR_BACKUP_FILE_SIZE $LAST_INCR_BACKUP_FILE_SIZE"

if [[ ! $LAST_INCR_BACKUP_TIME ]]
then
mysql -h $DB_HOST --user=$DB_USER --password=$DB_PASSWD $DB_NAME << EOF
INSERT INTO $TABLE (project, ip, last_base_backup_time,last_base_backup_file_name, last_base_backup_file_size) VALUES ("$PROJECT","$IP","$LAST_BASE_BACKUP_TIME","$LAST_BASE_BACKUP_FILE_NAME","$LAST_BASE_BACKUP_FILE_SIZE");
EOF
else
mysql -h $DB_HOST --user=$DB_USER --password=$DB_PASSWD $DB_NAME << EOF
INSERT INTO $TABLE (project, ip, last_base_backup_time,last_base_backup_file_name, last_base_backup_file_size,last_incr_backup_time,last_incr_backup_file_name,last_incr_backup_file_size) VALUES ("$PROJECT","$IP","$LAST_BASE_BACKUP_TIME","$LAST_BASE_BACKUP_FILE_NAME","$LAST_BASE_BACKUP_FILE_SIZE","$LAST_INCR_BACKUP_TIME","$LAST_INCR_BACKUP_FILE_NAME","$LAST_INCR_BACKUP_FILE_SIZE");
EOF
fi

