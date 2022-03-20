# Mongo-DR updating cron script

This script helps you to keep your DR site updated with the production envirnment. 
with right confirguration you can use this as a normal backup script to file or to another server



## Env values 
MONGO_HOST1="10.0.3.4" \n
MONGO_HOST2=""
MONGO_HOST3=""
MONGO_HOST_DR1="10.0.3.5"
MONGO_HOST_DR2=""
MONGO_HOST_DR3=""
TIMESTAMP=`date +%F-%H`
BACKUP_FILE_PATH="/home/test2/backup-$TIMESTAMP"   
DR_DIRECOTRY="/home/test2"  
DR_SOURCE="/home/test2/backup-$TIMESTAMP"   
#### this value for SSH connection to the other site 
USER="test2"   
SSHPASSWORD=password  this is the SSh password  
