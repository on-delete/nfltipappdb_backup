#!/bin/bash
# TARGET: Backup-Ziel
# IGNORE: Liste zu ignorierender Datenbanken (durch | getrennt)
# CONF: MySQL Config-Datei, welche die Zugangsdaten enthaelt
TARGET=/home/andre/git/nfltipappdb_backup
DB=nfltipappdb
#IGNORE="phpmyadmin|mysql|information_schema|performance_schema|test"
CONF=/etc/mysql/debian.cnf
if [ ! -r $CONF ]; then /usr/bin/logger "$0 - auf $CONF konnte nicht zugegriffen werden"; exit 1; fi
if [ ! -d $TARGET ] || [ ! -w $TARGET ]; then /usr/bin/logger "$0 - Backup-Verzeichnis nicht beschreibbar"; exit 1; fi

#DBS="$(/usr/bin/mysql --defaults-extra-file=$CONF -Bse 'show databases' | /bin/grep -Ev $IGNORE)"
NOW=$(date +"%Y-%m-%d")

/usr/bin/mysqldump --defaults-extra-file=$CONF --skip-extended-insert --skip-comments $DB > $TARGET/$DB.sql
#/usr/bin/mysqldump --defaults-extra-file=/etc/mysql/debian.cnf --skip-extended-insert --skip-comments nfltipappdb > /home/andre/git/nfltipappdb_backup/nfltipappdb.sql

#for DB in $DBS; do
#    /usr/bin/mysqldump --defaults-extra-file=$CONF --skip-extended-insert --skip-comments $DB > $TARGET/$DB.sql
#done

#if [ -x /usr/bin/bzr ] && [ -d ${TARGET}/.bzr/branch ]; then
cd $TARGET
git add .
git commit -m "$NOW"
git push --verbose
#else
#  /usr/bin/logger "$0 - bzr nicht verfuegbar oder Backup-Ziel nicht unter Versionskontrolle"
#fi

/usr/bin/logger "$0 - Backup von $NOW erfolgreich durchgefuehrt"
exit 0

#zur wiederherstellung folgender befehl:
#sudo mysql --defaults-extra-file=/etc/mysql/debian.cnf nfltipappdb < /home/andre/git/nfltipappdb_backup/nfltipappdb.sql 
