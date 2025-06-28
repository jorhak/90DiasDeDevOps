#!/bin/bash
#Desplegar aplicacion que esta hecha en NodeJS y para levantar
#las apps utilizaremos PM2

LOG_FILE="node_pm2.log"

instalar_dependencias(){
  echo "$(date +%Y%m%d\ %H%M%S) Install:::Instalando dependencias" >> "$LOG_FILE"
  sudo apt update -y
  sudo apt install -y curl wget git nginx
  sudo systemctl enable nginx >> "$LOG_FILE" 2>&1
  sudo systemctl start nginx  >> "$LOG_FILE" 2>&1
}

configurar_nginx(){
  echo "$(date +%Y%m%d\ %H%M%S) Config:::Configurando Nginx..." >> "$LOG_FILE"
    #Eliminar la configuracion por defecto
  sudo rm -f /etc/nginx/sites-enabled/default

  #Usar 127.0.0.1:8000 en lugar de 0.0.0.0:8000
  sudo tee /etc/nginx/sites-available/ecommerce > /dev/null <<EOF
  server {
    listen 80;
    server_name _;

    location / {
      proxy_pass http://127.0.0.1:3000;
      proxy_set_header Host \$host;
      proxy_set_header X-Real-IP \$remote_addr;
      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
      proxy_set_header X-Forwarded-Proto \$scheme;
      proxy_redirect off;
    }

    access_log /var/log/nginx/ecommerce_access.log;
    error_log /var/log/nginx/ecommerce_error.log;
  }
EOF
  sudo ln -sf /etc/nginx/sites-available/ecommerce /etc/nginx/sites-enabled/
  sudo nginx -t >> "$LOG_FILE" 2>&1 && sudo systemctl reload nginx

}

instalar_apps(){
  APPS=("nvm" "node" "pm2")
  for APP in ${APPS[@]}; do
    case $APP in
      nvm)
        # Download and install nvm:
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        # in lieu of restarting the shell
        \. "$HOME/.nvm/nvm.sh"
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

        nvm -v
        echo "$(date +%Y%m%d\ %H%M%S) App:::Instalacion de NVM exitosa" >> "$LOG_FILE"
      ;;
      node)
        # Download and install Node.js:
        nvm install 22

        # Verify the Node.js version:
        node -v

        # Verify npm version:
        npm -v

        # Verify npx version:
        npx -v
        echo "$(date +%Y%m%d\ %H%M%S) App:::Instalacion de: node, npm, npx exitosa" >> "$LOG_FILE"
      ;;
      pm2)
        npm install pm2 -g
        echo "$(date +%Y%m%d\ %H%M%S) App:::Instalacion de PM2 exitosa" >> "$LOG_FILE"
      ;;
    esac
  done
}

verificar_apps(){
  APPS=("nvm" "node" "pm2")
  for APP in ${APPS[@]}; do
    $APP -v
    if [[ $?==0 ]]; then
      SUCCESS="$(date +%Y%m%d\ %H%M%S) Check:::La app $APP esta instalado."
      echo "$SUCCESS" >> "$LOG_FILE"
    else
      FAIL="$(date +%Y%m%d\ %H%M%S) Check:::La app $APP no esta instalado"
      echo "$FAIL" >> "$LOG_FILE"
    fi
  done
}

clonar_repo(){
  echo "$(date +%Y%m%d\ %H%M%S) Clone:::Clonando Repositorio" >> "$LOG_FILE"
  git clone -b ecommerce-ms https://github.com/roxsross/devops-static-web.git
  cd devops-static-web
}

instalacion_dependencias_ms(){
  cd frontend
  npm install & >> ../../"$LOG_FILE"
  pid1=$!
  wait $pid1
  echo "$(date +%Y%m%d\ %H%M%S) Task1:::Inicializando FrontEnd" >> ../../"$LOG_FILE"
  pm2 start server.js --name "frontend"
  cd ../merchandise
  npm install & >> ../../"$LOG_FILE"
  pid1=$!
  wait $pid1
  echo "$(date +%Y%m%d\ %H%M%S) Task2:::Inicializando Merchandise" >> ../../"$LOG_FILE"
  pm2 start server.js --name "merchandise"
  cd ../products
  npm install & >> ../../"$LOG_FILE"
  pid1=$!
  wait $pid1
  echo "$(date +%Y%m%d\ %H%M%S) Task3:::Inicializando Products" >> ../../"$LOG_FILE"
  pm2 start server.js --name "products"
  cd ../shopping-cart
  npm install & >> ../../"$LOG_FILE"
  pid1=$!
  wait $pid1
  echo "$(date +%Y%m%d\ %H%M%S) Task4:::Inicializando Shopping Cart" >> ../../"$LOG_FILE"
  pm2 start server.js --name "shoping-cart"
  cd ..
}

main(){
  instalar_dependencias
  instalar_apps
  verificar_apps
  clonar_repo
  instalacion_dependencias_ms
  configurar_nginx
}

main
