#!/bin/bash
echo done0
set -e
echo done1
# Backup FROM (cluster mention all nodes) (single node mention the single node only)
# MONGODB For production cluster or the main nodes that you want to take the backup from 
MONGO_HOST1="10.0.3.4"
MONGO_HOST2=""
MONGO_HOST3=""
# backup to server (cluster mention all nodes) (single node mention the single node only)
MONGO_HOST_DR1="10.0.3.5"
MONGO_HOST_DR2=""
MONGO_HOST_DR3=""
TIMESTAMP=`date +%F-%H`
# SSH user and password to another site
USER="test2"
SSHPASSWORD=password
# Backup file name 
BACKUP_FILE_PATH="/home/test2/backup-$TIMESTAMP"
DR_DIRECOTRY="/home/test2"
DR_SOURCE="/home/test2/backup-$TIMESTAMP"

echo done2
error_exit()
{
  echo "Backup filed due Error: $1" 1>&2
  rm -rf $BACKUP_FILE_PATH
    exit 1
}

echo done3
# Create backup



if [ -z "$MONGO_HOST2" ]
then
       mongodump mongodb://$MONGO_HOST1 --out $BACKUP_FILE_PATH
else
        if [ -z "$MONGO_HOST3" ]
            then
            mongodump mongodb://$MONGO_HOST1,$MONGO_HOST2 --out $BACKUP_FILE_PATH
            else
            mongodump mongodb://$MONGO_HOST1,$MONGO_HOST2,$MONGO_HOST3 --out $BACKUP_FILE_PATH
        fi
fi

mongodump mongodb://$MONGO_HOST1 --out $BACKUP_FILE_PATH

echo done4
#copy dump file to remote server
sshpass -p "$SSHPASSWORD" scp -r $BACKUP_FILE_PATH $USER@$MONGO_HOST_DR1:$DR_DIRECOTRY
echo done5
#Connect to the remote server
sshpass -p "$SSHPASSWORD" ssh -t $USER@$MONGO_HOST_DR1 << EOF
echo done5
# restore  backup
if [ -z "$MMONGO_HOST_DR2" ]
then
       mongorestore --drop  mongodb://$MONGO_HOST_DR1 $DR_SOURCE
else
        if [ -z "$MMONGO_HOST_DR3" ]
            then
            mongorestore --drop  mongodb://$MONGO_HOST_DR1,$MONGO_HOST_DR2 $DR_SOURCE
            else
            mongorestore --drop  mongodb://$MONGO_HOST_DR1,$MONGO_HOST_DR2,$MONGO_HOST_DR3 $DR_SOURCE
        fi
fi
mongorestore --drop  mongodb://$MONGO_HOST_DR1 $DR_SOURCE
echo done6
# Make archive
#tar cf $BACKUP_FILE_PATH.tar -C $BACKUP_FILE_PATH/ .
# Remove backup folder
rm -rf $BACKUP_FILE_PATH
echo done7
exit 
EOF
rm -rf $BACKUP_FILE_PATH
echo done8
