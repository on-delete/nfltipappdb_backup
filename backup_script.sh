#!/bin/bash
# TARGET: Backup-Ziel
# CONF: MySQL Config-Datei, welche die Zugangsdaten enthaelt
TARGET=/home/andre/git/nfltipappdb_backup
DB=nfltipappdb
CONF=/etc/mysql/debian.cnf
if [ ! -r $CONF ]; then echo "Auf $CONF konnte nicht zugegriffen werden" >> /var/log/backuplog; exit 1; fi
if [ ! -d $TARGET ] || [ ! -w $TARGET ]; then echo "Backup-Verzeichnis nicht beschreibbar" >> /var/log/backuplog; exit 1; fi

NOW=$(date +"%Y-%m-%d")

/usr/bin/mysqldump --defaults-extra-file=$CONF --skip-extended-insert --skip-comments $DB > $TARGET/$DB.sql

echo "Backup created, now uploading to git..." >> /var/log/backuplog
eval $(ssh-agent -s)
ssh-add /home/andre/.ssh/id_rsa
cd $TARGET
git add .
git commit -m "$NOW"
git push --verbose

/usr/bin/logger "Backup von $NOW erfolgreich durchgefuehrt"
exit 0

#zur wiederherstellung folgender befehl:
#sudo mysql --defaults-extra-file=/etc/mysql/debian.cnf nfltipappdb < /home/andre/git/nfltipappdb_backup/nfltipappdb.sql 
