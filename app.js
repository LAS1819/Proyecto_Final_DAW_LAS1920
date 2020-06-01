// app.js
var express = require('express');
var app = express();


// La url o ruta raíz(/) responde con un "Hello World!"
app.get('/', (req, res) => {
	res.send('Hello World!');
});

// Nuestro servidor escucha desde el puerto 3000
app.listen(3000, () => {
	console.log('Apliación escuchando desde el puerto 3000...');
})