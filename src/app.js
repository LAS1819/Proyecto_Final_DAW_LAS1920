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
// extname -> tipo de extensión handlebars que usamos
// defaultLayout -> layout pot defecto que tendremos preparado
// layoutsDir -> Directorio donde guardamos los layouts
// partialsDir -> Directorio donde guardamos los partials
// helpers -> Para utilizar funciones de handlebars. Por si queremos procesar fechas, por ejemplo.
app.engine('.hbs', hbs({
	extname: 'hbs',
	defaultLayout: 'default', layoutsDir: __dirname + '/views/layouts/',
	layoutsDir: path.join(app.get('views'), 'layouts'),
	partialsDir: path.join(app.get('views'), 'partials'),
	helpers: require('./lib/handlebars')
}));

// Advertimos de la extensión que usaremos en los archivos handlebars (hbs)
app.set('view engine', '.hbs');
// Configuramos el puerto
app.set('port', (process.env.PORT || 3000));

// ------------MIDDLEWARES--------------------------------
// Decimos que use morgan y el parámetro 'dev' para que nos muestre cierto tipo de datos por consola
app.use(morgan('dev'));

// urlencoded -> Para aceptar los datos que se envían desde el formulario
// extended: false -> Para evitar datos pesados (¿No se puede enviar imagen?)
app.use(express.urlencoded({extended: false}));
// Para enviar y recibir JSON
app.use(express.json());

// TO DO: Añadir imágenes con MULTER (instalar Multer y requerir)

//-------------VARIABLES GLOBALES--------------------
// Futura función
app.use((req, res, next) => {

	next();
});

//-------------RUTAS----------------------------------
// Advertimos que use las rutas
// app.use('/', routes);
app.use(require('./routes'));
app.use(require('./routes/authentication'));

//--------------PUBLIC-------------------------------
// Donde está el CSS, Javascript, fuentes, etc...
app.use(express.static(path.join(__dirname, 'public')));

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