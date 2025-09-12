import pytest, json
from app import app, multiplicar, es_par

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_home(client):
    r = client.get('/')
    data = json.loads(r.data)
    assert r.status_code == 200
    assert data['status'] == 'success'

def test_health(client):
    r = client.get('/health')
    assert json.loads(r.data)['status'] == 'healthy'

def test_suma(client):
    r = client.get('/suma/3/4')
    assert json.loads(r.data)['resultado'] == 7

def test_saludo(client):
    r = client.get('/saludo/Rox')
    assert '¡Hola Rox!' in r.get_data(as_text=True)

def test_multiplicar(): assert multiplicar(2, 3) == 6
def test_es_par(): assert es_par(4)