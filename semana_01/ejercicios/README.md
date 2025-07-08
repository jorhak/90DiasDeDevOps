# Dia 1/90
## Que es DevOps❔
 Es la colaboracion de los equipos de desarrollo y operaciones que nos permite colaborar, compartir y automatizar las tareas repetitivas.
 DevOps es una cultura que busca las mejores practicas en desarrollo de software y en las operaciones para su despliegue.

 ## 🛠️Herramientas

| Herramientas conocidas | Herramientas nuevas |
| :--- | :--- |
| Git | Prometheus |
| GitHub | Grafana |
| Docker | ArgoCD |
| Kubernetes | Pulumi |
| Jenkins |  |
| OpenShift |  |
| Terraform |  |

## 🖥️Comandos de Linux

Muestra que OS tenemos, version del fireware y la arquitectura
```
uname -a
```
Muestra el usuario con el que ingresamos
```
whoami
```
Nos indica en que directorio estamos ubicados en ese instante
```
pwd
```
Muestra en el contenido en formato largo, los directorios ocultos y en formato legible para el humano
```
ls -lah
```
Creamos un directorio
```
mkdir devops-d1
```
Nos dirigimos al directorio
```
cd devops-d1
```
Nos permite asignar el contenido a un fichero
```
echo "Hola DevOps" > hola.txt
```
Mostrar el contenido del fichero
```
cat hola.txt
```

## 🎯Desafio
__¿Cuánto tiempo lleva encendido tu sistema?__
    up 5 hours, 56 minutes
__¿Qué procesos están consumiendo más recursos?__
    Discord, Firefox
__¿Cuánta memoria disponible tenés?__
    459Mi
### Ejecucion
![Screenshot comandos](recursos/images/dia1.png)
![Screenshot desafio](recursos/images/desafio1.png)

# Dia 2/90

# 🖥️Comandos

Muestra el usuario con el que ingreso.

```
whoami
```

Muestra el directorio donde se encuentra en ese momento.

```
pwd
```

Muestra una lista de los ficheros y directorios del directorio de donde se ejecuto el comando, con el formato que lo muestra todo, muestra los directorios ocultos y en formato que sea legible para los humanos.

```
ls -lah
```

Muestra en una lista todas las particiones, en formato que sea legible para los humanos y el tipo de particion.

```
df -hT
```

Muestra la hora actual, hace cuanto fue encendido el equipo, los usuarios y el promedio de encendido.

```
uptime
```

Nos cambia de directorio actual al directorio __/__ (raiz)

```
cd /
```

Muestra en una lista los ficheros y directorios del directorio donde se encuentra. Solo muestra los nombres no es como el anterior comando que mostraba mas caracteristicas.

```
ls
```

Es la combinacion de los dos comandos previos, nos cambiamos al directorio __/etc__ y mostramos los ficheros y directorios de __/etc__.

```
cd /etc && ls
```

Hace lo mismo que el comando anterior solo que en esta ocacion nos dirigimos al directorio __/home__ y mostramos los ficheros y directorios de __/home__.

```
cd /home && ls
```

### 🎯Reto de comprension

__¿Qué hace este comando?__

```
chmod u=rwx,g=rx,o= hola.txt
```

Le esta cambiando los permisos:
- Al __usuario__ le esta dando todos los permisos: lectura, escritura y ejecucion.
- Al __grupo__ le da los permisos de lectura y ejecucion.
- A __otros__ no le da ningun permiso.

# Dia 3/90

## Vagrant
Vagrant nos ayuda al aprovisionamiento de VM para realizar nuestros laboratorios
facilitando el despliegue de nuestra arquitectura y las dependencias que son 
requeridas para nuestro laboratorio.

### Posibles errores
1. Uno de los posibles errors es que no tengamos habilitado VM en la Bios.\
   __Solucion__: Entrar a la Bios y habilitar la VM
2. Es el rango de las IP\
   __Solucion__: Cambiar el rango de IP

# Dia 4/90

## Git y GitHub

