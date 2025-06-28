#!/bin/bash
#Vamos a monitorear la memoria, disco y cpu en tiempo real

TIEMPO=$(date "+%Y-%m-%d %H:%M:%S")
echo -e "Hora\t\t\tMemoria\t\tDisco (root)\tCPU"
segundos="3600"
fin=$((SECONDS+segundos))
CONTADOR=0

while [ $SECONDS -lt $fin ]; do
    MEMORIA=$(free -m | awk 'NR==2{printf "%.f%%\t\t", $3*100/$2 }')
    DISCO=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}')
    CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{printf("%.f\n", 100 - $1)}')
    echo -e "$TIEMPO\t$MEMORIA$DISCO$CPU"
    if [ $CPU -gt 60 ]; then
      CONTADOR=$(( $CONTADOR + 1  ))
      if [ $CONTADOR -ge 3 ]; then
        exit 1
      fi
    else
      CONTADOR=0
    fi
    sleep 3
    echo "$CONTADOR"
done
