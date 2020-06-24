// incidencias.js
// Rutas para las incidencias de los usuarios

//Requerimos colors para mostrar por consola mensajes personalizados
const colors = require('colors');

// Requerimos express
const express = require('express');
// Requerimos router
const router = express.Router();

// Requerimos el módulo de databse,js
const pool = require('../database');

// Requerimos el método de passport que hemos creado en auth
const { isLoggedIn } = require('../lib/auth');

//Ruta para GET de '/add' para mostrar IU del formulario
// para añadir incidencias
// Protegemos en caso de no ser un usuario registrado
router.get('/add', isLoggedIn,  (req, res) => {
	res.render('incidencias/add', {
		title: 'Añadir Incidencia'
	});
});


// Para recibir datos del formulario necesitamos tener
// un ruter hacia la misma ruta pero para peticiones POST
router.post('/add', isLoggedIn, async (req, res) => {
	// Usamos 'req.body' para capturar el valor de los parámetros
	// name de los inputs del formulario
	// Los mostramos en pantalla para ver si todo ha ido correcto
	console.warn(req.body);

	// Mostramos el archivo recibido por consola
	// file -> Archivo que detecta Multer
	console.warn(req.file);
	// Guardamos el nombre de la imagen en una constante
	const imgName = req.file.filename;
	console.warn('El nombre de la imagen es renombrado a: ' + imgName);

	// Usamos el destructuring de las últimas versiones de JavaScript
	// De esta manera separamos los datos del body recibido
	const { nomIncidencia, locIncidencia, tipIncidencia, ubiIncidencia, menIncidencia, imgIncidencia } = req.body;

	// Hacemos una consulta para saber el ID de la ciudad a la que se hace referencia en 'ubiIncidencia'
	// Usamos toString en ubiIncidencia para que pase un String
	const ciudad = await pool.query('SELECT idCiudad FROM db_cuidandomiciudad.ciudades WHERE nomCiudad = ?', [ubiIncidencia].toString());
	// Accedemos al primer (y único) índice que nos devuelve la query para saber el ID
	console.warn('El ID de la ciudad es: ' + JSON.stringify(ciudad[0].idCiudad));

	// Guardamos los datos en un objeto llamado newIncidencia
	// De momento dejamos la propiedad idUsuario como uno por defecto hasta que sepamos validar usuario
	const newIncidencia = {
		idUsuario: req.user.idUsuario,
		idCiudad: ciudad[0].idCiudad,
		nomIncidencia,
		menIncidencia,
		locIncidencia,
		tipIncidencia,
		ubiIncidencia,
		imgIncidencia: imgName
	};
	// Vemos el nuevo objeto por consola
	console.warn(newIncidencia);



	// Guardamos los datos en la base de datos
	// Como esta petición a la base de datos va a tardar,
	// usamos Async/Await
	await pool.query('INSERT INTO db_cuidandomiciudad.incidencias SET ?', [newIncidencia]);

	//Para mostrar un mensaje con el módulo 'connect-flash'
	// 'flash' necesita dos parámetros, 1: nombre como lo guardamos - 2: valor del mensaje
	req.flash('success', 'Incidencia guardada con éxito');
	res.redirect('/incidencias');
});

// Añadimos una ruta para la raíz incidencias, donde se listarán
// todas las incidencias que haya en la base de datos
router.get('/', async (req, res) => {
	// Pedimos todas las incidencias y las guardamos en una constante
	// llamada 'incidencias'
	const incidencias = await pool.query('SELECT DISTINCT * FROM db_cuidandomiciudad.incidencias inc, db_cuidandomiciudad.usuarios usu WHERE inc.idUsuario = usu.idUsuario ORDER BY inc.fcCreacion ASC;');
	// Mostramos los datos recibidos en consola
	console.warn(incidencias);
	res.render('incidencias/list', {
		incidencias,
		title: 'Incidencias',
		url: '/uploads/'
	});
});

// Ruta GET de MIS INCIDENCIAS (/mylist)
router.get('/mylist', isLoggedIn, async (req, res) => {
	// Pedimos todas las incidencias y las guardamos en una constante
	// llamada 'incidencias'
	const incidencias = await pool.query('SELECT * FROM incidencias WHERE idUsuario = ?', [req.user.idUsuario]);
	// Mostramos los datos recibidos en consola
	console.warn(incidencias);

	// Renderizamos la vista
	res.render('incidencias/mylist', {
		incidencias,
		title: 'Mis Incidencias',
		url: '/uploads/'
	});
});

// Añadimos una ruta para escuchar los eventos de eliminación
router.get('/delete/:id', isLoggedIn, async (req, res) => {
	// Recogemos el idIncidencias de la incidencia
	const { id } = req.params;
	// console.log(id);
	// res.send('Eliminado');
	// Hacemos una constulta para eliminar dicha incidencia
	await pool.query('DELETE FROM incidencias WHERE idIncidencias = ?', [id]);
	// Mostramos mensaje satisfactorio si todo va bien
	req.flash('success', 'Incidencia eliminada satisfactoriamente');
	// Redireccionamos a 'Incidencias'
	res.redirect('/incidencias');
});

// RUTA /incidencias/edit para editar Incidencias
router.get('/edit/:id', isLoggedIn, async (req, res) => {
	const { id } = req.params;
	const incidencias = await pool.query('SELECT * FROM incidencias WHERE idIncidencias = ?', [id]);
	
	res.render('incidencias/edit', {incidencia: incidencias[0]});
});

// RUTA PARA RECIBIR DATOS INCIDENCIA ACTUALIZADA
// POST
router.post('/edit/:id', isLoggedIn, async (req, res) => {
	const { id } = req.params;
	console.log(req.body);
	const { nomIncidencia, locIncidencia, tipIncidencia, ubiIncidencia, menIncidencia } = req.body;

	// Hacemos una consulta para saber el ID de la ciudad a la que se hace referencia en 'ubiIncidencia'
	// Usamos toString en ubiIncidencia para que pase un String
	const ciudad = await pool.query('SELECT idCiudad FROM db_cuidandomiciudad.ciudades WHERE nomCiudad = ?', [ubiIncidencia].toString());

	const newIncidencia = {
		idUsuario: 1,
		idCiudad: ciudad[0].idCiudad,
		nomIncidencia,
		menIncidencia,
		locIncidencia,
		tipIncidencia,
		ubiIncidencia
	};

	// res.send('Actualizado');

	// Hacemos la consulta para actualizar los datos
	await pool.query('UPDATE incidencias SET ? WHERE idIncidencias = ?', [newIncidencia, id]);
	req.flash('success', 'Incidencia actualizada satisfactoriamente');
	res.redirect('/incidencias');
});

// RUTA PARA VER UNA INCIDENCIA CONCRETA
router.get('/see/:id', async (req, res) => {
	// Capturamos el id de la incidencia que se quiere ver
	const { id } = req.params;
	// Capturamos la incidencia en questión mediante una consulta a la BD
	const incidencia = await pool.query('SELECT * FROM incidencias WHERE idIncidencias = ?', [id]);

	// Respondemos renderizando la ruta '/incidencias/see' y le pasamos los datos de la incidencia capturada
	res.render('incidencias/see', {incidencia: incidencia[0]});
});

// Exportamos el router
module.exports = router;