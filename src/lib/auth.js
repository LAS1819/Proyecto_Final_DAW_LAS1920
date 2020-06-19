// auth.js
// Usamos un método de passport para saber si existe el usuario o no
module.exports = {
	// Comprobamos si está logeado
	isLoggedIn(req, res, next) {
		if (req.isAuthenticated()) {
			return next();
		}
		return res.redirect('/signin');
	},

	// Comprobamos si NO está logeado
	isNotLoggedIn(req, res, next) {
		if (!req.isAuthenticated()) {
			return next();
		}
		return res.redirect('/profile');
	}
};