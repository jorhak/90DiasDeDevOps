#!/bin/bash
#Verifica si un fichero existe, en la ruta donde nos encontramos

ARCHIVO="hola.sh"

if [ -f "$ARCHIVO" ]; then
  echo "El archivo $ARCHIVO existe"
else
  echo "No encontré el archivo $ARCHIVO"
fi
