// passport.js
const colors = require('colors');
// Donde definimos nuestros métodos de autenticación
// Requerimos passport
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;

// Traemos la conexión de Express y la guardamos en pool
const pool = require('../database');

// Traemos los métodos helpers
const helpers = require('../lib/helpers');

console.warn('Entrando en "lib/passport.js"'.red);

passport.use('local.signup', new LocalStrategy({
	usernameField: 'nickUsuario',
	passwordField: 'pasUsuario',
	passReqToCallback: true
}, async (req, username, password, done) => {
	console.log('Entrando en passport.use.......');
	console.log(req.body);

	const { nomUsuario, apeUsuario, dirUsuario, ciuUsuario, corUsuario, telUsuario } = req.body;

	// Guardamos el id de la ciudad correspondiente
	const ciudad = await pool.query('SELECT idCiudad FROM db_cuidandomiciudad.ciudades WHERE nomCiudad = ?', [ciuUsuario].toString());

	const newUser = {
		idCiudad: ciudad[0].idCiudad,
		nickUsuario: username,
		nomUsuario,
		apeUsuario,
		pasUsuario: password,
		corUsuario,
		ciuUsuario,
		telUsuario,
		dirUsuario		
	};

	console.warn(newUser);
	newUser.pasUsuario = await helpers.encryptPassword(password);
	const result = await pool.query('INSERT INTO usuarios SET ?', [newUser]);
	console.log(result);
}));

// passport.serializeUser((usr, done) => {

// });