#!/bin/bash
#Comprime el contenido de /var/log y lo guarda en /home/user/backups/
#elimina los backups de mas de 7 dias

USER=$(whoami)
BACKUPS="/home/$USER/backups"
LOG="/var"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
LOG_FILE="$BACKUPS/backups.log"
TIMESTAMP_LOG=$(date +%Y%m%d-%H%M%S)

if [ -e "$BACKUPS" ] && [ -d "$BACKUPS" ]; then
  echo "$(date +%Y%m%d-%H%M%S)   LOG: Ruta backups: $BACKUPS." >> "$LOG_FILE"
  cd "$LOG"
  sudo tar czf "$BACKUPS/"logs_"$TIMESTAMP".tar.gz log
  echo "$(date +%Y%m%d-%H%M%S)   LOG: Compresion exitosa" >> "$LOG_FILE"
else
  mkdir -p "$BACKUPS"
  echo "$(date +%Y%m%d-%H%M%S)   CREATE: Creacion de directorio para los backups:: $BACKUPS" >> "$LOG_FILE"
fi

find "$BACKUPS" -name "logs_*.tar.gz" -mtime +7 -exec rm {} \; 2>&1 | tee -a "$LOG_FILE"