Vamos a realizar los ejercicios de la pagina.

### Ejercicio 1
Lo que vimos fue la creacion de un repositorio y subirlo a la plataforma GitHub.
Como estoy utilizando SSH para conectarme debo ejecutar previamente los comandos:
```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_MI_LLAVE_PRIVADA
```

id_MI_LLAVE_PRIVADA es la que crea para poder conectarme a la plataforma GitHub.

### Ejercicio 2
Realizamos un __fork__ al repositorio de Roxs y los sincronizamos.\
Nos creamos una rama y agregamos un fichero luego lo comiteamos y finalmente
le hicimos un merge en la rama main y borramos la rama tanto en local como de la
plataforma.

#### Reset
Agrege un fichero y lo comitie, y realice la eliminacion tanto del commit y manteniendo los cambios,
y tambien la eliminacion del commit y descartar los cambios. El primero solo elimina el commit y el
fichero con los cambios lo seguimos teniendo en el __workdirectory__. En el segundo escenario se 
elimina el commit y nos cambia al commit previo, y quita los ficheros del __workdirectory__ (los elimina
esto porque en el commit previo no estaban esos ficheros).

#### Revert
Agrege un fichero por commit realice un __revert__ en donde al ejecurar este comando se mantienen los
cambios pero se borra lo que se tenia en ese commit al que retornanmos, es decir, en este commit yo 
tengo un fichero que se agrego y despues realice dos commit y en cada commit agrege un fichero, y 
lo que hace el comando __revert__ es volver a ese commit pero sin el cambio de ese commit y se mantiene 
los ficheros de los otros dos commit.
En otras palabras los ficheros, directorios que se tenian en ese commit ya no van a estar.

#### Rebase
Me cambie a la rama __feature-branch__ en donde tengo solo un cambio (un fichero nuevo) y ejecute el
comando __rebase__, lo que hace este comando traer todo el historial de main a la rama __feature-branch__.

#### Pull Request
Cree un __PRs__ desde la terminal agrege la herramiente __GitHub CLI__ para poder crear Issue, PRs.
Lo que hice fue cambiar de rama __feature-branch__ y cree el ficheros y los subi al repositorio
luego cree un __PRs__ desde la terminal y luego me cambie a la rama __main__ en donde actualice la rama
main y finalmente ejecute el __merge__ y de esta forma se cierra el PRs.

#### Resolucion de conflictos
Creamos un nuevo repositorio local, en donde creamos un fichero en la rama __main__ y movemos al area
de stage, luego creamos otra rama __feature_branch__ en donde modificamos el fichero y lo movemos al area
de stage, ahora nos cambiamos a la rama __main__ y modificamos el fichero y lo movemos al area de stage.
Y ahora realizamos un __merge__ de la rama __feature_branch__ en donde vamos a tener un conflicto ya que en 
ambas ramas tenemos modificada la misma linea, lo que debemos hacer es aceptar el cambio de __main__ o de 
__feature_branch__, incluso podemos mantener ambos eso lo definira el desarrolador.

#### Git Stash
Lo que realiza este comando es si realizamos cambios dentro de nuestro proyecto y ejecutamos este 
comando lo que hace es que todos los cambios los guarda en una __pila__ y deja el area de trabajo 
sin eso cambios, ahora para volver a tener los cambios que estan en la pila se debe agregar el flag
__pop__ este saca el ultimo cambio que se le agrego a la __pila__.

#### Tags de Version
Se ejecuto el comando __tag__ y se pudo apreciar que lo que hace es comprimir todo el repositorio en formato .zip y .tar.gz
Eso si ya no tiene el historial (.git).

#### Editar commits pasados
El primer comando __--amend -n__ cambia el ultimo commit. Debemos tener en cuenta si este ya fue pusheado debemos forzar el push para que se actualice en GitHub.

El segundo comando __rebase -i HEAD~3__ lo que hace este comando es abrir el editor y debemos reemplazar pick por: reword, edit, squash, drop.

