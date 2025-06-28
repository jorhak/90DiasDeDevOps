#!/bin/bash
#Bucle While

contador=1
while [ $contador -le 3 ]; do
  echo "Contador: $contador"
  ((contador++))
done
