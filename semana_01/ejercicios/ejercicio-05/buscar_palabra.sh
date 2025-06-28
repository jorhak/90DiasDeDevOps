#!/bin/bash
#Buscamos contenido dentro de un fichero
#Ingresamos dos parametros: el fichero y la palabra a buscar

FICHERO=$1
PALABRA_BUSCAR=$2

grep "$PALABRA_BUSCAR" "$FICHERO"

if [ $? -eq 0 ]; then
  echo "Encontrado!"
else
  echo "No encontrado."
fi
