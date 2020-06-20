// passport.js
const colors = require('colors');
// Donde definimos nuestros métodos de autenticación
// Requerimos passport
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;

// Traemos la conexión de Express y la guardamos en pool
const pool = require('../database');

// Traemos los métodos helpers
const helpers = require('./helpers');

console.warn('Entrando en "lib/passport.js"'.red);

// Estrategia para el LOGIN
passport.use('local.signin', new LocalStrategy({
	usernameField: 'nickUsuario',
	passwordField: 'pasUsuario',
	passReqToCallback: true
}, async (req, username, password, done) => {
	console.warn(req.body);
	console.warn(username);
	console.warn(password);
	const rows = await pool.query('SELECT * FROM usuarios WHERE nickUsuario = ?', [username]);
	if (rows.length > 0) {
		const user = rows[0];
		const validPassword = await helpers.matchPassword(password, user.pasUsuario);
		if (validPassword) {
			done(null, user, req.flash('success', 'Bienvenido ' + user.nickUsuario));
		} else {
			done(null, false, req.flash('message', 'Password incorrecto'));
		}
	} else {
		return done(null, false, req.flash('message', 'El nombre de usuario no existe'));
	}
}));

// Estrategia para el REGISTRO
passport.use('local.signup', new LocalStrategy({
	usernameField: 'nickUsuario',
	passwordField: 'pasUsuario',
	passReqToCallback: true
}, async (req, username, password, done) => {
	console.log('Entrando en "passport.use".......'.red);
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

	// console.warn(newUser);
	newUser.pasUsuario = await helpers.encryptPassword(password);
	const result = await pool.query('INSERT INTO usuarios SET ?', [newUser]);
	// console.log(result);
	// Como no sabemos cuál es el id del usuario, lo guardamos obteniéndolo del resultado anterior
	newUser.idUsuario = result.insertId;
	return done(null, newUser);
}));

passport.serializeUser((user, done) => {
	console.warn('Entrando en "serializeUser"');
	console.warn(user);
	console.warn(done);
	done(null, user.idUsuario);
});

passport.deserializeUser(async (id, done) => {
	const rows = await pool.query('SELECT * FROM usuarios WHERE idUsuario = ?', [id])
	done(null, rows[0]);
});