#!/bin/bash

echo "Creando contenedor my-custom"
docker run -d --name my-custom ubuntu bash -c 'contador=0; while  true; do contador=$(( $contador+1 )); echo "$contador $(date +'%T')" >> mensajes.txt; sleep 5; done'

sleep 120

echo "Copiando fichero mensajes desde el contenedor al host"
docker cp my-custom:mensajes.txt .

echo "Obtener IP y nombre de la imagen utilizada"
IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my-custom)
IMAGE=$(docker inspect --format='{{.Config.Image}}' my-custom)

echo "IP del contenedor: $IP y imagen utilizada: $IMAGE"

echo "Procesos activos del contenedor"
docker top my-custom

echo "Eliminando contenedor my-custom"
docker rm -f my-custom
