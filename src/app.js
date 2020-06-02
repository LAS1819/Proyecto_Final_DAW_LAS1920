// app.js
const express = require('express');
// Requerimos handlebars
const hbs = require('express-handlebars');
// Requerimos path
const path = require('path');
// Requerimos el middleware Morgan
const morgan = require('morgan');

// Advertimos que vamos a usar las rutas que definimos en el directorio Routes
const routes = require('./routes/index');

// -------Inicializaciones--------
// Iniciamos conexión
const app = express();


// -----------CONFIGURACIÓN------------------

// Configuramos el acceso a las vistas
app.set('views', path.join(__dirname, 'views'));

// Configuramos view engine para handlebars
app.engine('hbs', hbs({extname: 'hbs', defaultLayout: 'default', layoutsDir: __dirname + '/views/layouts/'}));

// Advertimos de la extensión que usaremos en los archivos handlebars (hbs)
app.set('view engine', 'hbs');
// Configuramos el puerto
app.set('port', (process.env.PORT || 3000));

// ------------MIDDLEWARES--------------------------------
// Decimos que use morgan y el parámetro 'dev' para que nos muestre cierto tipo de datos por consola
app.use(morgan('dev'));


//-------------VARIABLES GLOBALES--------------------

//-------------RUTAS----------------------------------

//--------------PUBLIC-------------------------------



// Advertimos que use las rutas
app.use('/', routes);
// La url o ruta raíz(/) responde con la renderización de handlebars
app.get('/', (req, res) => {
	res.render('index', {
		title: 'Página principal',
		content: 'Esto es algo de contenido'	
	});
});

//-------------INICIANDO SERVIDOR-------------------
// Dejamos el servidor a la escucha en el puerto definido
app.listen(app.get('port'), () => {
	// Enviamos un mensaje
	console.log('Servidor iniciado en el puerto ' + app.get('port'));
})

module.exports = app;

// app.engine('hbs', hbs({
// 	extname: 'hbs',
// 	defaultView: 'default',
// 	layoutsDir: __dirname + '/views/default/',
// 	partialsDir: __dirname + '/views/partials/'
// }));




// Nuestro servidor escucha desde el puerto 3000
// app.listen(3000, () => {
// 	console.log('Apliación escuchando desde el puerto 3000...');
// });