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