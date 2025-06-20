#!/bin/bash
# Instalar Docker
  apt update
  apt install -y docker.io
  systemctl enable --now docker
  
  # Instalar kubectl
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  
  # Verificar
  docker --version && kubectl version --client
