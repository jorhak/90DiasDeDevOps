#!/bin/bash
#Revisa los servicios e informa cuales estan activos y cuales no

SERVICIOS=("docker" "mysql" "nginx" "apache2")
PARA="itfuturovaca@gmail.com"
LOG_FILE="servicio_status.log"

for SERVICIO in ${SERVICIOS[@]}; do
  if  systemctl is-active --quiet $SERVICIO; then
    SUCCESS="El servico $SERVICIO esta activo"
    echo "$SUCCESS" >> "$LOG_FILE"
  else
    FAIL="El servico $SERVICIO no esta activo"
    echo "$FAIL" >> "$LOG_FILE"
    echo "$FAIL" | mail -s "Servicio inactivo" "$PARA"
  fi
done

