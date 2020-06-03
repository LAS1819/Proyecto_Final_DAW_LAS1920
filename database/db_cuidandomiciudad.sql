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
	fcRegistro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		CONSTRAINT cp_usuarios PRIMARY KEY (idUsuario)
);

-- Tabla usuarios PREMIUM
CREATE TABLE premium(
	idPremium INT(6) NOT NULL AUTO_INCREMENT,
	idUsuario INT(6) NOT NULL,
	fcRegPremium TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	fcFinPremium DATE NOT NULL,
		CONSTRAINT cp_premium PRIMARY KEY (idUsuario),
		CONSTRAINT cu_premium UNIQUE KEY (idPremium),
		CONSTRAINT ca_usuario FOREIGN KEY (idUsuario)
			REFERENCES usuarios(idUsuario)
);

--------------------------------------------------------------------------------

-- Tabla INCIDENCIAS
CREATE TABLE incidencias(
	idIncidencia INT(6) NOT NULL AUTO_INCREMENT,
	idUsuario INT(6) NOT NULL,
	nomIncidencia VARCHAR(60) NOT NULL,
	menIncidencia TEXT NOT NULL,
	totVotos INT(6) NOT NULL DEFAULT 0,
	tipIncidencia ENUM('Parques', 'Fachadas', 'Desperfectos', 'Limpieza', 'Manifestaciones', 'Abandono') NOT NULL,
	-- TO DO: comprobar cómo son los datos recibidos de un geolocalizador
	ubiIncidencia VARCHAR(50),
	-- TO DO: comprobar cómo subir imagen a la base de datos y el tipo de dato correcto (BLOB, MEDIUMBLOB o LONGBLOB)
	imgIncidencia BLOB,
	fcCreacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		CONSTRAINT cp_incidencia PRIMARY KEY (idIncidencia, idUsuario),
		CONSTRAINT ca_usuario FOREIGN KEY (idUsuario)
			REFERENCES usuarios(idUsuario)
);


-- Tabla PROPUESTAS
CREATE TABLE propuestas(
	idPropuesta INT(6) NOT NULL AUTO_INCREMENT,
	idIncidencia INT(6) NOT NULL,
	nomPropuesta VARCHAR(60),
	menPropuesta TEXT NOT NULL,
	totVotos INT(6) NOT NULL DEFAULT 0,
		CONSTRAINT cp_propuesta PRIMARY KEY (idPropuesta, idIncidencia),
		CONSTRAINT ca_incidencia FOREIGN KEY (idIncidencia)
			REFERENCES incidencias(idIncidencia)
);

-- Tabla NOTICIAS
CREATE TABLE noticias(
	idNoticia INT(6) NOT NULL AUTO_INCREMENT,
	nomNoticia VARCHAR(60) NOT NULL,
	menNoticia TEXT NOT NULL,
	totVotos INT(6) NOT NULL DEFAULT 0,
		CONSTRAINT cp_noticia PRIMARY KEY (idNoticia)
);

-- Tabla AYUNTAMIENTOS
CREATE TABLE ayuntamientos(
	idAyuntamiento INT(6) NOT NULL AUTO_INCREMENT,
	nomAyuntamiento VARCHAR(60) NOT NULL,
	corAyuntamiento VARCHAR(80) NOT NULL,
	dirAyuntamiento VARCHAR(60) NOT NULL,
	pobAyuntamiento VARCHAR(60) NOT NULL,
	telAyuntamiento VARCHAR(15) NOT NULL,
		CONSTRAINT cp_ayuntamiento PRIMARY KEY (idAyuntamiento)
);

-- Tabla AVISOS
CREATE TABLE avisos(
	idAviso INT(6) NOT NULL AUTO_INCREMENT,
	idAyuntamiento INT(6) NOT NULL,
	nomAviso VARCHAR(60),
	menAviso TEXT NOT NULL,
	imgAviso BLOB,
		CONSTRAINT cp_aviso PRIMARY KEY (idAviso, idAyuntamiento),
		CONSTRAINT ca_ayuntamiento FOREIGN KEY (idAyuntamiento)
			REFERENCES ayuntamientos(idAyuntamiento)
);

-- Tabla GENERA
CREATE TABLE genera(
	idNoticia INT(6) NOT NULL,
	idAviso INT(6) NOT NULL,
	idPropuesta INT(6) NOT NULL,
	fcGenera TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		CONSTRAINT cp_genera PRIMARY KEY (idNoticia, idAviso, fcGenera),
		CONSTRAINT ca_aviso FOREIGN KEY (idAviso)
			REFERENCES avisos(idAviso),
		CONSTRAINT ca_noticia FOREIGN KEY (idNoticia)
			REFERENCES noticias(idNoticia),
		CONSTRAINT vnn_propuesta FOREIGN KEY (idPropuesta)
			REFERENCES propuestas(idPropuesta)
);

------------------------------------------------------------------------------

-- Tabla PUBLICACIONES
CREATE TABLE publicaciones(
	idPublicacion INT(6) NOT NULL AUTO_INCREMENT,
	idUsuario INT(6) NOT NULL,
	nomPublicacion INT(6) NOT NULL,
	menPublicacion TEXT NOT NULL,
	fcPublicacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	totVotos INT(6) NOT NULL DEFAULT 0,
		CONSTRAINT cp_publicacion PRIMARY KEY (idPublicacion, idUsuario),
		CONSTRAINT ca_pub_usuario FOREIGN KEY (idUsuario)
			REFERENCES usuarios(idUsuario)
);

