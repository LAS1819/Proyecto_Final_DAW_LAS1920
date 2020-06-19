// auth.js
// Usamos un método de passport para saber si existe el usuario o no
module.exports = {

	isLoggedIn(req, res, next) {
		if (req.isAuthenticated()) {
			return next();
		}
		return res.redirect('/signin');
	}
};