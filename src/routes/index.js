// index.js
// Usamos este archivo para almacenar todas las rutas principales
const express = require('express');
const router = express.Router();

// Al renderizar en la raíz, decimos los parámetros que queremos que lleve el body
// GET HOME PAGE
// router.get('/', (req, res, next) => {
// 	res.render('index', {title: 'Página principal'});
// });

router.get('/', (req, res, next) => {
	res.render('index', {
		title: 'Página principal',
		content: 'Esto es algo de contenido'	
	});
});

module.exports = router;

