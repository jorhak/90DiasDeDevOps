const http = require('http');

const PORT = process.env.PORT || 3000;

http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain; charset=UTF-8' });
  res.end('¡Hola desde Docker y Node.js!\n');
}).listen(PORT);

console.log(`Servidor corriendo en http://localhost:${PORT}`);