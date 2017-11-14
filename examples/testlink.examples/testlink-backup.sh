#!/bin/bash

#
# backup testlink
#

# prepare filenames
#mydate=`date +%y%m%d`
mydate=$(date +"%Y%m%d-%H%M%S")

PROJECT="testlink"
PROJECT_DB="testlink"

POSTGRES_ADMIN_USER="postgres"

PATH_TO_TESTLINK_DIR="/var/www/${PROJECT}"

#backup_folder="/home/vagrant/backup"
#backup_folder="${PWD}/backup"
backup_folder="${HOME}/backups/${PROJECT}"

# silently create backup_folder with parents
mkdir -p ${backup_folder}

upload_folder="${PATH_TO_TESTLINK_DIR}/upload_area/"


filename1="${backup_folder}/${PROJECT}_db_${mydate}.backup.sql"
filename2="${backup_folder}/${PROJECT}_upload_${mydate}.backup.tar.gz"
filename3="${backup_folder}/${PROJECT}_config_${mydate}.backup.tar.gz"

echo;
echo -e "TIMESTAMP: ${mydate}"
echo -e "Backup PATH: ${backup_folder}"
echo -e "${PROJECT} PATH: ${PATH_TO_TESTLINK_DIR}"
echo -e "${PROJECT} Upload PATH: ${upload_folder}"
echo; echo;


## backup cleanup

# keep only 13 backups, add 14th later so will be 14 total

# go to backup folder
cd ${backup_folder}

# do backup clean
ls -t ${PROJECT}_db_*.backup.sql.gz | sed -e '1,13d' | xargs -d '\n' rm -f
ls -t ${PROJECT}_upload_*.backup.tar.gz | sed -e '1,13d' | xargs -d '\n' rm -f
ls -t ${PROJECT}_config_*.backup.tar.gz | sed -e '1,13d' | xargs -d '\n' rm -f

# change folder back
cd -

## done backup cleanup



## backup SQL

# MySQL
#mysqldump -uroot -proot_pass testlink_db > ${filename1}
# PostgreSQL
#pg_dump -U postgres -w > ${filename1} testlink
#pg_dump -U postgres -w > $(date +"%Y%m%d%H%M%S")_redmine.sql redmine
#pg_dump -U postgres -w > $(date +"%Y%m%d%H%M%S")_testlink.sql testlink
#sudo -u postgres pg_dumpall -w > $(date +"%Y%m%d%H%M%S")_testlink_all.sql
#sudo -u postgres pg_dump -w testlink > $(date +"%Y%m%d-%H%M%S")_testlink.sql
#sudo -u postgres pg_dump testlink > `date +\%Y-\%m-\%d_\%T`.sql
sudo -u ${POSTGRES_ADMIN_USER} pg_dump -w ${PROJECT_DB} > ${filename1}

# restore example
#psql -U postgres -d testlink -f 20120520142447_testlink.sql

# pack it
gzip -f9 ${filename1}


## backup attachments
tar -czf ${filename2} ${upload_folder}


## backup configs
tar -czf ${filename3} ${PATH_TO_TESTLINK_DIR}/custom_config.inc.php ${PATH_TO_TESTLINK_DIR}/config.inc.php


###