# Dia 5/90

## Automatizá el Despliegue de la Aplicación Flask 📚"Book Library"📚 con Nginx y Gunicorn

Para la ejecucion de esta App se debe ejecutar:

```
chmod +x desplegar_app.sh
./desplegar_app.sh
```

Cabe recalcar que hubo un problema de permisos ya que 
lo estamos ejecutando desde la ruta donde se encuentra 
la aplicacion web es por eso que se debio dar permiso
al directorio

```
chmod o+rx /home/<user>
```

Ahora debe ir a su navegador y escribir su IP.

## 🚀 Desafío: Despliegue de Aplicaciones con PM2

Para le ejecucion de esta App se debe ejecutar:
```
chmod +x node_pm2.sh
./node_pm2.sh
```

Cuando termine de ejecurase debemos cerrar la terminal y
volver a abrila de esta manera ya vamos a poder ejecuar los comandos:
```
nvm -v
node -v
npm -v
npx -v
pm2 -v
```

Ahora debe ir a su navegador y escribir su IP.

# Dia 6/90

## 📌 Tarea Práctica

Requisitos
1. Tener un servidor 
2. Equipo local

El equipo local viene a ser nuestra maquina que tiene instalado Ansible y el servidor es al que le vamos hacer la configuracion y/o instalacion de dependencias.
En el equipo local debemos crear las llaves publicas y privadas.
El servidor tiene como usuario: simon y una contrasena:123.

### Crear llaves para SSH
Cuando se crean las llaves para SSH se crean dos: llave privada y llave publica.

```
ssh-keygen -t rsa -b 4096
```

Damos Enter y nos preguntara en donde lo deseamos guardar por defecto lo hace en ~/.ssh/, sin embargo podemos elegir cambiar el lugar. Nosotros para fines practicos lo vamos a guardar de la siguiente manera:

```
/home/$USER/.ssh/id_<nombre_descriptivo>
```

### Copiar llave publica al servidor
Nosotros no hemos hecho ningun tipo de configuracion en el servidor para SSH.
Por primera ves vamos a ingresar con el usuario y contrasena. 
Una ves terminada la configuracion vamos acceder por las llaves.

```
ssh simon@192.168.56.35
```

Abrimos otra terminal y vamos a copiar la llave publica en el servidor

```
ssh-copy-id -i ~/.ssh/id_<nombre_descriptivo>.pub simon@192.168.56.35
```

### Configurar Servidor para acceder por llaves publicas
Como ya ingresamos previamente con el usuario y la contrasena vamos a editar el fichero /etc/ssh/sshd_config.
Antes vamos a sacar un backup de este fichero.

```
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
```

Ahora vamos a editar el fichero 

```
sudo nano /etc/ssh/sshd_config
```

Y debe tener descomentada estas lineas

```
Port 4455
PasswordAuthentication no
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
PermitRootLogin no
```

Guardamos y salimos del servidor.

### Reiniciar servicio SSH

```
sudo systemctl status ssh
sudo systemctl restart ssh
```

### Verificar acceso
Ahora vamos a ingresar como lo hicimos previamente solo que esta vez no nos pedira la contrasena. Esto lo hacemos desde nuestro equipo local.

```
ssh -p 4455 simon@192.168.56.35
```

Y estamos en el servidor a traves de las llaves que generamos.
Hasta aqui ya tenemos la mitad de nuestra tarea practica.

### Ejecutar playbook.yml
Al momento de ejecuar el playbook.yml tube un inconveniente que era que necesitaba la contrasena del usuario para ejecutar los comando en donde se necesitaba el permiso de **sudo**, para resolver este inconveniente agrege la contrasena del usuario a vault para que tomo la contrasena desde ahi y no tener este incoveniente.

#### Creacion de vault
Vamos crear un boveda para nuestra contrasena de usuario del servidor y pueda ejecutar los comandos con privilegios de **sudo**.

```
ansible-vault create ~/.ansible/vault_pass.yml
```

