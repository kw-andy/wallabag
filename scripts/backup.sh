#!/bin/bash
# Sauvegarde wallabag - rotation sur 7 jours (écrase le même jour de la semaine suivante)

BACKUP_DIR="/home/andykw/backups/wallabag"
DAY=$(date +%u)  # 1=lundi ... 7=dimanche
LOG="$BACKUP_DIR/backup.log"

mkdir -p "$BACKUP_DIR"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Début sauvegarde (jour $DAY)" >> "$LOG"

# Dump MariaDB
docker exec wallabag-db mysqldump -u wallabag -pwallabag wallabag > "$BACKUP_DIR/db_$DAY.sql" 2>> "$LOG"
if [ $? -ne 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERREUR dump base de données" >> "$LOG"
    exit 1
fi

# Backup volumes (données + images)
docker run --rm \
    -v docker_wallabag-data:/data/wallabag-data:ro \
    -v docker_wallabag-images:/data/wallabag-images:ro \
    -v "$BACKUP_DIR":/backup \
    alpine tar czf "/backup/volumes_$DAY.tar.gz" /data 2>> "$LOG"
if [ $? -ne 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERREUR sauvegarde volumes" >> "$LOG"
    exit 1
fi

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Sauvegarde terminée (db_$DAY.sql + volumes_$DAY.tar.gz)" >> "$LOG"
