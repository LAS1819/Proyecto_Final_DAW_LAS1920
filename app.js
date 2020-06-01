// app.js
const express = require('express');
// Requerimos handlebars
const hbs = require('express-handlebars');
// Requerimos path
const path = require('path');

// Iniciamos conexión
const app = express();



// Configuramos el acceso a las vistas
app.set('views', path.join(__dirname, 'views'));

// Configuramos view engine para handlebars
app.engine('handlebars', hbs({defaultLayout: 'default'}));

// Advertimos de la extensión que usaremos en los archivos handlebars (hbs)
app.set('view engine', 'handlebars');

// Configuramos el puerto
app.set('port', (process.env.PORT || 3000));


// La url o ruta raíz(/) responde con la renderización de handlebars
app.get('/', (req, res) => {
	res.render('index', {
		content: 'Esto es algo de contenido'	
	});
});

// Dejamos el servidor a la escucha
app.listen(app.get('port'), () => {
	console.log('Server started on port ' + app.get('port'));
})

// app.engine('hbs', hbs({
// 	extname: 'hbs',
// 	defaultView: 'default',
// 	layoutsDir: __dirname + '/views/default/',
// 	partialsDir: __dirname + '/views/partials/'
// }));




// Nuestro servidor escucha desde el puerto 3000
// app.listen(3000, () => {
// 	console.log('Apliación escuchando desde el puerto 3000...');
// });