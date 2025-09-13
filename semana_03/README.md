# Dia 15/90
Para este proyecto practicamos crear un proyecto de GitHub con el cliente _gh_. \

## Crear repositorio
```
gh repo create
```
Luego de ejecutar el comando debemos contestar las preguntas que nos apareceran ya \
que estos son los mismos campos que llenamos cuando lo creamos desde la interfaz web. \

```
? What would you like to do? Create a new repository on github.com from scratch
? Repository name mi-primer-ci-cd
? Description Creando mi primer GitHub Actions
? Visibility Public
? Would you like to add a README file? No
? Would you like to add a .gitignore? Yes
? Choose a .gitignore template AL
? Would you like to add a license? Yes
? Choose a license Apache License 2.0
? This will create "mi-primer-ci-cd" as a public repository on github.com. Continue? Yes
✓ Created repository jorhak/mi-primer-ci-cd on github.com
  https://github.com/jorhak/mi-primer-ci-cd
? Clone the new repository locally? No
```

Ahora lo que vamos hacer sera clonar este repositorio para trabajar sobre el. \
Debemos estar ubicados en la ruta **semana-03/ejercicios/ejercicio-01**
```
git clone git@github.com:jorhak/mi-primer-ci-cd.git
cd mi-primer-ci-cd
```

## Crear Pipelines
### Pipeline Basico
```
mkdir -p .github/workflows
touch .github/workflows/basico.yml
```

Agregamos las siguientes lineas \
basico.yml \
```
name: Workflow basico

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

jobs:
  verificar_repositorio:
    runs-on: ubuntu-latest
    steps:
    - name: 📥 Verificar repositorio
      uses: actions/checkout@v4
    
    - name: Imprimir saludo
      run: |
        echo "¡Hola desde el workflow básico! 🚀"
        whoami
        cat /etc/os-release

    - name: 🧪 Test Sencillo
      run: |
        cat /etc/passwd
```

Ahora debemos agregarlo workspace, luego al stage y finalmente push para que se suba al repositorio remoto \ 
y que se ejecute el Pipeline
```
ga .
gc "Agregando Pipeline basico"
gp
```

Cabe mencionar que utilice alias. \

### Pipeline con variables
```
touch .github/workflows/con_variables.yml
```

Agregamos las siguientes lineas \
con_variables.yml
```
name: Agregando variables

on: 
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

env:
  VALOR1: "4"
  VALOR2: "6"
  OPERACION: "suma"

jobs:
    checkout:
      runs-on: ubuntu-latest
      steps:
      - name: 📥 Descargar código
        uses: actions/checkout@v4
     
      - name: Realizar operación
        run: |
          if [ "$OPERACION" == "suma" ]; then
            RESULTADO=$((VALOR1 + VALOR2))
            echo "La suma de $VALOR1 y $VALOR2 es: $RESULTADO"
          fi
```

Ahora debemos agregarlo workspace, luego al stage y finalmente push para que se suba al repositorio remoto \ 
y que se ejecute el Pipeline

```
ga .
gc "Agregando Pipeline con variables"
gp
```

### Pipeline segun rama

#### Requisitos previos
a) Contar con un webhook en Discord
   1. Abrimos nuestro Discord, nos dirigimos a la parte inferior izquierda y damos click sobre ➕ \
   ![Get started](./dia15/webhookDiscord.png)
   2. Damos click sobre Create My Own. \
   ![Get started](./dia15/webhookDiscord1.png)
   3. Elegimos para quien va ser el Server, damos click sobre For me and my friends. \
   ![Get started](./dia15/webhookDiscord2.png)
   4. Le asignamos un nombre y damos click en Create. \
   ![Get started](./dia15/webhookDiscord3.png)
   5. Una ves se cree nuestro Server damos click sobre Prueba y en la parte superior izquierda del canal \
   general damos click sobre ⚙️ \
   ![Get started](./dia15/webhookDiscord4.png)
   6. Nos vamos a Integration y luego damos click sobre Create Webhook \
   ![Get started](./dia15/webhookDiscord5.png)
   7. Damos click en Create Webhook. \
   ![Get started](./dia15/webhookDiscord6.png)
   8. Ya tenemos nuestro Webhook creado lo que debemos hacer es copiar la URL del webhook que va ser nuestro \
   **secrets** en GitHub. \
   ![Get started](./dia15/webhookDiscord7.png)

