// index.js
const express = require('express');
const router = express.Router();

router.get('/', (req, res, next) => {
	res.render('home', {layout: 'default', template: 'home-template'});
});