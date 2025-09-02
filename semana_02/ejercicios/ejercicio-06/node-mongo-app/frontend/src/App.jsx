import { useEffect, useState } from 'react';

function App() {
  const [items, setItems] = useState([]);
  const apiUrl = import.meta.env.VITE_API_URL;

  useEffect(() => {
    console.log('🔎 Intentando conectar al backend...');
    fetch(apiUrl)
      .then(res => {
        console.log('🌐 Respuesta recibida del backend:', res);
        return res.json();
      })
      .then(data => {
        console.log('📦 Datos recibidos:', data);
        setItems(data);
      })
      .catch(err => {
        console.error('❌ Error al conectar con el backend:', err);
      });
  }, []);

  return (
    <div style={{ padding: 20 }}>
      <h1>Documentos en MongoDB</h1>
      <ul>
        {items.map(item => (
          <li key={item._id}>{item.name || JSON.stringify(item)}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;