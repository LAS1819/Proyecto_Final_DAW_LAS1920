// authentication.js
// Almacenaremos las rutas para las autenticaciones de usuario y todo lo relacionado
const express = require('express');
const router = express.Router();
const passport = require('passport');

// Requerimos el módulo de databse,js
const pool = require('../database');

// Requerimos el métdo isLoggedIn e isNotLoggedIn para usarlo en cualquier ruta que queramos
const { isLoggedIn, isNotLoggedIn } = require('../lib/auth');

// Creamos la ruta hacia /signup, donde se hará el registro de usuario
router.get('/signup', isNotLoggedIn, (req, res) => {
	res.render('auth/signup');
});

// RUTA POST hacia signup, para recibir datos
// router.post('/signup', (req, res) => {
// 	console.warn('Entrando en POST /signup...');
// 	res.send('Recibido');
// 	passport.authenticate('local.signup', {
// 		successRedirect: '/profile',
// 		failureRedirect: '/signup',
// 		failureFlash: true
// 	});
// 	console.warn('Saliendo de POST /signup...');
// });

// Método POST más sencillo de escribir (en comparación con el anterior)
router.post('/signup', isNotLoggedIn, passport.authenticate('local.signup', {
	successRedirect: '/profile',
	failureRedirect: '/signup',
	failureFlash: true
}));

// Ruta SIGNIN a través de GET
router.get('/signin', isNotLoggedIn, (req, res) => {
	res.render('auth/signin');
});

// Ruta SIGNIN a través de POST
router.post('/signin', isNotLoggedIn, (req, res, next) => {
	passport.authenticate('local.signin', {
		successRedirect: '/profile',
		failureRedirect: '/signin',
		failureFlash: true
	})(req, res, next);
});

// GET hacia PROFILE
router.get('/profile', isLoggedIn, (req, res) => {
	res.render('profile');
});

// POST PARA ACUTALIZAR DATOS DEL PROFILE PERSONAL
router.post('/profile/:id', isLoggedIn, async (req, res) => {
	const { id } = req.params;
	const { filename } = req.file;
	console.log(id);
	console.log(filename);
	await pool.query('UPDATE `db_cuidandomiciudad`.`usuarios` SET `imgUsuario` = ? WHERE (`idUsuario` = ?);', [filename, id]);
	req.flash('succes', 'Imagen de usuario actualizada');
	res.redirect('/profile');
});

// GET hacia LOGOUT
router.get('/logout', isLoggedIn, (req, res) => {
	// Usamos método de Passport 'logOut' para cerrar sesión
	req.logOut();
	// Lo reenviamos a la pantalla principal
	res.redirect('/');
});



module.exports = router;