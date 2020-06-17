// authentication.js
// Almacenaremos las rutas para las autenticaciones de usuario y todo lo relacionado
const express = require('express');
const router = express.Router();

// Creamos la ruta hacia /signup, donde se hará el registro de usuario
router.get('/signup', (req, res) => {
	res.render('auth/signup');
});

// RUTA POST hacia signup, para recibir datos
router.post('/signup', (req, res) => {
	console.log(req.body);
	res.send('Recibido');
});

module.exports = router;