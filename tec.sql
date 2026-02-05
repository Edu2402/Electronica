-- =============================================================
-- SISTEMA DE LOGIN - BASE DE DATOS CORREGIDA
-- Nombre de BD: login_sistema (minúsculas, consistente)
-- =============================================================

-- Crear base de datos si no existe
CREATE DATABASE IF NOT EXISTS `login_sistema` 
DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Usar la base de datos
USE `login_sistema`;

-- Desactivar temporalmente las restricciones de clave foránea
SET FOREIGN_KEY_CHECKS = 0;

-- Eliminar tablas si existen (en orden correcto)
DROP TABLE IF EXISTS `solicitud_insumos`;
DROP TABLE IF EXISTS `prestamos`;
DROP TABLE IF EXISTS `reporte`;
DROP TABLE IF EXISTS `reportes`;
DROP TABLE IF EXISTS `insumos`;
DROP TABLE IF EXISTS `laboratorios`;
DROP TABLE IF EXISTS `usuarios`;
DROP TABLE IF EXISTS `personas`;

-- Reactivar restricciones
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================
-- TABLA PERSONAS - Información principal de usuarios
-- =============================================================
CREATE TABLE `personas` (
    `idPERSONAS` int(11) NOT NULL AUTO_INCREMENT,
    `NOMBRE` varchar(100) NOT NULL,
    `PATERNO` varchar(100) NOT NULL,
    `MATERNO` varchar(100) DEFAULT NULL,
    `CORREO` varchar(200) DEFAULT NULL,
    `TELEFONO` varchar(15) DEFAULT NULL,
    `ROL` enum('alumno','maestro','trabajador') NOT NULL,
    `ESTATUS` tinyint(1) DEFAULT 1,
    `FECHA_REGISTRO` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`idPERSONAS`),
    INDEX `idx_rol` (`ROL`),
    INDEX `idx_estatus` (`ESTATUS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- TABLA USUARIOS - Credenciales de acceso
-- =============================================================
CREATE TABLE `usuarios` (
    `idUSUARIOS` int(11) NOT NULL AUTO_INCREMENT,
    `NUM_USUARIO` varchar(8) NOT NULL,
    `PIN` varchar(4) NOT NULL,
    `PERSONAS_idPERSONAS` int(11) NOT NULL,
    `FECHA_CREACION` timestamp DEFAULT CURRENT_TIMESTAMP,
    `ULTIMO_ACCESO` timestamp NULL DEFAULT NULL,
    PRIMARY KEY (`idUSUARIOS`),
    UNIQUE KEY `NUM_USUARIO_UNIQUE` (`NUM_USUARIO`),
    KEY `FK_USUARIOS_PERSONAS` (`PERSONAS_idPERSONAS`),
    CONSTRAINT `FK_USUARIOS_PERSONAS` 
        FOREIGN KEY (`PERSONAS_idPERSONAS`) 
        REFERENCES `personas` (`idPERSONAS`) 
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- TABLA LABORATORIOS
-- =============================================================
CREATE TABLE `laboratorios` (
    `idLABORATORIOS` int(11) NOT NULL AUTO_INCREMENT,
    `PERSONAS_idPERSONAS` int(11) NOT NULL,
    `NOM_LAB` varchar(50) DEFAULT NULL,
    `ENCARGADO_LAB` varchar(30) DEFAULT NULL,
    `HORARIO` time DEFAULT NULL,
    `UBICACION` varchar(30) DEFAULT NULL,
    PRIMARY KEY (`idLABORATORIOS`),
    KEY `FK_LABORATORIOS_PERSONAS` (`PERSONAS_idPERSONAS`),
    CONSTRAINT `FK_LABORATORIOS_PERSONAS` 
        FOREIGN KEY (`PERSONAS_idPERSONAS`) 
        REFERENCES `personas` (`idPERSONAS`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- TABLA INSUMOS
-- =============================================================
CREATE TABLE `insumos` (
    `idINSUMOS` int(11) NOT NULL AUTO_INCREMENT,
    `LABORATORIOS_idLABORATORIOS` int(11) NOT NULL,
    `NOMBRE` varchar(30) DEFAULT NULL,
    `DESCRIPCION` varchar(200) DEFAULT NULL,
    `CODIGO_BARRAS` varchar(50) DEFAULT NULL,
    `CANTIDAD_DIS` int DEFAULT NULL,
    `ESTATUS` tinyint(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (`idINSUMOS`),
    KEY `FK_INSUMOS_LABORATORIOS` (`LABORATORIOS_idLABORATORIOS`),
    CONSTRAINT `FK_INSUMOS_LABORATORIOS` 
        FOREIGN KEY (`LABORATORIOS_idLABORATORIOS`) 
        REFERENCES `laboratorios` (`idLABORATORIOS`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- TABLA PRESTAMOS
-- =============================================================
CREATE TABLE `prestamos` (
    `idPRESTAMOS` int(11) NOT NULL AUTO_INCREMENT,
    `PERSONAS_idPERSONAS` int(11) NOT NULL,
    `INSUMOS_idINSUMOS` int(11) NOT NULL,
    `FECHA_PRESTA` date DEFAULT NULL,
    `FECHA_DEV` date DEFAULT NULL,
    `ESTATUS` tinyint(1) NOT NULL DEFAULT 1,
    `CANTIDAD` int DEFAULT NULL,
    PRIMARY KEY (`idPRESTAMOS`),
    KEY `FK_PRESTAMOS_PERSONAS` (`PERSONAS_idPERSONAS`),
    KEY `FK_PRESTAMOS_INSUMOS` (`INSUMOS_idINSUMOS`),
    CONSTRAINT `FK_PRESTAMOS_PERSONAS` 
        FOREIGN KEY (`PERSONAS_idPERSONAS`) 
        REFERENCES `personas` (`idPERSONAS`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_PRESTAMOS_INSUMOS` 
        FOREIGN KEY (`INSUMOS_idINSUMOS`) 
        REFERENCES `insumos` (`idINSUMOS`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- TABLA REPORTE
-- =============================================================
CREATE TABLE `reporte` (
    `idREPORTE` int(11) NOT NULL AUTO_INCREMENT,
    `LABORATORIOS_idLABORATORIOS` int(11) NOT NULL,
    `PERSONAS_idPERSONAS` int(11) NOT NULL,
    `TIPO_REPORTE` varchar(30) DEFAULT NULL,
    `DESCRIPCION` varchar(200) DEFAULT NULL,
    `FECHA` date DEFAULT NULL,
    PRIMARY KEY (`idREPORTE`),
    KEY `FK_REPORTE_LABORATORIOS` (`LABORATORIOS_idLABORATORIOS`),
    KEY `FK_REPORTE_PERSONAS` (`PERSONAS_idPERSONAS`),
    CONSTRAINT `FK_REPORTE_LABORATORIOS` 
        FOREIGN KEY (`LABORATORIOS_idLABORATORIOS`) 
        REFERENCES `laboratorios` (`idLABORATORIOS`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_REPORTE_PERSONAS` 
        FOREIGN KEY (`PERSONAS_idPERSONAS`) 
        REFERENCES `personas` (`idPERSONAS`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- TABLA SOLICITUD_INSUMOS
-- =============================================================
CREATE TABLE `solicitud_insumos` (
    `idSOLICITUD` int(11) NOT NULL AUTO_INCREMENT,
    `PERSONAS_idPERSONAS` int(11) NOT NULL,
    `INSUMOS_idINSUMOS` int(11) NOT NULL,
    `CANTIDAD` int DEFAULT NULL,
    `FECHA_SOLICITUD` date DEFAULT NULL,
    `ESTATUS` tinyint(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (`idSOLICITUD`),
    KEY `FK_SOLICITUD_INSUMOS_PERSONAS` (`PERSONAS_idPERSONAS`),
    KEY `FK_SOLICITUD_INSUMOS_INSUMOS` (`INSUMOS_idINSUMOS`),
    CONSTRAINT `FK_SOLICITUD_INSUMOS_PERSONAS` 
        FOREIGN KEY (`PERSONAS_idPERSONAS`) 
        REFERENCES `personas` (`idPERSONAS`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `FK_SOLICITUD_INSUMOS_INSUMOS` 
        FOREIGN KEY (`INSUMOS_idINSUMOS`) 
        REFERENCES `insumos` (`idINSUMOS`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- TABLA REPORTES (NUEVA)
-- =============================================================
CREATE TABLE `reportes` (
  `idReporte` int(11) NOT NULL,
  `tipo_incidencia` varchar(100) NOT NULL,
  `elabora` varchar(100) NOT NULL,
  `reporta` varchar(100) NOT NULL,
  `responsable` varchar(100) NOT NULL,
  `descripcion` text NOT NULL,
  `estatus` varchar(50) NOT NULL DEFAULT 'Pendiente',
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `accion` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE actividad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(100),
    rol VARCHAR(50),
    descripcion TEXT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

--
-- Volcado de datos para la tabla `reportes`
--
INSERT INTO `reportes` (`idReporte`, `tipo_incidencia`, `elabora`, `reporta`, `responsable`, `descripcion`, `estatus`, `fecha`, `accion`) VALUES
(1, 'Daño de equipo', 'Mario ', 'mario', 'juan', 'se rompio el ups', 'En revisión', '2025-10-13 06:15:54', NULL),
(2, 'Daño de equipo', 'Mario ', 'Pedro ', 'Memito', 'se rompio un cable ', 'En revisión', '2025-10-14 01:23:37', 'El responsable pago los daños '),
(5, 'Pérdida de material', 'juan', 'pedro', 'mario', 'se porto mal ', 'En revisión', '2025-10-14 01:33:45', 'regaño');

--
-- Indices de la tabla `reportes`
--
ALTER TABLE `reportes`
  ADD PRIMARY KEY (`idReporte`);

--
-- AUTO_INCREMENT de la tabla `reportes`
--
ALTER TABLE `reportes`
  MODIFY `idReporte` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

-- =============================================================
-- DATOS INICIALES - USUARIOS DE PRUEBA
-- =============================================================

-- Insertar personas de prueba
INSERT INTO `personas` (`NOMBRE`, `PATERNO`, `MATERNO`, `CORREO`, `TELEFONO`, `ROL`, `ESTATUS`) VALUES
('David Eduardo', 'De la Rosa', 'Muñiz', 'david.delarosa@tecnm.mx', '8441234567', 'trabajador', 1),
('Juan Carlos', 'Lopez', 'Garcia', 'juan.lopez@tecnm.mx', '8441234568', 'maestro', 1),
('Maria Elena', 'Rodriguez', 'Martinez', 'maria.rodriguez@tecnm.mx', '8441234569', 'alumno', 1),
('Ana Sofia', 'Gonzalez', 'Hernindez', 'ana.gonzalez@estudiante.tecnm.mx', '8441234570', 'alumno', 1);

-- Insertar usuarios de prueba con credenciales especificas
INSERT INTO `usuarios` (`NUM_USUARIO`, `PIN`, `PERSONAS_idPERSONAS`) VALUES
('20051171', '2402', 1),  -- David Eduardo (Trabajador)
('20051172', '1234', 2),  -- Juan Carlos (Maestro)  
('20051173', '5678', 3),  -- Maria Elena (Alumno)
('20051174', '9012', 4);  -- Ana Sofia (Alumno)

-- =============================================================
-- VERIFICACIONES Y CONSULTAS DE PRUEBA
-- =============================================================

-- Verificar que los datos se insertaron correctamente
SELECT 'VERIFICACIÓN DE USUARIOS REGISTRADOS:' AS Info;

SELECT 
    p.NOMBRE,
    p.PATERNO,
    p.MATERNO,
    p.ROL,
    p.CORREO,
    p.TELEFONO,
    u.NUM_USUARIO,
    u.PIN,
    p.ESTATUS,
    u.FECHA_CREACION
FROM personas p 
INNER JOIN usuarios u ON p.idPERSONAS = u.PERSONAS_idPERSONAS
ORDER BY u.NUM_USUARIO;

-- Verificar estructura de las tablas principales
SELECT 'ESTRUCTURA TABLA PERSONAS:' AS Info;
DESCRIBE personas;

SELECT 'ESTRUCTURA TABLA USUARIOS:' AS Info;
DESCRIBE usuarios;

-- Verificar restricciones de clave foránea
SELECT 'RESTRICCIONES DE CLAVE FORÁNEA:' AS Info;
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'login_sistema'
AND REFERENCED_TABLE_NAME IS NOT NULL;

-- Contar registros por tabla
SELECT 'RESUMEN DE REGISTROS:' AS Info;
SELECT 
    (SELECT COUNT(*) FROM personas) AS Total_Personas,
    (SELECT COUNT(*) FROM usuarios) AS Total_Usuarios,
    (SELECT COUNT(*) FROM personas WHERE ESTATUS = 1) AS Personas_Activas,
    (SELECT COUNT(*) FROM personas WHERE ROL = 'trabajador') AS Trabajadores,
    (SELECT COUNT(*) FROM personas WHERE ROL = 'maestro') AS Maestros,
    (SELECT COUNT(*) FROM personas WHERE ROL = 'alumno') AS Alumnos;

-- =============================================================
-- CONSULTA ESPECÍFICA PARA VERIFICAR LOGIN
-- =============================================================
SELECT 'PRUEBA DE LOGIN PARA USUARIO 20051171:' AS Info;

SELECT 
    p.idPERSONAS,
    p.NOMBRE,
    p.PATERNO,
    p.MATERNO,
    p.ROL,
    p.ESTATUS,
    u.NUM_USUARIO,
    u.PIN,
    CASE 
        WHEN u.NUM_USUARIO = '20051171' AND u.PIN = '2402' AND p.ESTATUS = 1 
        THEN 'LOGIN EXITOSO' 
        ELSE 'LOGIN FALLIDO' 
    END AS Resultado_Login
FROM personas p 
INNER JOIN usuarios u ON p.idPERSONAS = u.PERSONAS_idPERSONAS 
WHERE u.NUM_USUARIO = '20051171';

-- Mensaje de finalización
SELECT 'BASE DE DATOS CONFIGURADA CORRECTAMENTE' AS Status;