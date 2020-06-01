// app.js
const express = require('express');
const app = express();

// Requerimos handlebars
const hbs = require('express-handlebars');

// Configuramos view engine para handlebars
app.set('view engine', 'hbs');

app.engine('hbs', hbs( {
	extname: 'hbs',
	defaultView: 'default',
	layoutsDir: __dirname + '/views/default/',
	partialsDir: __dirname + '/views/partials/'
}));


// La url o ruta raíz(/) responde con un "Hello World!"
app.get('/', (req, res) => {
	res.send('Hello World!');
});

// Nuestro servidor escucha desde el puerto 3000
app.listen(3000, () => {
	console.log('Apliación escuchando desde el puerto 3000...');
})