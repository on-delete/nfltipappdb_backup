#!/bin/bash
# TARGET: Backup-Ziel
# CONF: MySQL Config-Datei, welche die Zugangsdaten enthaelt
TARGET=/home/andre/git/nfltipappdb_backup
DB=nfltipappdb
CONF=/etc/mysql/debian.cnf
if [ ! -r $CONF ]; then /usr/bin/logger "$0 - auf $CONF konnte nicht zugegriffen werden"; exit 1; fi
if [ ! -d $TARGET ] || [ ! -w $TARGET ]; then /usr/bin/logger "$0 - Backup-Verzeichnis nicht beschreibbar"; exit 1; fi

NOW=$(date +"%Y-%m-%d")

/usr/bin/mysqldump --defaults-extra-file=$CONF --skip-extended-insert --skip-comments $DB > $TARGET/$DB.sql

eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
cd $TARGET
git add .
git commit -m "$NOW"
git push --verbose

/usr/bin/logger "$0 - Backup von $NOW erfolgreich durchgefuehrt"
exit 0

#zur wiederherstellung folgender befehl:
#sudo mysql --defaults-extra-file=/etc/mysql/debian.cnf nfltipappdb < /home/andre/git/nfltipappdb_backup/nfltipappdb.sql 
