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