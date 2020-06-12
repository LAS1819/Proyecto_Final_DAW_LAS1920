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

//Ruta para GET de '/add' para mostrar IU del formulario
// para añadir incidencias
router.get('/add', (req, res) => {
	res.render('incidencias/add', {
		title: 'Añadir Incidencia'
	});
});


// Para recibir datos del formulario necesitamos tener
// un ruter hacia la misma ruta pero para peticiones POST
router.post('/add', async (req, res) => {
	// Usamos 'req.body' para capturar el valor de los parámetros
	// name de los inputs del formulario
	// Los mostramos en pantalla para ver si todo ha ido correcto
	console.warn(req.body);

	// Mostramos el archivo recibido por consola
	// file -> Archivo que detecta Multer
	console.warn(req.file);
	// Gradamos los datos de la imagen en una constante
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
		idUsuario: 1,
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
	res.send('Recibido');
});

// Añadimos una ruta para la raíz incidencias, donde se listarán
// todas las incidencias que haya en la base de datos
router.get('/', async (req, res) => {
	// Pedimos todas las incidencias y las guardamos en una constante
	// llamada 'incidencias'
	const incidencias = await pool.query('SELECT * FROM incidencias');
	// Mostramos los datos recibidos en consola
	console.warn(incidencias);
	res.render('incidencias/list', { incidencias });
});

// Exportamos el router
module.exports = router;