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

	// Usamos el destructuring de las últimas versiones de JavaScript
	// De esta manera separamos los datos del body recibido
	const { nomIncidencia, locIncidencia, tipIncidencia, ubiIncidencia, menIncidencia, imgIncidencia } = req.body;
	// Guardamos los datos en un objeto llamado newIncidencia
	const newIncidencia = {
		idUsuario: 1,
		idCiudad: 2,
		nomIncidencia,
		menIncidencia,
		locIncidencia,
		tipIncidencia,
		ubiIncidencia,
		imgIncidencia
	};
	// Vemos el nuevo objeto por consola
	console.warn(newIncidencia);

	// Guardamos los datos en la base de datos
	// Como esta petición a la base de datos va a tardar,
	// usamos Async/Await
	await pool.query('INSERT INTO incidencias SET ?', [newIncidencia]);
	res.send('Recibido');
});

// Exportamos el router
module.exports = router;