#!/bin/bash
#Cuestionario donde pregunta: nombre, edad y color favorito
#Lo que hacemos es devolver un mensaje personalizado

read -p "Cual es tu nombre? " NOMBRE
read -p "Cual es tu edad? " EDAD
read -p "Cual es tu color favorito? " COLOR

case $COLOR in
  rojo)
     NEW_COLOR=31
     NEW_STYLE=1
     NEW_EMOJI=🚀♥️
   ;;
  verde)
     NEW_COLOR=32
     NEW_STYLE=4
     NEW_EMOJI=⛳ 💵
   ;;
  amarillo)
     NEW_COLOR=33
     NEW_STYLE=5
     NEW_EMOJI=🍔🍟
   ;;
  azul)
     NEW_COLOR=34
     NEW_STYLE=7
     NEW_EMOJI=🌠
   ;;
  magenta)
     NEW_COLOR=35
     NEW_STYLE=1
     NEW_EMOJI=🔯
   ;;
  cian)
     NEW_COLOR=36
     NEW_STYLE=4
     NEW_EMOJI=🔵
   ;;
  blanco)
     NEW_COLOR=37
     NEW_STYLE=5
     NEW_EMOJI=✅
   ;;
esac

echo -e "$NEW_EMOJI Hola \e[${NEW_STYLE};${NEW_COLOR}m$NOMBRE\e[0m bienvenido a 90diasDevOps!!! $NEW_EMOJI"
echo -e "🎉🎉🎉 Usted tiene \e[${NEW_STYLE};${NEW_COLOR}m$EDAD\e[0m años 🎉🎉🎉"
echo -e "Y su color favorito es \e[${NEW_STYLE};${NEW_COLOR}m$COLOR\e[0m"
