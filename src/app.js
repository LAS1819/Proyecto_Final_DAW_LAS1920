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
// Requerimo 'uuid' para generar nombres únicos en las imágenes subidas
// Concretamente la parte v4, que generará dicho string único
const { v4: uuidv4 } = require('uuid');
// Advertimos que vamos a usar las rutas que definimos en el directorio Routes
const routes = require('./routes/index');
// Requerimos 'connect-flash' para enviar mensajes como middleware
const flash = require('connect-flash');
// Requerimos 'express-session' para establecer sesiones y almacenar datos en la memoria del servidor
const session = require('express-session');
// Requerimos 'express-mysql-session' para guardar las sesiones en la base de datos
const MySQLStore = require('express-mysql-session');
// Requerimos 'passport' para usarlo como validación del usuario
const passport = require('passport');

// Requerimos las claves de nuestra BD de MySQL para poder guardar la sesión
// Este archivo está oculto en el repositorio GitHub, así que es necesario crearlo con las credenciales de cada uno que quiera probarlo
const { database } = require('./keys');

// ##########################################
// -------INICIALIZACIONES-------
// ##########################################

// Iniciamos conexión
const app = express();

// Requerimos nuestro módulo de passport con la autenticación creada
require('./lib/passport');

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
// Usamos uuidv4 para generar el id único, más el nombre del archivo
const storage = multer.diskStorage({
	destination: path.join(__dirname, 'public/uploads'),
	filename: (req, file, cb) => {
		cb(null, uuidv4() + path.extname(file.originalname).toLowerCase());
	}
});

// ##########################################
// ------------MIDDLEWARES--------------------------------
// ##########################################

// Usamos 'express-session'
// secret -> palabra secreta
// resave -> controla si se renueva o no la sesión
// saveUninitialized -> controla si se guarda o no la sesión
// store -> lugar donde guardamos la sesión. Le pasamos database, el cual contiene las credenciales para conectar con esa BD
app.use(session({
	secret: 'CMCSession',
	resave: false,
	saveUninitialized: false,
	store: new MySQLStore(database)
}));


// Usamos 'connect-flash' como middleware y mostrar mensajes de una página a otra
app.use(flash());

// Decimos que use morgan y el parámetro 'dev' para que nos muestre cierto tipo de datos por consola
app.use(morgan('dev'));

// urlencoded -> Para aceptar los datos que se envían desde el formulario
// extended: false -> Para evitar datos pesados (¿No se puede enviar imagen?)
app.use(express.urlencoded({extended: false}));
// Para enviar y recibir JSON
app.use(express.json());

// Inicializamos passport
app.use(passport.initialize());
// Le otorgamos una sesión
app.use(passport.session());



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

// ##########################################
//-------------VARIABLES GLOBALES--------------------
// ##########################################
app.use((req, res, next) => {
	// Guardamos el valor de succes en una variable local (app.locals)
	// Así podemos tener disponible este mensaje en todas nuestras vistas
	app.locals.success = req.flash('success');

	app.locals.message = req.flash('message');
	
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