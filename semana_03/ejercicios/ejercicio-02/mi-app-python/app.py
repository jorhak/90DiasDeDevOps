from flask import Flask, jsonify, Response
import datetime, json

app = Flask(__name__)

# puedes seguir manteniendo esto, pero el método siguiente fuerza UTF-8:
app.config['JSON_AS_ASCII'] = False  # ✅ Permitir UTF-8 en JSON

def jsonify_utf8(obj):
    # json.dumps con ensure_ascii=False para que no escape caracteres no-ASCII
    return Response(json.dumps(obj, ensure_ascii=False), mimetype='application/json; charset=utf-8')

@app.route('/')
def home():
    return jsonify_utf8({
        'message': '¡Hola DevOps con Roxs!',
        'timestamp': datetime.datetime.now().isoformat(),
        'status': 'success'
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy', 'uptime': 'running'})

@app.route('/suma/<int:a>/<int:b>')
def suma(a, b):
    return jsonify({
        'operacion': 'suma',
        'numeros': [a, b],
        'resultado': a + b
    })

@app.route('/saludo/<nombre>')
def saludo(nombre):
    return jsonify_utf8({
        'saludo': f'¡Hola {nombre}!',
        'mensaje': 'Bienvenido a mi aplicación'
    })

# Funciones para test
def multiplicar(a, b): return a * b
def es_par(n): return n % 2 == 0

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)