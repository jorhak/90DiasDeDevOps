from flask import Flask, render_template, request, redirect, url_for
from flask_mysqldb import MySQL
from datetime import datetime
import config

app = Flask(__name__)
app.config.from_object(config)

mysql = MySQL(app)

@app.route('/')
def index():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM empleados")
    empleados = cur.fetchall()
    return render_template('index.html', empleados=empleados)

@app.route('/add', methods=['GET', 'POST'])
def add():
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        salario = request.form['salario']
        departamento = request.form['departamento']
        fecha_ingreso = datetime.now().strftime('%Y-%m-%d')
        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO empleados (nombre, apellido, fecha_ingreso, salario, departamento) VALUES (%s, %s, %s, %s, %s)",
                    (nombre, apellido, fecha_ingreso, salario, departamento))
        mysql.connection.commit()
        return redirect(url_for('index'))
    return render_template('add.html')

@app.route('/edit/<int:id>', methods=['GET', 'POST'])
def edit(id):
    cur = mysql.connection.cursor()
    if request.method == 'POST':
        nombre = request.form['nombre']
        apellido = request.form['apellido']
        salario = request.form['salario']
        departamento = request.form['departamento']
        cur.execute("UPDATE empleados SET nombre=%s, apellido=%s, salario=%s, departamento=%s WHERE id=%s",
                    (nombre, apellido, salario, departamento, id))
        mysql.connection.commit()
        return redirect(url_for('index'))
    cur.execute("SELECT * FROM empleados WHERE id=%s", (id,))
    empleado = cur.fetchone()
    return render_template('edit.html', empleado=empleado)

@app.route('/delete/<int:id>', methods=['POST'])
def delete(id):
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM empleados WHERE id=%s", (id,))
    mysql.connection.commit()
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True)