#!/bin/bash
#Condicional if, imprime un mensaje si nuestra respuesta es si de lo
#contrario imprime otro mensaje

read -p "¿Tenés sed? (si/no): " RESPUESTA

if [ "$RESPUESTA" == "si" ]; then
  echo "Andá por un cafecito ☕"
else
  echo "Seguimos con DevOps 🚀"
fi
