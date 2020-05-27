-- db_cuidandomiciudad.sql
USE db_cuidandomiciudad;

-- Tabla de USUARIOS
CREATE TABLE usuarios(
	idUsuario INT(6) NOT NULL AUTO_INCREMENT,
	nomUsuario VARCHAR(60) NOT NULL,
	pasUsuario VARCHAR(60) NOT NULL,
	corUsuario VARCHAR(80) NOT NULL,
	ciuUsuario VARCHAR(20) NOT NULL,
	telUsuario VARCHAR(15),
	dirUsuario VARCHAR(100) NOT NULL,
	tipUsuario ENUM('Freemium', 'Premium') NOT NULL DEFAULT 'Freemium',
	fcRegistro timestamp NOT NULL DEFAULT current_timestamp,
		CONSTRAINT pk_usuarios PRIMARY KEY (idUsuario)
);

-- Tabla usuarios PREMIUM
CREATE TABLE premium(
	idPremium int(6) NOT NULL AUTO_INCREMENT,
	idUsuario int(6) NOT NULL,
	fcRegPremium timestamp NOT NULL DEFAULT current_timestamp,
	fcFinPremium date NOT NULL,
		CONSTRAINT pk_premium PRIMARY KEY (idUsuario),
		CONSTRAINT uk_premium UNIQUE KEY (idPremium),
		CONSTRAINT fk_usuarios FOREIGN KEY (idUsuario) REFERENCES usuarios(idUsuario)
);