Ahora nos va pedir que ingresemos una contrasena para esta boveda. Y dentro vamos a agregar:

```
ansible_sudo_pass: contrasena_usuario_simon
```

### Agregar variables desde la boveda
Vamos a agregar en nuestro playbook.yml el fichero que contiene la contrasena:

```
---
- name: Instalacion de Nginx y mostrar pagiana personalizada
  hosts: webservers
  become: yes
  vars_files:
    - ~/.ansible/vault_pass.yml # Ruta a tu archivo de bóveda
```

De esta forma ya no vamos a tener problemas con ejecutar los comandos que requieren permisos de **sudo**.

### Ejecutar playbook.yml
Ahora vamos a ejecutar el **playbook.yml** al que le vamos agregar un flag en el comando:

```
ansible-playbook playbook/playbook.yml --ask-vault-pass
```

Nos va pedir la contrasena de la boveda.
De esta forma ya tenemos terminada la **Tarea practica**.


## 🚀 Desplegando StartBootstrap Freelancer con Vagrant y Ansible
Aqui cabe mencionar algo curioso en el anterior ejercicio tenemos _inventory_ que son los diferentes ambientes en donde vamos a ejecutar las configuracion y/o instalacion de dependencias. Aqui en este ejercicio no aplica este concepto ya que le estamos pasando la configuracion para que se ejecute en esta **VM** de **Vagrant**. En el fichero playbook.yml solo basta que tenga:

```
---
- name: Despliegue Fullstack Freelancer
  hosts: all  ### Con esto no vamos a tener problemas
  become: yes
```

### Cosas nuevas
Algo curioso que note es que ya existe estructuras definidas para que escenario posible y si no lo conoces simplemente utilizas el modulo _shell_.

1. En la tarea **Limpiar archivos temporales** \
   Aqui no entendia el {{ item }}, sin embargo en _loop_ es de donde saca {{ item }} recorre el _loop_ y que en _state: absent_ esto significa eliminar.
2. Handlers y Notify \
   Estos dos trabajan juntos, esto es mas o menos como una funcion en donde si _notify: Restart Nginx_ se va a ejecutar la tarea del _handlers_ que tenga ese nombre.

Para la ejecucion solo segui los pasos que se tenia.

## 🚀 Desafío Ansible - Día 6
Para este desafio intente utilizar _inventory_ en donde coloque:

inventories/develop/hosts
```
[webservers]
127.0.0.1 ansible_user=vagrant ansible_port=2222 ansible_ssh_private_key_file=../../vagrant/machines/default/virtualbox/private_key
```

playbook/playbook.yml
```
---
- name: Instalacion de Nginx y mostrar pagina personalizada
  hosts: webservers
  become: yes
```

Pero nada de esto funciono tube que dejarlo como en el anterior ejercicio

```
---
- name: Instalacion de Nginx y mostrar pagina personalizada
  hosts: all
  become: yes
```

De esta manera ya no tenia errores.

### Roles
Los _roles_ son mas o menos como funciones que indican que tareas se van a ejecutar y estas son llamadas en el _playbook.yml_ 

### Crear Roles
Al inicio yo cree los directorios, sin embargo, estos al momento de llamarlos en el _playbook.yml_ estos no eran encontrados voy a mostrar las dos formas: Mal y Bien.

Mal
```
  roles:
    - devops
    - firewall
    - nginx
```

Bien
```
  roles:
    - roles/devops
    - roles/firewall
    - roles/nginx
```

Ahora si ya me los encontraba, cabe mencionar que tube que ejecutar los comandos para su creacion y no tener duda alguna.

```
ansible-galaxy init roles/devops
ansible-galaxy init roles/firewall
ansible-galaxy init roles/nginx
```

Cabe mencionar que se debe tener mucho cuidado con el formato de fichero _.yml_ ya que por esto tuve varios errores.

Una ves teniendo todo esto procedemos a la ejecucion con **Vagrant**, esto lo hacemos como en el anterior ejercicio.

```
vagrant up
```

