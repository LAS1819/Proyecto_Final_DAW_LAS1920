-- db_cuidandomiciudad.sql
-- Creamos BD
CREATE DATABASE db_cuidandomiciudad;

-- Usamos BD
USE db_cuidandomiciudad;

-- Tabla AYUNTAMIENTOS
CREATE TABLE `db_cuidandomiciudad`.`ayuntamientos` (
  `idAyuntamiento` INT(6) NOT NULL AUTO_INCREMENT,
  `nomAyuntamiento` VARCHAR(60) NOT NULL,
  `corAyuntamiento` VARCHAR(80) NOT NULL,
  `dirAyuntamiento` VARCHAR(60) NOT NULL,
  `pobAyuntamiento` VARCHAR(60) NOT NULL,
  `telAyuntamiento` VARCHAR(15) NOT NULL,
  `imgAyuntamiento` VARCHAR(45) NULL,
  PRIMARY KEY (`idAyuntamiento`),
  UNIQUE INDEX `corAyuntamiento_UNIQUE` (`corAyuntamiento` ASC) VISIBLE)
COMMENT = 'Tabla de los ayuntamientos';

---------Nueva tabla que no corresponde ni al modelo lógico ni E-R---------------
-- Se ha planteado durante la implantación de la aplicación
CREATE TABLE `db_cuidandomiciudad`.`ciudades` (
  `idCiudad` INT NOT NULL AUTO_INCREMENT,
  `idAyuntamiento` INT NOT NULL,
  `codPostal` VARCHAR(6) NOT NULL,
  `proCiudad` VARCHAR(60) NOT NULL,
  `nomCiudad` VARCHAR(60) NOT NULL,
  `imgCiudad` VARCHAR(20) NULL,
  PRIMARY KEY (`idCiudad`),
  INDEX `ca_ciu_Ayuntamiento_idx` (`idAyuntamiento` ASC) VISIBLE,
  UNIQUE INDEX `codPostal_UNIQUE` (`codPostal` ASC) VISIBLE,
  CONSTRAINT `ca_ciu_Ayuntamiento`
    FOREIGN KEY (`idAyuntamiento`)
    REFERENCES `db_cuidandomiciudad`.`ayuntamientos` (`idAyuntamiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Tabla para las ciudades';

-- Tabla de USUARIOS
CREATE TABLE `db_cuidandomiciudad`.`usuarios` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT,
  `idCiudad` INT(6) NOT NULL,
  `nickUsuario` VARCHAR(20) NOT NULL,
  `nomUsuario` VARCHAR(60) NOT NULL,
  `apeUsuario` VARCHAR(60) NOT NULL,
  `pasUsuario` VARCHAR(60) NOT NULL,
  `corUsuario` VARCHAR(80) NOT NULL,
  `ciuUsuario` VARCHAR(60) NOT NULL,
  `telUsuario` VARCHAR(15) NULL,
  `dirUsuario` VARCHAR(100) NOT NULL,
  `tipUsuario` ENUM('Freemium', 'Premium') NOT NULL DEFAULT 'Freemium',
  `fcRegistro` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idUsuario`),
  UNIQUE INDEX `corUsuario_UNIQUE` (`corUsuario` ASC) VISIBLE,
  UNIQUE INDEX `nickUsuario_UNIQUE` (`nickUsuario` ASC) VISIBLE,
  INDEX `ca_usu_ciudad_idx` (`idCiudad` ASC) VISIBLE,
  CONSTRAINT `ca_usu_ciudad`
    FOREIGN KEY (`idCiudad`)
    REFERENCES `db_cuidandomiciudad`.`ciudades` (`idCiudad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Tabla de usuarios';

-- Tabla usuarios PREMIUM
CREATE TABLE `db_cuidandomiciudad`.`premium` (
  `idPremium` INT NOT NULL AUTO_INCREMENT,
  `idUsuario` INT NOT NULL COMMENT 'Es PK porque es una especialización de la tabla Usuarios',
  `fcRegPremium` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fcFinRegistro` TIMESTAMP NOT NULL COMMENT 'La fecha final del registro es el final de la cuota Premium, por lo tanto debe estar definido por defecto, para que se introduzca automáticamente ',
  `premiumcol` VARCHAR(45) NULL,
  PRIMARY KEY (`idUsuario`),
  UNIQUE INDEX `idPremium_UNIQUE` (`idPremium` ASC) VISIBLE,
  CONSTRAINT `cp_premium`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `db_cuidandomiciudad`.`usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Tebla de usuarios Premium (heredada de Usuarios)';


-- Tabla INCIDENCIAS
CREATE TABLE `db_cuidandomiciudad`.`incidencias` (
  `idIncidencias` INT(6) NOT NULL AUTO_INCREMENT,
  `idUsuario` INT(6) NOT NULL,
  `idCiudad` INT(6) NOT NULL,
  `nomIncidencia` VARCHAR(60) NOT NULL,
  `menIncidencia` VARCHAR(60) NOT NULL,
  `locIncidencia` VARCHAR(60) NOT NULL COMMENT 'Descripción del lugar de la incidencia',
  `tipIncidencia` ENUM('Parques', 'Fachadas', 'Desperfectos', 'Limpieza', 'Manifestaciones', 'Abandono') NOT NULL,
  `ubiIncidencia` VARCHAR(60) NULL,
  `imgIncidencia` VARCHAR(45) NOT NULL,
  `fcCreacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `totVotos` INT(6) NOT NULL DEFAULT 0,
  PRIMARY KEY (`idIncidencias`),
  INDEX `ca_inc_usuario_idx` (`idUsuario` ASC) VISIBLE,
  INDEX `ca_inc_ciudad_idx` (`idCiudad` ASC) VISIBLE,
  CONSTRAINT `ca_inc_usuario`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `db_cuidandomiciudad`.`usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ca_inc_ciudad`
    FOREIGN KEY (`idCiudad`)
    REFERENCES `db_cuidandomiciudad`.`ciudades` (`idCiudad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Tabla de incidencias creadas por usuarios';

ALTER TABLE `db_cuidandomiciudad`.`incidencias` 
CHANGE COLUMN `menIncidencia` `menIncidencia` TEXT NOT NULL ;


-- Tabla PROPUESTAS
CREATE TABLE `db_cuidandomiciudad`.`propuestas` (
  `idPropuesta` INT NOT NULL AUTO_INCREMENT,
  `idIncidencia` INT NOT NULL,
  `idUsuario` INT NOT NULL,
  `nomPropuesta` VARCHAR(60) NOT NULL,
  `menPropuesta` TEXT NOT NULL,
  `totVotos` INT NOT NULL DEFAULT 0,
  `fcPropuesta` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idPropuesta`),
  INDEX `ca_pro_incidencia_idx` (`idIncidencia` ASC) VISIBLE,
  INDEX `ca_pro_usuario_idx` (`idUsuario` ASC) VISIBLE,
  CONSTRAINT `ca_pro_incidencia`
    FOREIGN KEY (`idIncidencia`)
    REFERENCES `db_cuidandomiciudad`.`incidencias` (`idIncidencias`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ca_pro_usuario`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `db_cuidandomiciudad`.`usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Tabla para las propuestas que provienen de las incidencias';

-- Tabla FIRMA (Nueva tabla relacional entre Usuarios y Propuestas)
-- En la tabla propuestas necesitamos guardar quién ha votado, para
--usarlo como muestra de firmas de personas reales
CREATE TABLE `db_cuidandomiciudad`.`firma` (
  `idUsuario` INT NOT NULL,
  `idPropuesta` INT NOT NULL,
  `fcFirma` TIMESTAMP NOT NULL,
  PRIMARY KEY (`idUsuario`, `idPropuesta`),
  INDEX `ca_fir_propuesta_idx` (`idPropuesta` ASC) VISIBLE,
  CONSTRAINT `ca_fir_usuario`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `db_cuidandomiciudad`.`usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ca_fir_propuesta`
    FOREIGN KEY (`idPropuesta`)
    REFERENCES `db_cuidandomiciudad`.`propuestas` (`idPropuesta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Tabla que contiene las firmas que realizan los usuarios a las propuestas';


-- Tabla NOTICIAS
CREATE TABLE `db_cuidandomiciudad`.`noticias` (
  `idNoticia` INT NOT NULL AUTO_INCREMENT,
  `idCiudad` INT NOT NULL,
  `nomNoticia` VARCHAR(60) NOT NULL,
  `menNoticia` TEXT NOT NULL,
  `totVotos` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idNoticia`),
  INDEX `ca_not_ciudad_idx` (`idCiudad` ASC) VISIBLE,
  CONSTRAINT `ca_not_ciudad`
    FOREIGN KEY (`idCiudad`)
    REFERENCES `db_cuidandomiciudad`.`ciudades` (`idCiudad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Tabla que contiene las noticias generadas en los envíos de avisos a los ayuntamientos.';

-- Tabla AVISOS
CREATE TABLE `db_cuidandomiciudad`.`avisos` (
  `idAviso` INT NOT NULL,
  `idAyuntamiento` INT NOT NULL,
  `nomAviso` VARCHAR(60) NOT NULL,
  `menAviso` TEXT NOT NULL,
  `imgAviso` VARCHAR(20) NULL,
  PRIMARY KEY (`idAviso`),
  INDEX `ca_avi_ayuntamiento_idx` (`idAyuntamiento` ASC) VISIBLE,
  CONSTRAINT `ca_avi_ayuntamiento`
    FOREIGN KEY (`idAyuntamiento`)
    REFERENCES `db_cuidandomiciudad`.`ayuntamientos` (`idAyuntamiento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Mensajes que se envían a los ayuntamientos con las propuestas para solucionar incidencias y las firmas de los usuarios que apoyan dicha propuesta';

-- Tabla GENERA
CREATE TABLE `db_cuidandomiciudad`.`genera` (
  `idNoticia` INT NOT NULL,
  `idAviso` INT NOT NULL,
  `idPropuesta` INT NOT NULL,
  `fcGenera` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idNoticia`, `idAviso`, `fcGenera`),
  INDEX `ca_gen_aviso_idx` (`idAviso` ASC) VISIBLE,
  INDEX `ca_gen_propuesta_idx` (`idPropuesta` ASC) VISIBLE,
  CONSTRAINT `ca_gen_aviso`
    FOREIGN KEY (`idAviso`)
    REFERENCES `db_cuidandomiciudad`.`avisos` (`idAviso`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ca_gen_noticia`
    FOREIGN KEY (`idNoticia`)
    REFERENCES `db_cuidandomiciudad`.`noticias` (`idNoticia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ca_gen_propuesta`
    FOREIGN KEY (`idPropuesta`)
    REFERENCES `db_cuidandomiciudad`.`propuestas` (`idPropuesta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Tabla que guarda los datos de la generación de un aviso';



-- Tabla PUBLICACIONES (Eliminada de la BD)
-- CREATE TABLE publicaciones(
-- 	idPublicacion INT(6) NOT NULL AUTO_INCREMENT,
-- 	idUsuario INT(6) NOT NULL,
-- 	nomPublicacion INT(6) NOT NULL,
-- 	menPublicacion TEXT NOT NULL,
-- 	fcPublicacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
-- 	totVotos INT(6) NOT NULL DEFAULT 0,
-- 		CONSTRAINT cp_publicacion PRIMARY KEY (idPublicacion),
-- 		CONSTRAINT ca_pub_usuario FOREIGN KEY (idUsuario)
-- 			REFERENCES usuarios(idUsuario)
-- );

-- Tabla COMENTARIOS
CREATE TABLE `db_cuidandomiciudad`.`comentarios` (
  `idComentario` INT NOT NULL AUTO_INCREMENT,
  `idUsuario` INT NOT NULL,
  `tipPublicacion` ENUM('Incidencia', 'Propuesta', 'Oferta', 'Noticia') NOT NULL,
  `idUbiComentario` INT NOT NULL COMMENT 'Contendrá la identidad de la publicación donde se comenta.',
  `menComentario` TEXT NOT NULL,
  `fcComentario` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `totVotaciones` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idComentario`),
  INDEX `ca_com_usuario_idx` (`idUsuario` ASC) VISIBLE,
  CONSTRAINT `ca_com_usuario`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `db_cuidandomiciudad`.`usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Contiene los comentarios que hacen los usuarios en las diferentes secciones';

-- Tabla OFERTAS
CREATE TABLE `db_cuidandomiciudad`.`ofertas` (
  `idOferta` INT NOT NULL AUTO_INCREMENT,
  `idUsuario` INT NOT NULL,
  `idCiudad` INT NOT NULL,
  `nomOferta` VARCHAR(60) NOT NULL,
  `menOferta` TEXT NOT NULL,
  `tipOferta` ENUM('Ayuda', 'Compañía', 'Pasear', 'Buscar', 'Pérdida') NOT NULL COMMENT 'Se podrán añadir o quitar tipos de ofertas en un futuro',
  `imgOferta` VARCHAR(45) NULL,
  `fcOferta` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idOferta`),
  INDEX `ca_ofe_usuario_idx` (`idUsuario` ASC) VISIBLE,
  INDEX `ca_ofe_ciudad_idx` (`idCiudad` ASC) VISIBLE,
  CONSTRAINT `ca_ofe_usuario`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `db_cuidandomiciudad`.`usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ca_ofe_ciudad`
    FOREIGN KEY (`idCiudad`)
    REFERENCES `db_cuidandomiciudad`.`ciudades` (`idCiudad`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Ofertas de los usuarios para requerrir u ofrecer voluntariados.';

-- Tabla DEMANDA
CREATE TABLE `db_cuidandomiciudad`.`demanda` (
  `idOferta` INT NOT NULL,
  `idUsuario` INT NOT NULL,
  `fcDemanda` TIMESTAMP NOT NULL,
  PRIMARY KEY (`idOferta`, `idUsuario`),
  INDEX `ca_dem_usuario_idx` (`idUsuario` ASC) VISIBLE,
  CONSTRAINT `ca_dem_usuario`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `db_cuidandomiciudad`.`usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Usuarios que demandan ofertas';

ALTER TABLE `db_cuidandomiciudad`.`demanda` 
ADD CONSTRAINT `ca_dem_oferta`
  FOREIGN KEY (`idOferta`)
  REFERENCES `db_cuidandomiciudad`.`ofertas` (`idOferta`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

-- Tabla DONACIONES
CREATE TABLE `db_cuidandomiciudad`.`donaciones` (
  `idDonacion` INT NOT NULL AUTO_INCREMENT,
  `cantDonacion` DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (`idDonacion`))
COMMENT = 'Información de las donaciones registradas';

-- Tabla ASOCIACIONES
CREATE TABLE `db_cuidandomiciudad`.`asociaciones` (
  `idAsociacion` INT NOT NULL AUTO_INCREMENT,
  `idUsuario` INT NOT NULL,
  `nomAsociacion` VARCHAR(60) NOT NULL,
  `desAsociacion` VARCHAR(160) NOT NULL,
  `numSocios` INT NOT NULL DEFAULT 1,
  `fcCreacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idAsociacion`),
  UNIQUE INDEX `nomAsociacion_UNIQUE` (`nomAsociacion` ASC) VISIBLE)
COMMENT = 'Tabla que contien las asociaciones creadas por los usuarios Premium';

ALTER TABLE `db_cuidandomiciudad`.`asociaciones` 
ADD INDEX `ca_aso_usuario_idx` (`idUsuario` ASC) VISIBLE;
;
ALTER TABLE `db_cuidandomiciudad`.`asociaciones` 
ADD CONSTRAINT `ca_aso_usuario`
  FOREIGN KEY (`idUsuario`)
  REFERENCES `db_cuidandomiciudad`.`usuarios` (`idUsuario`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

-- Tabla UNE
CREATE TABLE `db_cuidandomiciudad`.`une` (
  `idAsociacion` INT NOT NULL,
  `idUsuario` INT NOT NULL,
  `fcUnion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idAsociacion`, `idUsuario`))
COMMENT = 'Registro de Usuarios que se unen a Asociaciones';

ALTER TABLE `db_cuidandomiciudad`.`une` 
ADD INDEX `ca_une_usuario_idx` (`idUsuario` ASC) VISIBLE;
;
ALTER TABLE `db_cuidandomiciudad`.`une` 
ADD CONSTRAINT `ca_une_asociacion`
  FOREIGN KEY (`idAsociacion`)
  REFERENCES `db_cuidandomiciudad`.`asociaciones` (`idAsociacion`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `ca_une_usuario`
  FOREIGN KEY (`idUsuario`)
  REFERENCES `db_cuidandomiciudad`.`usuarios` (`idUsuario`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

-- Tabla DONA
CREATE TABLE `db_cuidandomiciudad`.`dona` (
  `idDonacion` INT NOT NULL,
  `idAsociacion` INT NOT NULL,
  `idUsuario` INT NOT NULL,
  `fcDonacion` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idDonacion`, `idAsociacion`),
  INDEX `ca_don_asociacion_idx` (`idAsociacion` ASC) VISIBLE,
  INDEX `ca_don_usuario_idx` (`idUsuario` ASC) VISIBLE,
  CONSTRAINT `ca_don_donacion`
    FOREIGN KEY (`idDonacion`)
    REFERENCES `db_cuidandomiciudad`.`donaciones` (`idDonacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ca_don_asociacion`
    FOREIGN KEY (`idAsociacion`)
    REFERENCES `db_cuidandomiciudad`.`asociaciones` (`idAsociacion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ca_don_usuario`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `db_cuidandomiciudad`.`usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Registro de donaciones que hacen los usuarios a las asociaciones';

-- Tabla ADMINISTRADOR
CREATE TABLE `db_cuidandomiciudad`.`administradores` (
  `idAdministrador` INT NOT NULL AUTO_INCREMENT,
  `nomAdministrador` VARCHAR(60) NOT NULL,
  `nickAdministrador` VARCHAR(20) NOT NULL,
  `corAdministrador` VARCHAR(60) NOT NULL,
  `pasAdministrador` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`idAdministrador`),
  UNIQUE INDEX `nickAdministrador_UNIQUE` (`nickAdministrador` ASC) VISIBLE,
  UNIQUE INDEX `corAdministrador_UNIQUE` (`corAdministrador` ASC) VISIBLE)
COMMENT = 'Tabla con información de los Administradores';

-- Tabla CONTACTA
CREATE TABLE `db_cuidandomiciudad`.`contacta` (
  `idAdministrador` INT NOT NULL,
  `idUsuario` INT NOT NULL,
  `menContacto` TEXT NOT NULL,
  `fcContacto` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idAdministrador`, `idUsuario`),
  INDEX `ca_con_usuario_idx` (`idUsuario` ASC) VISIBLE,
  CONSTRAINT `ca_con_administrador`
    FOREIGN KEY (`idAdministrador`)
    REFERENCES `db_cuidandomiciudad`.`administradores` (`idAdministrador`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ca_con_usuario`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `db_cuidandomiciudad`.`usuarios` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
COMMENT = 'Registro de contactos entre Administradores y Usuarios';


-----Data Manipulation Language DML-----------------------------

------------Datos de prueba--------------------------

-----Datos de prueba para la tabla AYUNTAMIENTOS----
INSERT INTO `db_cuidandomiciudad`.`ayuntamientos` (`nomAyuntamiento`, `corAyuntamiento`, `dirAyuntamiento`, `pobAyuntamiento`, `telAyuntamiento`) VALUES ('Ayuntamiento de Novelda', 'omac@novelda.es', 'Plaza De España 1', 'Novelda', '965602690');
INSERT INTO `db_cuidandomiciudad`.`ayuntamientos` (`nomAyuntamiento`, `corAyuntamiento`, `dirAyuntamiento`, `pobAyuntamiento`, `telAyuntamiento`) VALUES ('Ayuntamiento de Aspe', 'secretaria@ayto.aspe.es', 'Plaza Mayor 1', 'Aspe', '965492222');
INSERT INTO `db_cuidandomiciudad`.`ayuntamientos` (`nomAyuntamiento`, `corAyuntamiento`, `dirAyuntamiento`, `pobAyuntamiento`, `telAyuntamiento`) VALUES ('Ayuntamiento de la Romana', 'laromana@aytolaromana.es', 'Plaza Gómez Navarro', 'Romana, La', '965696001');
INSERT INTO `db_cuidandomiciudad`.`ayuntamientos` (`nomAyuntamiento`, `corAyuntamiento`, `dirAyuntamiento`, `pobAyuntamiento`, `telAyuntamiento`) VALUES ('Ayuntamiento de Monforte del Cid', 'eadministracion@monfortedelcid.es', 'Plaza España 1', 'Monforte del Cid', '965620025');
INSERT INTO `db_cuidandomiciudad`.`ayuntamientos` (`nomAyuntamiento`, `corAyuntamiento`, `dirAyuntamiento`, `pobAyuntamiento`, `telAyuntamiento`) VALUES ('Ayuntamiento de Monóvar/Monòver', 'monovar@dip-alicante.es', 'Plaza La Sala 1', 'Monóvar/Monòver', '965620025');

----Datos prueba para CIUDADES
INSERT INTO `db_cuidandomiciudad`.`ciudades` (`idAyuntamiento`, `codPostal`, `proCiudad`, `nomCiudad`) VALUES ('1', '03680', 'Alicante', 'Aspe');
INSERT INTO `db_cuidandomiciudad`.`ciudades` (`idAyuntamiento`, `codPostal`, `proCiudad`, `nomCiudad`) VALUES ('2', '03660', 'Alicante', 'Novelda');


----Datos prueba para USUARIOS
INSERT INTO `db_cuidandomiciudad`.`usuarios` (`idCiudad`, `nickUsuario`, `nomUsuario`, `apeUsuario`, `pasUsuario`, `corUsuario`, `ciuUsuario`, `telUsuario`, `dirUsuario`) VALUES ('2', 'Pack', 'Paco', 'Marín Seller', 'pacopass', 'paquitocho@gmail.com', 'Novelda', '666666663', 'C/ Jamón nº23 1ºA');
INSERT INTO `db_cuidandomiciudad`.`usuarios` (`idCiudad`, `nickUsuario`, `nomUsuario`, `apeUsuario`, `pasUsuario`, `corUsuario`, `ciuUsuario`, `telUsuario`, `dirUsuario`) VALUES ('1', 'Snake', 'David', 'Doe Sers', 'suneko', 'ssnake87@mgs.com', 'Gatxamiga', '888888886', 'C/ Esparta');
INSERT INTO `db_cuidandomiciudad`.`usuarios` (`idCiudad`, `nickUsuario`, `nomUsuario`, `apeUsuario`, `pasUsuario`, `corUsuario`, `ciuUsuario`, `telUsuario`, `dirUsuario`) VALUES ('2', 'Brb', 'Bárbara', 'Albert', 'ara', 'bbr@gmail.com', 'Novelda', '666555541', 'C/ Vale');
INSERT INTO `db_cuidandomiciudad`.`usuarios` (`idCiudad`, `nickUsuario`, `nomUsuario`, `apeUsuario`, `pasUsuario`, `corUsuario`, `ciuUsuario`, `dirUsuario`) VALUES ('1', 'David', 'David', 'Husselhoff', 'DHSk', 'dhoss@yahoo.com', 'Gatxamiga', 'Av/ Los Viernes nº6');
