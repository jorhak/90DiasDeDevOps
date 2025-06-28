#!/bin/bash
#Funcion que nos crea un usuario y verifica si existe
#se lo pasa por parametro 

crear_usuario() {
  if id "$1" &>/dev/null; then
    echo "El usuario $1 ya existe" 
  else
    sudo useradd "$1"
    echo "Usuario $1 creado." >> usuario.log
    echo "Usuario $1 creado."
  fi
}
