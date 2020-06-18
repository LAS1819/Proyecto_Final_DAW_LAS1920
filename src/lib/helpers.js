// helpers.js
const colors = require('colors');
const bcrypt = require('bcryptjs');

console.warn('Entrando en "lib/helpers.js"'.red);

const helpers = {};

helpers.encryptPassword = async (password) => {
	console.warn('Entrando en "encryptPassword"'.red);
	// Generamos un patrón
	const salt = await bcrypt.genSalt(10);
	console.warn('Patrón generado'.red);
	// Ciframos contraseña con el password y el patrón
	const hash = await bcrypt.hash(password, salt);
	console.warn('Contraseña encriptada'.red);
	return hash;
};

helpers.matchPassword = async (password, savedPassword) => {
	console.warn('Entrando en "matchPassword"'.red);
	try {
		await bcrypt.compare(password, savedPassword);
	} catch(e) {
		// statements
		console.log(e);
	}
};

module.exports = helpers;