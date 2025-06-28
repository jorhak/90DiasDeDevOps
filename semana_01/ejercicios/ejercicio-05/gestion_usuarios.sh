#!/bin/bash
#Creamos un usuario, previamente se verifica que se pase
#un argumento 

source ./funciones.sh

if [[ $# -ne 1 ]]; then
  echo "Uso: $0 <nombre_usuario>"
  exit 1
fi

crear_usuario "$1"