b) Contar con un webhook en Slack \
   Antes debemos crearnos un WorkSpace.
   1. Para comenzar nos dirigimos a [API Slack](https://docs.slack.dev/messaging/sending-messages-using-incoming-webhooks/). Damos click en Create an app. \
   ![Get started](./dia15/webhookSlack.png)
   2. Se nos va abrir otra pestana y damos click en Create an App. \
   ![dh](./dia15/webhookSlack1.png)
   3. Nos va pedir elegir si usamos un manifiesto o si lo queremos desde cero, vamos a dar click
   sobre From scratch. \
   ![dh](./dia15/webhookSlack2.png)
   4. Le asignamos un nombre, elegimos el workspace y finalmente damos click en Create App. \
   ![dh](./dia15/webhookSlack3.png)
   5. Cuando se nos cree la aplicacion nos vamos a la parte superior izquierda y damos click sobre Incoming Webhooks. \
   ![dh](./dia15/webhookSlack4.png)
   6. Habilitamos Incoming webhook. \
   ![dh](./dia15/webhookSlack5.png)
   7. Vamos agregar un nuevo webhook. \
   ![dh](./dia15/webhookSlack6.png)
   8. Ya tenemos nuestro Webhook creado lo que debemos hacer es copiar la URL del webhook que va ser \
   nuestro **secrets** en GitHub. \
   ![dh](./dia15/webhookSlack8.png)


### Crear Pipeline
```
touch .github/workflows/con_condicion.yml
```

Agregamos las siguientes lineas \
con_condicion.yml
```
name: Ejecutar segun la rama

on:
  push:
    branches: [main, develop, feature/*]
  workflow_dispatch:

jobs:
    checkout:
      runs-on: ubuntu-latest
      steps:
      - name: Revisar codigo
        uses: actions/checkout@v4

    rama:
      runs-on: ubuntu-latest
      steps:
      - name: Revisar codigo
        uses: actions/checkout@v4
        
      - name: notificar discord (solo main)
        if: github.ref == 'refs/heads/main'
        run: |
          curl -H "Content-Type: application/json" -X POST -d '{"content":"🚀 El código se ha actualizado en la rama main."}' ${{ secrets.DISCORD_WEBHOOK_URL }}

      - name: Enviar correo (en develop y feature/*) 📧
        if: github.ref == 'refs/heads/develop' || startsWith(github.ref, 'refs/heads/feature/')
        run: |
          curl -X POST -H 'Content-type: application/json' --data '{"text":"Nuevo commit de ${{ github.event.head_commit.author.name }}: commit: ${{ github.event.head_commit.message }}"}' ${{ secrets.SLACK_WEBHOOK_URL }}
```

Ahora debemos agregarlo al workspace, luego al stage y finalmente push para que se suba al repositorio \
remoto y que se ejecute el Pipeline

```
ga .
gc "Agregando Pipeline segun rama"
gp
```

### Crear rama develop y subirlo al repositorio
```
git checkout -b develop
git branch develop
git push origin develop
```

Ahora segun la rama se ejecuta la notificacion que para main va a Discord y para develop y feature va a Slack.

# Dia 16/90
No llegaba a importar el modulo "app". Esto se debe a que al momento de ejecutar **pytest** este busca tests/ \
y este no sabe que debe "subir un nivel".
Lo que vamos hacer sera crear un fichero dentro de tests/__init__.py para que este directorio se reconosca como un paquete del cual pueden importar modulos.
Tuvimos un problema con los response ya que no imprimia el caracter "¡" sino que imprimia "\u00a1" por lo que \
un test no llega a pasar.

Aqui cometi un error, bueno no se si fue un error pero lo estaba subiendo todo al repositorio de 90DiasDeDevOps.
Asi que me cree otro para subir mi-app-python/ a otro repositorio.
Cree el repositorio con **gh** como cree el repositorio en el dia 15. Aqui le agrege .gitignore por lo cual ya tenia un commit.
Ahora lo que tengo que hacer es lo que ya tengo inicializar repositorio y agregarlo al que acabo de crear. \
Lo que tenia que hacer era que el contenido del repositorio remoto este en mi respositorio local y para ello \
se ejecutar los siguientes comandos.

```
git init 
git remote add origin git@github.com:jorhak/mi-app-python.git
git pull origin main
ga .
gc " Build y Test basico"
gp
git push --set-upstream origin main
```
