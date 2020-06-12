// app.js
const express = require('express');
// Requerimos handlebars
const hbs = require('express-handlebars');
// Requerimos path
const path = require('path');
// Requerimos el middleware Morgan
const morgan = require('morgan');
// Requerimos multer para validar imágenes
const multer = require('multer');
// Advertimos que vamos a usar las rutas que definimos en el directorio Routes
const routes = require('./routes/index');

// -------Inicializaciones--------
// Iniciamos conexión
const app = express();

// ##########################################
// -----------CONFIGURACIÓN------------------
// ##########################################

// Configuramos el puerto
app.set('port', (process.env.PORT || 3000));

// Configuramos el acceso a las vistas
app.set('views', path.join(__dirname, 'views'));

// Configuramos view engine para handlebars
// extname -> tipo de extensión handlebars que usamos
// defaultLayout -> layout pot defecto que tendremos preparado
// layoutsDir -> Directorio donde guardamos los layouts
// partialsDir -> Directorio donde guardamos los partials
// helpers -> Para utilizar funciones de handlebars. Por si queremos procesar fechas, por ejemplo.
app.engine('.hbs', hbs({
	extname: '.hbs',
	defaultLayout: 'default',
	layoutsDir: path.join(app.get('views'), 'layouts'),
	partialsDir: path.join(app.get('views'), 'partials'),
	helpers: require('./lib/handlebars')
}));

// Advertimos de la extensión que usaremos en los archivos handlebars (hbs)
app.set('view engine', '.hbs');

// Configuramos MULTER para validar imágenes
// destination -> Ruta donde se almacenará la imagen subida
// filename -> Elejimos el nombre que queremos de la imagen
const storage = multer.diskStorage({
	destination: path.join(__dirname, 'public/uploads'),
	filename: (req, file, cb) => {
		cb(null, file.originalname);
	}
});

// ##########################################
// ------------MIDDLEWARES--------------------------------
// ##########################################

// Decimos que use morgan y el parámetro 'dev' para que nos muestre cierto tipo de datos por consola
app.use(morgan('dev'));

// urlencoded -> Para aceptar los datos que se envían desde el formulario
// extended: false -> Para evitar datos pesados (¿No se puede enviar imagen?)
app.use(express.urlencoded({extended: false}));
// Para enviar y recibir JSON
app.use(express.json());

// Decimos a la app que use multer
// storage -> El storage que hemos creado en la configuración de multer
// dest -> Destino de las imágenes
// limits -> Limitación del tamaño de la imagen
// fileFilter -> Para restringir tipo de extensión de imágenes
// single -> Sólo queremos una imagen, y referenciamos que la queremos del input 'imgIncidencia'
app.use(multer({
	storage,
	dest: path.join(__dirname, 'public/uploads'),
	limits: {fileSize: 2000000}, // 2Mb
	fileFilter: (req, file, cb) => {
		const filetypes = /jpeg|jpg|png|gif/;
		const mimetype = filetypes.test(file.mimetype);
		const extname = filetypes.test(path.extname(file.originalname));
		if (mimetype && extname) {
			return cb(null, true);
		}
		cb("Error: el archivo debe ser una imagen válida.");
	}
}).single('imgIncidencia'));

//-------------VARIABLES GLOBALES--------------------
// Futura función
app.use((req, res, next) => {

	next();
});

// ##########################################
//-------------RUTAS----------------------------------
// ##########################################

// Advertimos que use las rutas
// app.use('/', routes);
app.use(require('./routes'));
app.use(require('./routes/authentication'));
app.use('/incidencias',require('./routes/incidencias'));

// ##########################################
//--------------PUBLIC-------------------------------
// ##########################################

// ARCHIVO ESTÁTICO
// Donde está el CSS, Javascript, fuentes, etc...
app.use(express.static(path.join(__dirname, 'public')));

// ##########################################
//-------------INICIANDO SERVIDOR-------------------
// ##########################################

// Dejamos el servidor a la escucha en el puerto definido
app.listen(app.get('port'), () => {
	// Enviamos un mensaje
	console.log('Servidor iniciado en el puerto ' + app.get('port'));
})

module.exports = app;