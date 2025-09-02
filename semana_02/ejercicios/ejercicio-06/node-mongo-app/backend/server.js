require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();
app.use(cors());

const mongoUri = process.env.MONGO_URI || 'mongodb://db:27017/mydb';
const port = process.env.PORT || 3000;
const collection =  process.env.COLLECTION_NAME || 'mydb';
console.log('🔧 Variables de entorno:', { mongoUri, port });
// Conexión a MongoDB
mongoose.connect(mongoUri, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
  .then(() => console.log('✅ Conectado a MongoDB'))
  .catch(err => {
    console.error('❌ Error conectando a MongoDB:', err.message);
    process.exit(1);
  });

// Definir un esquema y modelo para la colección 'test'
const itemSchema = new mongoose.Schema({
  name: String,
}, { collection: collection});

const Item = mongoose.model('Item', itemSchema);

app.get('/', (req, res) => {
  res.send('¡API conectada a MongoDB con Docker!');
});

app.get('/api/items', async (req, res) => {
  console.log('🔎 GET /api/items llamado');
  try {
    const items = await Item.find({});
    console.log('📦 Documentos encontrados:', items);
    res.json(items);
  } catch (err) {
    console.error('❌ Error en /api/items:', err.message);
    res.status(500).json({ error: err.message });
  }
});

app.listen(port, () => console.log(`Server running on port ${port}`));