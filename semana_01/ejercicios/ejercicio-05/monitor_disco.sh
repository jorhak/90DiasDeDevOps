#!/bin/bash
: '
Este script inspecciona el disco raiz / y /home esto
para mandar una alerta cuando estos llegen a utilizar cierta 
cantidad de espacio en el disco
'

ADMIN="hola@gmail.com"
USO_RAIZ=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
TAMANO_HOME=$(du -sh /home | awk '{print $1}' | sed 's/G//g')

ALERT_RAIZ="¡Alerta: Partición / al ${USO_RAIZ}%!"
ALERT_HOME="¡Alerta: /home ocupa ${TAMANO_HOME}GB!"
LOG_FILE="monitor_disco.log"

if [ "$USO_RAIZ" -ge 10 ]; then
    echo "$(date +%Y-%m-%d\ %H:%M:%S) $ALERT_RAIZ" >> "$LOG_FILE"
    echo "$ALERT_RAIZ" | mail -s "Alerta Partición /" $ADMIN
fi

if (( $(echo "$TAMANO_HOME > 2" | bc -l) )); then
    echo "$(date +%Y-%m-%d\ %H:%M:%S) $ALERT_HOME" >> "$LOG_FILE"
    echo "$ALERT_HOME" | mail -s "Alerta Directorio /home" $ADMIN
fi
