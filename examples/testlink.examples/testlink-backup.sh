#!/bin/bash

#
# backup testlink
#

# prepare filenames
mydate=`date +%y%m%d`
backup_folder="/home/vagrant/backup"
upload_folder="/var/www/testlink/upload_area/"
filename1="${backup_folder}/testlink_db_${mydate}.backup.sql"
filename2="${backup_folder}/testlink_upload_${mydate}.backup.tar.gz"
filename3="${backup_folder}/testlink_config_${mydate}.backup.tar.gz"

# backup SQL
# MySQL
#mysqldump -uroot -proot_pass testlink_db > ${filename1}
# PostgreSQL
#pg_dump -U postgres -w > $(date +"%Y%m%d%H%M%S")_redmine.sql redmine
#pg_dump -U postgres -w > $(date +"%Y%m%d%H%M%S")_redmine.sql testlink
pg_dump -U postgres -w > ${filename1} testlink
# restore #
#psql -U postgres -d redmine -f 20120520142447_redmine.sql


# pack it
gzip -f9 ${filename1}

# backup attachments
tar -czvf ${filename2} ${upload_folder}

# backup configs

tar -czvf ${filename3} custom_config.inc.php config.inc.php

##
