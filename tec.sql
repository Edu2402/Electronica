-- ================================================================
-- SOLUCIÓN RÁPIDA: AGREGAR COLUMNA CODIGO_BARRAS
-- ================================================================
-- 
-- IMPORTANTE: Este script solo agrega la columna faltante
-- NO borra datos existentes
-- 
-- INSTRUCCIONES:
-- 1. Abre phpMyAdmin (http://localhost/phpmyadmin)
-- 2. Selecciona tu base de datos "login_sistema"
-- 3. Haz clic en la pestaña "SQL"
-- 4. Copia y pega el código de abajo
-- 5. Haz clic en "Continuar"
-- 
-- ================================================================

USE `login_sistema`;

-- Agregar la columna CODIGO_BARRAS a la tabla insumos
ALTER TABLE `insumos` 
ADD COLUMN `CODIGO_BARRAS` VARCHAR(50) NULL 
AFTER `DESCRIPCION`;

-- Verificar que se agregó correctamente
DESCRIBE `insumos`;

-- ================================================================
-- RESULTADO ESPERADO:
-- ================================================================
-- Deberías ver una tabla con las siguientes columnas:
-- 
-- idINSUMOS
-- LABORATORIOS_idLABORATORIOS
-- NOMBRE
-- DESCRIPCION
-- CODIGO_BARRAS          <--- NUEVA COLUMNA
-- CANTIDAD_DIS
-- ESTATUS
-- 
-- ================================================================

SELECT '✓ Columna CODIGO_BARRAS agregada exitosamente' AS Mensaje;