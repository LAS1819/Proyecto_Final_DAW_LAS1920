// database.js
// Este archivo lo usaremos para conectar con la base de datos MySQL

// Requerimos el módulo mysql
const mysql = require('mysql');

// Para poder hacer callbacks con el módulo mysql, importamos un
//módulo integrado de node llamado util, en concreto su propiedad promisify
const { promisify } = require('util');

// Requerimos el módulo keys.js
// Con destructuring traemos únicamente la propiedad database
const { database } = require('./keys');

// Utilizamos pool de mysql. Pero este módulo no soporta las promesas,
//y por tanto tampoco el 'async-await'
const pool = mysql.createPool(database);

// Usamos la conexión para tenerla preparada
pool.getConnection((err, connection) => {
	console.log('Entrando en getConnection');
	// Si la conexión encuentra un error...
	if (err) {
		if (err.code === 'PROTOCOL_CONNECTION_LOST') {
			console.error('La conexión con la base de datos se ha cerrado');
		}
		if (err.code === 'ER_CON_COUNT_ERROR') {
			console.error('La base de datos tiene muchas conexiones');
		}
		if (err.code === 'ECONNREFUSED') {
			console.error('La conexión con la base de datos ha sido rechazada');
		}
	}

	// Si no hay error... obtenemos la conexión usando el métdod relesase
	if (connection) {
		connection.release();
		console.log('Base de datos conectada');
		return;
	} 
	
});

// Convertimos a promesas
// Decimos que queremos usar promesas cuando requerimos
// hacer query a la consexión (pool)
pool.query = promisify(pool.query);

// Exportamos el módulo de la conexión (pool) para hacer las consultas a la BD
module.exports = pool;