-- Tabla COMENTARIOS
CREATE TABLE comentarios(
	idComentario INT(6) NOT NULL AUTO_INCREMENT,
	idPublicacion INT(6) NOT NULL,
	idUsuario INT(6) NOT NULL,
	menComentario TEXT NOT NULL,
	fcComentario TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		CONSTRAINT cp_comentario PRIMARY KEY (idComentario, idUsuario, idPublicacion),
		CONSTRAINT ca_com_publicacion FOREIGN KEY (idPublicacion)
			REFERENCES publicaciones(idPublicacion),
		CONSTRAINT ca_com_usuario FOREIGN KEY (idUsuario)
			REFERENCES usuarios(idUsuario)
);

-- Tabla OFERTAS
CREATE TABLE ofertas(
	idOferta INT(6) NOT NULL AUTO_INCREMENT,
	idUsuario INT(6) NOT NULL,
	nomOferta VARCHAR(60) NOT NULL,
	fcOferta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	tipOferta ENUM('Ayuda', 'Compañía', 'Pasear', 'Buscar', 'Pérdida'),
		CONSTRAINT cp_oferta PRIMARY KEY (idOferta, idUsuario),
		CONSTRAINT ca_ofe_usuario FOREIGN KEY (idUsuario)
			REFERENCES usuarios(idUsuario)
);

-- Tabla DEMANDA
CREATE TABLE demanda(
	idOferta INT(6) NOT NULL,
	idUsuario INT(6) NOT NULL,
	fcDemanda TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		CONSTRAINT cp_demanda PRIMARY KEY (idOferta, idUsuario),
		CONSTRAINT ca_dem_oferta FOREIGN KEY (idOferta)
			REFERENCES ofertas(idOferta),
		CONSTRAINT ca_dem_usuario FOREIGN KEY (idUsuario)
			REFERENCES usuarios(idUsuario)
);

-- Tabla DONACIONES
CREATE TABLE donaciones(
	idDonacion INT(6) NOT NULL AUTO_INCREMENT,
	cantDonacion DECIMAL(6, 2) NOT NULL,
		CONSTRAINT cp_donacion PRIMARY KEY (idDonacion)
);

-- Tabla ASOCIACIONES
CREATE TABLE asociaciones(
	idAsociacion INT(6) NOT NULL AUTO_INCREMENT,
	idUsuario INT(6) NOT NULL,
	fcCreacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	nomAsociacion VARCHAR(60) NOT NULL,
	desAsociacion VARCHAR(200) NOT NULL,
	numSocios INT(6) NOT NULL DEFAULT 0,
		CONSTRAINT cp_asociacion PRIMARY KEY (idAsociacion, idUsuario),
		CONSTRAINT ca_aso_usuario FOREIGN KEY (idUsuario)
			REFERENCES usuarios(idUsuario),
		CONSTRAINT cu_aso_asociacion UNIQUE KEY (nomAsociacion)
);

-- Tabla UNE
CREATE TABLE une(
	idAsociacion INT(6) NOT NULL,
	idUsuario INT(6) NOT NULL,
	fcUnion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		CONSTRAINT cp_une PRIMARY KEY (idAsociacion, idUsuario),
		CONSTRAINT ca_une_asociacion FOREIGN KEY (idAsociacion)
			REFERENCES asociaciones(idAsociacion),
		CONSTRAINT ca_une_usuario FOREIGN KEY (idUsuario)
			REFERENCES usuarios(idUsuario)
);

-- Tabla DONA
CREATE TABLE dona(
	idDonacion INT(6) NOT NULL,
	idAsociacion INT(6) NOT NULL,
	idUsuario INT(6) NOT NULL,
	fcDonacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	cantDonacion DECIMAL(6, 2) NOT NULL,
		CONSTRAINT cp_dona PRIMARY KEY (idDonacion, idAsociacion),
		CONSTRAINT ca_dona_donacion FOREIGN KEY (idDonacion)
			REFERENCES donaciones(idDonacion),
		CONSTRAINT ca_dona_asociacion FOREIGN KEY (idAsociacion)
			REFERENCES asociaciones(idAsociacion),
		CONSTRAINT vnn_dona_usuario FOREIGN KEY (idUsuario)
			REFERENCES usuarios(idUsuario)
);

-- Tabla ADMINISTRADOR
CREATE TABLE administrador (
	idAdministrador INT(6) NOT NULL AUTO_INCREMENT,
	nomAdministrador VARCHAR(60) NOT NULL,
	corAdministrador VARCHAR(80) NOT NULL,
	pasAdministrador VARCHAR(60) NOT NULL,
		CONSTRAINT cp_administrador PRIMARY KEY (idAdministrador),
		CONSTRAINT cu_administrador UNIQUE KEY (corAdministrador)
);

-- Tabla CONTACTA
CREATE TABLE contacta (
	idUsuario INT(6) NOT NULL,
	idAdministrador INT(6) NOT NULL,
	fcContacto TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	menContacto TEXT NOT NULL,
		CONSTRAINT cp_contacto PRIMARY KEY (idUsuario, idAdministrador),
		CONSTRAINT ca_con_usuario FOREIGN KEY (idUsuario)
			REFERENCES usuarios(idUsuario),
		CONSTRAINT ca_con_administrador FOREIGN KEY (idAdministrador)
			REFERENCES administrador(idAdministrador)
);