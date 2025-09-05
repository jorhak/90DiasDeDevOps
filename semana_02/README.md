# Dia 8/90

## Que es docker?
Docker es un contenedor que consiste en que toda aplicacion tenga lo necesario para poder ejecutarse en ese contenedor: tiene las dependencias, variables de entorno, codigo. Lo unico que se debe hacer es ejecutarlo y tendras tu aplicacion corriendo.

## Instalacion de Docker
Para su instalacion podemos seguir la documentacion [Docker Engine](https://docs.docker.com/engine/), esto nos permitira instalar _Docker_ en nuestra ternimal, ahora si deseamos que se instale en modo escritorio debemos ir [Docker Desktop](https://docs.docker.com/get-started/get-docker/) y seguir la documentacion.

## WorkShop
Siguiendo la guia del _WorkShop de Docker_ aprendimos sobre los siguientes temas:

### Crear una imagen
Creamos nuestro primer _Dockerfile_ y previamente descargamos el proyecto al que se le va crear una imagen. Esto consiste en que vamos a utilizar una imagen base para crear nuestra imagen con nuestra aplicacion.

Dockerfile
```
FROM node:lts-alpine
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn run install --production
COPY . .
CMD ["node", "src/index.js"]
```

Ejecutar Dockerfile
```
docker build -t getting-started .
```
No debemos olvidar el punto (".") al final que indica que se ejecute el Dockerfile donde nos encontramos.

### Ejecutar un contendor
Ejecutamos nuestro contenedor con el comando basico
```
docker run -d -p 127.0.0.1:3000:3000 getting-started
```

### Crear cuenta de Docker
Nos creamos una cuenta para que se puedan subir nuestras imagenes y asi poder tener versionada nuestras imagenes.
Para ello debemos dirigirnos a [Docker Hub](https://hub.docker.com).

### Compartir nuestra imagen
Ahora que ya contamos con nuestro usuario y contrasena en nuestro repositorio de imagenes lo que debemos hacer es vincularnos
```
docker login
```
Nos va pedir nuestro usuario y contrasena debemos ingresarlas y de esta forma ya estaremos vinculados con nuestro repositorio.

Como ya tenemos una imagen creada esta va ser la que vamos a utilizar para subirla a nuestro repositorio, sin embargo, esta debe taggearse, es decir, que el nombre que tiene no nos sirve para este proposito **getting-started** lo que debemos hacer es agregarle el prefijo de nuestro usuario para que sepa a que repositorio lo va ha subir **USUARIO/getting-started**, debemos reemplazar _USUARIO_ por nuestro usuario.
Ahora lo vamos a taggear y publicar
```
docker tag getting-started USUARIO/getting-started
docker push USUARIO/getting-started
```

Ahora debemos ir a nuestro repositorio de imagenes y tendremos nuestra primer imagen.

### Volumenes
Pudimos ver que hay dos tipos de volumenes
- volume
- bind mount

| Tipo | Diferencias |
| ------ | ------------- |
|volume| Este tipo de volumen se crea en un directorio especial al que solo podemos acceder con permisos de super usuario. Este directorio tendra lo que vamos compartir con el contenedor que nos permitira guardar los datos del contenedor. |
|bind mount| Es una ruta en nuestro host que deseamos que comparta con el contenedor para cuando este se elimine los datos siguan persistentes, es decir, que si volvemos a crear un contenedor va tomar lo que tenemos en ese directorio, lo que nos perminte guardar los datos.|

#### Crear un volumen tipo volume
Los volumenes son para que no perdamos los datos de nuestro contenedor ya que estos son efimeros. Lo que vamos hacer es crear un volumen para usarlo en nuestro contenedor.
```
docker volume create todo-db
docker run -dp 127.0.0.1:3000:3000 \
--mount type=volume,src=todo-db,target=/etc/todos \
--name to_do \
getting-started
```
De esta forma tenemos la persistencia de nuestros datos en ese volumen.

Para saber cual es el directorio donde se encuentra nuestro volumen debemos ejecutar.
```
docker volume inspect todo-db
```

#### Crear un volumen tipo bind mount
Este volumen va apuntar a una ruta de nuestro _host_ para esta caso lo vamos a utilizar el proyecto del [WorkShop](https://github.com/docker/getting-started-app/tree/main) 
```
git clone https://github.com/docker/getting-started-app.git
```

Una vez tengamos el codigo lo que vamos hacer es utilizar la ruta como nuestro volumen **~/getting-started-app**, vamos a utilizar la imagen de **node** esta imagen tiene todas la dependencias necesarias para poder ejecutar nuestra aplicacion, sin embargo, es lo unico que tiene es por ese motivo que vamos a utilizar nuestro volumen para que cuando se cree el contenedor este tenga nuestro codigo y de esta manera lo que se modifique en este volumen se va ver reflejado en nuestro contenedor.
```
cd gettign-started-app/
docker run -dp 127.0.0.1:3000:3000 \
-w /app \
--mount type=bind,src="$(pwd)",target=/app\
--name to-do \
node:18-alpine \
sh -c "yarn install && yarn run dev"
```

Flags \
-w: Esto especifica el directorio de trabajo en donde nos vamos a encontrar ubicados. \
"$(pwd)": Esto especifica en donde nos encontramos ubicados en ese momente un nuestro caso es **/home/$USER/getting-started-app** y todo lo que hay en ese directorio lo va tener nuestro contendor en la ruta **/app**. \
Las imagenes **alpine** no utilizan _bash_ sino _sh_ para la ejecucion de comandos.
Ahora si modificamos **src/static/js/app.js** o cualquier otro fichero desde nuestro host esto se vera refejado en nuestra aplicacion.

### Multi-Contenedores
Consiste que dos o mas contenedores se puedan conectar para poder tranferir datos entre ellos y para ello tenemos la red (**network**) que nos permite conectar contenedores.
Utilizando el proyecto del [WorkShop](https://github.com/docker/getting-started-app/tree/main) el mismo que necesita de una base de datos para que los datos sean guardados.
Ahora si creamos un contendero para la aplicacion y la base de datos estos no se van a conocer ya estos se van a crea con redes diferentes y para ello vamos a crear una red para que ambos contenedores estando en la misma red se puedan comunicar.

Red
```
docker network create todo-app
```

MySQL

```
docker run -d \
--network todo-app network-alias mysql \
-v todo-mysql-app:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=secret \
-e MYSQL_DATABASE=todos \
mysql:8.0
```

Aqui podemos ver una variacion de un volumen tipo volume, que no necesita que se cree previamene el volumen sino que el lo crea y utiliza al mismo tiempo.

Aplicacion
```
docker run -dp 127.0.0.1:3000:3000 \
-w /app -v "$(pwd)":/app
--name to_do \
--network todo-app \
-e MYSQL_HOST=mysql \
-e MYSQL_USER=root \
-e MYSQL_PASSWORD=secret \
-e MYSQL_DB=todos \
node:18-alpine
sh -c "yarn install && yarn run dev"
```

Aqui podemos ver una variacion de como crear un bind mount y como asignar variables de entorno en el contenedor.

Cabe recalcar que hay un orden cuando vamos a crear un entorno Multi-contenedor, en este caso primero se crea: network, base de datos, aplicacion.

### Docker Compose
Docker Compose nos facilita el Multi-Container, ya que este se maneja de forma declarativa en un fichero **.yml** lo cual facilita su matenimiento. Como vimos previamente utilizabamos en modo interactivo en donde tenemos que estar ejecutando todos los comandos necesario para que nuestros contenedores se comuniquen, ahora con en fichero **compose.yml** este refleja lo que haciamos por comando en una sentencia que se sigue para levantar nuestros contenedores.
Vamos a realizar lo mismo pero ahora de forma declarativa.

compose.yml
```
services:
  app:
    image: node:18-alpine
    command: sh -c "yarn install && yarn run dev"
    ports:
      - 127.0.0.1:3000:3000
    working_dir: /app
    volumes:
      - ./:/app
    environment:
      MYSQL_HOST: mysql
      MYSQL_USER: root
      MYSQL_PASSWORD: secret
      MYSQL_DB: todos

  mysql:
    image: mysql:8.0
    volumes:
      - todo-mysql-data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: secret
      MYSQL_DATABASE: todos

volumes:
  todo-mysql-data:
```

Ejecutar compose.yml
```
docker compose up -d
```

Aqui podemos tener un inconveniente ya que ambos contenedores van a comenzar a crearse lo que quiere decir que: \
Si primero termina de crearse la aplicacion este no va poder conectarse a la base de datos. \
Si primero termina de crearse la base de datos y despues la aplicacion esta se va poder conectar.
Para solucionar este inconveniente se debe especificar que servicio depende de otro servicio para que espere a que el servicio este creado para que asi comience con su creacion.

Ver los logs
```
docker compose logs -f
```

Detener compose.yml
```
docker compose down
```

### Capas de imagenes

Mal
```
FROM node:lts-alpine
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]
```

Bien
```
FROM node:lts-alpine
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production
COPY . .
CMD ["node", "src/index.js"]
```

Ahora podemos comparar las capas que se crean para cada imagen creamos la imagen.
```
docker build -t getting-started .
```

Ver la cantidad de capas
```
docker image history getting-started
```

Primero creamos la imagen que esta Mal y vemos la cantidad de capas y luego creamos la imagen que esta Bien y comparamos la cantidad de capas.
De esta forma podemos validar la optimizacion cuando creamos nuestras imagenes.

### Multi-Stage Build
Esto lo que quiere decir que que vamos a tener mas de dos etapas para construir una imagen, vamos a utilizar una analogia para la creacion de un pantalon de algodon.
Primero necesitamos el algodon lo que quiere decir que vamos a producir algodon.
Segundo procesamos el algodon para hacerlo tela jean.
Tercero vamos a pasar a la fabrica para la creacion de nuestros pantalones.
Finalmente tenemos nuestro pantalon y tubimos tres etapas de construccion para crear un pantalon.
Lo mismo pasa para nuestras aplicaciones vamos a dar dos ejemplos: \
1. Una aplicacion que esta hecha en **React Native** esta tiene la etapa de _dev_, _build_ cuando utilizamos **build** esta nos crea un directorio build/ o dist/ esto dependiendo de la version o configuracion. Ahora lo unico que necesitamos es el directorio build/ o dist/ para que nuestra aplicacion se ejecute y ya no todos los otros directorios.
2. Para una aplicacion hecha en **Java** esta crea un directorio target/ en donde esta el binario .jar o .war lo cual lo conviente en nuestro **build** y ahora ya no necesitamos todo el codigo para poder utilizar nuestra aplicacion.

Para eso tenes el multi-stage que consite en obtener de la primer etapa el build, en esta etapa utilizamos una imagen y para la segunda etapa otra imagenen para su ejecucion, por ejemplo:

Java
```
FROM maven AS build
WORKDIR /app
COPY . .
RUN mvn package

FROM tomcat
COPY --from=build /app/target/file.war /usr/local/tomcat/webapps 
```

React Native
```
FROM node:lts AS build
WORKDIR /app
COPY package* yarn.lock ./
RUN yarn install
COPY public ./public
COPY src ./src
RUN yarn run build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
```

# Dia 9/90

## Verificar que Docker esta instalado
```
docker --version
```

## Descargar una imagen
```
docker pull hello-world
```

## Ejecutar contenedor
```
docker run hello-world
```

## Levantar servidor web Nginx
Vamos a tomar este contenedor como ejemplo para los siguientes comandos

### Descargar la imagen
```
docker pull nginx
```

### Ejecutar contenedor con Nginx
```
docker run -d -p 8080:80 --name web-nginx nginx
```

### Veriricar que  se esta ejecutando
Vamos a nuestro navegador y escribimos localhost o 127.0.0.1

## Comandos
Comandos para gestinar un contenedor

### Listar contenedores en ejecucion
```
docker ps
```

### Listar contenedores en activos e inactivos
```
docker ps -a
```

### Detener contenedor
```
docker stop web-nginx
```

### Eliminar contenedor
```
docker rm web-nginx
```

### Eliminar todos los contenedores inactivos
```
docker container prune
```

## Contenedores interactivos
Vamos a crear un contenedor y vamos a observar su comportamiento

### Crear contenedor como imagen base ubuntu
```
docker run -it --name contenedor1 ubuntu bash
```

**-it**: Nos permite interactuar con el contenedor desde la terminal. \
**--name**: Le asignamos un nombre el contenedor. \
**bash**: Como podemos interactuar desde la terminal con esto le especificamos que utilice la shell bash.

Para salir del modo interactivo escribimos _exit_.
De esta manera el contenedor va entrar al estado de inactivo para que se encuentre activo de nuevo ejecutamos
```
docker start contenedor1
```

Podemos ejecutar comandos sin entrar al contenedor
```
docker exec contenedor ls -la
```

Una vez activo podemos ingresar al contenedor con
```
docker attach contenedor1
```

### Inspeccionar contenedor
Nos va mostrar la informacion del contenedor en formato json
```
docker inspect contenedor1 
```

### Explorar el historial una imagen
Esto nos mostrara la cantidad de capas que tiene la imagen, esto quiere decir, que nos va mostrar las capas que se necesitaron para crear la imagen.

```
docker history nginx
```

### Copiar del host al contenedor
Primero vamos a levantar nuestro contenedor nginx para fines practicos. Lo que hace el comando es copiar todo lo que hay dentro de **hola/** en el directorio **/var/share/nginx/html/** del contenedor.
```
docker cp hola/. web-ngix:/var/share/nginx/html/
```

### Copiar del contenedor al host
Vamos a suponer que nos encontramos en el directorio **hola/**. Lo cual vamos a copiar index.html en hola/
```
docker cp web-nginx:/var/share/nginx/html/index.html .
```

# Dia 10/90

## Ejecutar en segundo plano
```
docker run -d --name contenedor ubuntu bash -c "while true; do echo hello world; sleep 1; done"
```

- -d: nos permite que se ejecute en segundo plano
- --name: le da un nombre al contenedor
- bash -c: lo que viene luego que nos permite que se ejecuten comandos dentro del contenedor.

## Ver que se esta ejecutando el contenedor
Nos muestra todos los contenedores que se estan ejecutando.
```
docker ps
```

## Ver los logs del contenedor
```
docker logs contenedor
```

## Detener y eliminar el contenedor
No podemos eliminar directamente el contenedor sin antes detenerlo
```
docker stop contenedor
docker rm contenedor
```

## Eliminar contenedor forzosamente
Eliminamos el contenedor sin detenerlo forzamos su eliminacion
```
docker rm -f contenedor
```

## Copiar del host al contenedor
```
docker cp texto.txt contenedor:/tmp
```

## Copiar del contenedor al host
```
docker cp contenedor:/home/root/mi_texto.txt .
```
El punto **.** indica que va copiarlo en donde nos encontremos ubicados en ese momento.

## Ver los procesos que se estan ejecutando dentro del contenedor
```
docker top contenedor
```

## Inspeccionar contenedor
```
docker inspect contenedor
```

Tambien podemos filtar lo que nos de el **inspect**

### ID container
```
docker inspect --format='{{.Id}}' hora-container2
```

### Imagen usada
```
docker inspect --format='{{.Config.Image}}' hora-container2
```

### Variables de entorno
```
docker container inspect -f '{{range .Config.Env}}{{println .}}{{end}}' hora-container2
```

### Comando ejecutado
```
docker inspect --format='{{range .Config.Cmd}}{{println .}}{{end}}' hora-container2
```

### IP asignada
```
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' hora-container2
```

## Varialbes de entorno
```
docker run -it --name prueba -e USUARIO=prueba ubuntu bash
echo $USUARIO
```

Para ver como agregar las variables de entorno de MySQL o MariaDB debemos fijarmos en la documentacion de [Docker Hub](https://hub.docker.com/_/mysql)
```
docker run -d -p 3306:3306 --name some-mariadb -e MARIADB_ROOT_PASSWORD=my-secret-pw mariadb
```

# Dia 11/90

## Listar las redes
```
docker network ls
```

## Crear y utilizar la red personalizada
```
docker network create mi-red
docker run -d --name backend --network mi-red alpine sleep 3600
docker run -it --rm --network mi-red alpine ping backend
```

## Inspeccionar y eliminar redes
```
docker network inspect mi-red
docker network rm mi-red
```

## Crear y utilizar un volumen
```
docker volume create datos-app
docker run -d --name contenedor-volume -v datos-app:/datos alpine sh -c "whiele true; do date >> datos/fechas.log; sleep 5; done"
docker exec contenedor-volume cat /datos/fechas.log
```

## Ver volumenes
```
docker volume ls
```

## Eliminar volumen
```
docker volume rm datos-app
```

## Bind Mounts
```
mkdir compartir
docker run -it --name con-mount -v $(pwd)/compartir:/datos alpine sh 
```

## Reto
### Crear red
```
docker network create miapp-net
```

### Crear volumen
```
docker volume create vol-db
```

### Crear DB
```
docker run -it --name db \
-e MYSQL_ROOT_PASSWORD=1234 \
-v vol-db:/datos \
--network miapp-net \
mysql bash
```

### Crear API
```
docker run -it --rm --name api \
--network miapp-net \
alpine ping db
```

# Reto MongoDB y MongoExpress
## MongoDB
```
docker run -d --name mongo \
  -e MONGO_INITDB_ROOT_USERNAME=admin \
  -e MONGO_INITDB_ROOT_PASSWORD=secret \
  --network miapp-net \
  mongo
```

## MongoExpress
```
docker run -d --name mongo-express \
  -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin \
  -e ME_CONFIG_MONGODB_ADMINPASSWORD=secret \
  -e ME_CONFIG_MONGODB_SERVER=mongo \
  -p 8081:8081 \
  --network miapp-net \
  mongo-express
```

### Copiar books.json en mongo
```
docker cp books.json mongo:/
```

### Importar books.json
```
docker exec -i mongo mongoimport --username admin --password secret --authenticationDatabase admin --db library --collection books --jsonArray --file /books.json
```

# Dia 12/90

## Simple Nginx
Aqui tube un pequeno problema al momento de mostrar el mensaje ya que no especificaba el formato de caracteres **charset** y esto ocasionaba que se muestre un caracter **Â** que no se encontraba en nuestro codigo por lo que se modifico el codigo.

OLD
```
<h1>¡Hola desde mi imagen Docker personalizada!</h1>
```

NEW
```
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Mi página Docker</title>
</head>
<body>
  <h1>¡Hola desde mi imagen Docker personalizada!</h1>
</body>
</html>
```

De esta forma ya se se apreciaba el caracter **Â**.

## Hello Node
De igual forma pasaba algo similar se tubo que agregar codigo para que ya no se viera el caracter **Â**.

OLD
```
const http = require('http');

const PORT = process.env.PORT || 3000;

http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('¡Hola desde Docker y Node.js!\n');
}).listen(PORT);

console.log(`Servidor corriendo en http://localhost:${PORT}`);
```

NEW
```
const http = require('http');

const PORT = process.env.PORT || 3000;

http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain; charset=UTF-8' });
  res.end('¡Hola desde Docker y Node.js!\n');
}).listen(PORT);

console.log(`Servidor corriendo en http://localhost:${PORT}`);
```

De esta forma ya no se aprecia el caracter **Â**.

## Reto

### Requisitos
Vamos a necesitar librerias de desarrollo de MySQL instaladas para poder compilarse cuando se tengamos que ejecutar **pip install -r requirements.txt**, para ejecuralo en local.

#### Entorno local
```
sudo apt-get update
sudo apt-get install -y default-libmysqlclient-dev build-essential pkg-config python3-dev
```

#### Enviroment
Esto solo para entorno local
```
python -m venv env
source env/bin/activate
python app.py
```

Aqui nos va dar error ya que la base de datos no esta habilitada.
Podemos utilizar el comando que vamos a utilizar, sin embargo, no necesitamos de la red ya que lo vamos a exponer de esta forma le vamos a quitar network y le vamos agregar -p 3306:3306.


Lo primero que vamos hacer es tener nuestra base de datos vamos a ocupar prueba.sql que esta en ejercicio-04.

#### Crear red
```
docker network create conexion
```

#### Crear volumen
```
docker volume create db-maria
```

#### Crear nuestra DB con MariaDB
```
docker run -d --name base-datos-1 \
--network conexion \
-v db-maria:/var/lib/mysql:Z \
-e MARIADB_ROOT_PASSWORD=1234 \
mariadb:10.6.23-jammy

docker cp ../../ejercicio-04/prueba.sql base-datos-1:/tmp/prueba.sql

docker exec -it base-datos-1 bash

cd /tmp

mysql -u root -p

source /tmp/prueba.sql
```

#### Nuestra apliacion que nos va mostrar los datos de la base de datos
Nuestra aplicacion necesita que estemos en la misma red ya que de no estar lo no nos vamos a poder conectar a la base de datos.

##### Crear imagen
```
docker build -t empleados:0.1.0 .
```

##### Ejecutar App
```
docker run -d --name app-1 \
--network conexion \
-p 5001:5000 \
empleados:0.1.0
```


## Reto Avanzado
Vamos a crear una imagen a la cual le vamos a asignar una variable de entorno.

#### Crear imagen
```
docker build -t avanzado:0.1.0 .
```

#### Crear contenedor
```
docker run --rm avanzado:0.1.0
```

# Dia 13/90
Vamos a ver **docker compose** para manejar multi-containers, los que en este caso los vamos a ver como servicios.

## WordPress
Vamos a comenzar con **WordPress** ya que este necesita de una base de datos y va ser algo parecido al lo que vimos anteriormente solo que en esta ocacion lo vamos a tener de forma declarativa y no de forma imperativa.

### Ejecutar docker-compose.yaml
```
docker compose up -d
```

Ahora podemos acceder a **WordPress** desde nuestro navegador y de igual manera a **PHPMYADMIN** para ver la base de datos.
```
localhost:8080
localhost:8081
```

Aqui tube un pequeno inconveniente que wp-db no se iniciaba asi que tube que ejecutar:
```
docker compose restart
```
De esta manera los tres servicios ya se estan ejecutando.

### Bajar servicios
En nuestro caso vamos a bajar los servicios y los volumenes, esto no se debe hacer en produccion para no perder la persistencia de los datos.
```
docker compose down #Solo baja los servicios
docker compose down --volumes #Baja los servicios y elimina los volumenes
```

### NodeJs y MongoDB
Debemos ubicarnos en el directorio **node-mongo-app**
#### Iniciar servicios
```
docker compose up --build -d
```

#### Probar la API

Desde la terminal
```
curl http://localhost:3000
```

Desde el navegador
```
http://localhost:3000
```

#### Verificar la base de datos
```
docker compose exec db mongosh --eval "show dbs"
```

## Persistencia de datos
Vamos a probar que la persistencia de los datos esta bien configurada.
Lo que vamos hacer es detener los servicios y volver a levantarlos.
```
docker compose down && docker compose up -d
```

Vamos a insertar datos en la coleccion
GOOD
```
docker compose exec db mongosh mydb --eval "db.mydb.insertOne({name: 'ejemplo'})"
```

Aqui tuve un error el comando que se tenia antes era:
BAD
```
docker compose exec db mongosh --eval "db.mydb.insertOne({name: 'ejemplo'})"
```

Con este comando estaba insertando en la coleccion por defecto de test y cuando hacia la prueba para ver si se agregaba en la coleccion mydb este no se encontraba, sin embargo, cuando se agrego mydb despues de mongosh esto se soluciono.
Sino especificamos la base de datos este utiliza la test que esta por defecto.
Cuando especifique la base de datos mydb ya con eso se soluciono.

#### Probar la API
Terminal
```
curl http://localhost:3000/api/items
```

Navegador
```
http://localhost:3000/api/items
http://localhost:5173
```

Los detenemos y volvemos a levantarlos
```
docker compose down && docker compose up -d
```

# Dia 14/90
Vamos a crear un multi-containers para el proyecto de votos.
Debemos estar ubicados en la ruta *semana_02/ejercicios/ejercicio-07*

## Clonar repositorio
```
git clone https://github.com/roxsross/roxs-devops-project90.git
cd roxs-devops-project90/roxs-voting-app
```

## Result Dockerfile
Agregamos el Dockerfile en la ruta result/
```
FROM node:22.0.0-alpine3.19
WORKDIR /result
COPY package.json .
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### Variables de entorno para Result
Agregamos las variables de entorno en result/
**No es necesario agregar este fichero para Dockerfile ya que las variables de entorno se las vamos a pasar en el docker-compose, sin embargo pordria ser util si lo ejecutas en local**
.env
```
APP_PORT=3000
DATABESE_HOST=db
DATABASE_USER=postgres
DATABASE_PASSWORD=contrasena
DATABASE_NAME=votos
```

## Vote Dockerfile
Agregamos el Dockerfile en la ruta vote/
```
FROM python:3.14.0rc2-alpine3.21
WORKDIR /vote
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 80
CMD ["python", "app.py"]
```

### Modificar app.py
```
21 port = os.getenv('APP_PORT', 80)
283     app.run(host='0.0.0.0', port=port, debug=True, threaded=True)
```


## Worker Dockerfile
Agregamos el Dockerfile en la ruta worker/
```
FROM node:22.0.0-alpine3.19
WORKDIR /worker
COPY package.json .
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

### Modificar main.js
```
8 const port = process.env.APP_PORT || 3000;

26  host: process.env.REDIS_HOST || null, // Se establecerá dinámicamente
27  port: process.env.REDIS_PORT || 6379,
```

### Variables de entorno para Worker
Agregamos las variables de entorno en la ruta vote/
**No es necesario agregar este fichero para Dockerfile ya que las variables de entorno se las vamos a pasar en el docker-compose, sin embargo pordria ser util si lo ejecutas en local**
.env
```
DATABASE_HOST=db
DATABASE_USER=postgres
DATABASE_PASSWORD=contrasena
DATABASE_NAME=votos
REDIS_HOST=redis
REDIS_PORT=6379
```

## docker-compose
Agregamos el docker-compose.yml en la ruta roxs-voting-app
docker-compose.yml
```
services:
  db:
    image: postgres:${POSTGRES_VERSION}
    container_name: vote-postgres
    environment:
      - POSTGRES_USER=${DATABASE_USER}
      - POSTGRES_PASSWORD=${DATABASE_PASSWORD}
      - POSTGRES_DB=${DATABASE_NAME}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - vote-red
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 10

  redis:
    image: redis:${REDIS_VERSION}
    container_name: vote-redis
    volumes:
      - redis_data:/data
    networks:
      - vote-red

  worker:
    build:
      context: ./worker
      dockerfile: Dockerfile
    image: worker:${WORKER_VERSION}
    container_name: vote-worker 
    environment:
      - DATABASE_HOST=${DATABASE_HOST}
      - DATABASE_USER=${DATABASE_USER}
      - DATABASE_PASSWORD=${DATABASE_PASSWORD}
      - DATABASE_NAME=${DATABASE_NAME}
      - REDIS_HOST=${REDIS_HOST}
      - REDIS_PORT=${REDIS_PORT}
      - APP_PORT=${APP_WORKER_PORT}
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    networks:
      - vote-red
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:${APP_WORKER_PORT}/healthz"]
      interval: 10s
      timeout: 5s
      retries: 5

  result:
    build:
      context: ./result
      dockerfile: Dockerfile
    image: result:${RESULT_VERSION}
    container_name: vote-result
    environment:
      - DATABASE_HOST=${DATABASE_HOST}
      - DATABASE_USER=${DATABASE_USER}
      - DATABASE_PASSWORD=${DATABASE_PASSWORD}
      - DATABASE_NAME=${DATABASE_NAME}
      - APP_PORT=${APP_RESULT_PORT}
    ports:
      - 3000:${APP_RESULT_PORT}
    depends_on:
      db:
        condition: service_healthy
      worker:
        condition: service_healthy
    networks:
      - vote-red
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:${APP_RESULT_PORT}/healthz"]
      interval: 10s
      timeout: 5s
      retries: 5
  
  vote:
    build:
      context: ./vote
      dockerfile: Dockerfile
    image: vote:${VOTE_VERSION}
    container_name: vote-app
    environment:
      - REDIS_HOST=${REDIS_HOST}
      - OPTION_A=${OPTION_A}
      - OPTION_B=${OPTION_B}
      - APP_PORT=${APP_VOTE_PORT}
      - DATABASE_HOST=${DATABASE_HOST}
      - DATABASE_USER=${DATABASE_USER}
      - DATABASE_PASSWORD=${DATABASE_PASSWORD}
      - DATABASE_NAME=${DATABASE_NAME}
    ports:
      - 80:${APP_VOTE_PORT}
    depends_on:
      worker:
        condition: service_healthy
      result:
        condition: service_healthy
    networks:
      - vote-red
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:${APP_VOTE_PORT}/healthz"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
    driver: local
    name: vote-postgres-data
  redis_data:
    driver: local
    name: vote-redis-data

networks:
  vote-red:
    driver: bridge
    name: vote-network
```

### Variables de entorno del docker-compose.yml
**Este fichero si se debe agregar**
.env
```
REDIS_HOST=redis
OPTION_A= Gatos
OPTION_B= Perros
DATABASE_HOST=db
DATABASE_USER=postgres
DATABASE_PASSWORD=contrasena
DATABASE_NAME=votos
REDIS_VERSION=alpine3.22
POSTGRES_VERSION=13.22-alpine
APP_WORKER_PORT=3000
APP_RESULT_PORT=3000
APP_VOTE_PORT=80
REDIS_PORT=6379
WORKER_VERSION=v1.0.0
RESULT_VERSION=v1.0.0
VOTE_VERSION=v1.0.0
```

## Ejecutar docker-compose.yaml
```
docker compose up --build
```
