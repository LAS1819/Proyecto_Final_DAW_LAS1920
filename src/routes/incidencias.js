// incidencias.js
// Rutas para las incidencias de los usuarios

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
router.post('/add', (req, res) => {
	res.send('Recibido');
})

// Exportamos el router
module.exports = router;