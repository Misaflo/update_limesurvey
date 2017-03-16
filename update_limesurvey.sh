#!/usr/bin/env bash

# Script for updating LimeSurvey (version > 2.50).

WEBAPPS_PATH='/path/to/installation' # Path of limesurvey installation.
INSTALLATION_NAME='survey'           # Name of the installation directory.
INSTALLATION_PATH="$WEBAPPS_PATH/$INSTALLATION_NAME"
FILE='/path/to/limesurvey.tar.gz'    # LimeSurvey archive to install.
BACKUP_PATH='/path/to/backup'        # Backup directory of the old installation.

BD_HOST='localhost'
DB_NAME='limesurvey'
DB_USER='limesurvey'
DB_PASSWORD='password'

if [ ! -d $BACKUP_PATH ]; then
  echo "Error: $BACKUP_PATH does not exist.";
  exit 1;
fi

if [ ! $(ls -A $BACKUP_PATH | wc -c) -eq 0 ]; then
  echo "Error: $BACKUP_PATH is not empty."
  exit 2;
fi

mysqldump --user=$DB_USER --password=$DB_PASSWORD $DB_NAME > $BACKUP_PATH/limesurvey.sql

sudo mv $INSTALLATION_PATH $BACKUP_PATH
tar xvf $FILE --directory $WEBAPPS_PATH
mv $WEBAPPS_PATH/limesurvey $INSTALLATION_PATH
cp $BACKUP_PATH/$INSTALLATION_NAME/application/config/config.php $INSTALLATION_PATH/application/config/
cp -r $BACKUP_PATH/$INSTALLATION_NAME/upload $INSTALLATION_PATH

sudo chgrp -R www-data $INSTALLATION_PATH/tmp && sudo chmod 770 $INSTALLATION_PATH/tmp/{,assets,runtime,upload}
sudo chgrp -R www-data $INSTALLATION_PATH/upload && sudo chmod 770 $INSTALLATION_PATH/upload/{,admintheme,labels,surveys,templates}
sudo chgrp -R www-data $INSTALLATION_PATH/application/config/ && sudo chmod 770 $INSTALLATION_PATH/application/config/ && sudo chmod 660 $INSTALLATION_PATH/application/config/*
