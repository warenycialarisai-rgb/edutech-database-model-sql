-- =====================================================================
-- CASOS DE PRUEBA - EduTech (MySQL + phpMyAdmin)
-- Regla: no se toca ningún dato existente. Todo lo que se crea lleva
-- "QA" en el nombre o el dominio @test.edutech y se elimina al final.
-- No se usan IDs fijos ni variables (@): phpMyAdmin pierde las variables
-- entre ejecuciones. Los registros se identifican por valores únicos.
-- Ejecutar sentencia por sentencia (pegar en la pestaña SQL > Continuar)
-- para tomar la captura de cada step.
-- =====================================================================
USE EduTech;

-- ---------------------------------------------------------------------
-- SNAPSHOT: ejecutar al inicio y al final de cada caso
-- Los totales deben ser IDÉNTICOS antes y después
-- Esperado:categoría 10, profesor 10, estudiante 20, curso 15, lección 30 e inscripción 29
-- ---------------------------------------------------------------------
SELECT 'categoria' AS tabla, COUNT(*) AS total FROM categoria
UNION ALL SELECT 'profesor',    COUNT(*) FROM profesor
UNION ALL SELECT 'estudiante',  COUNT(*) FROM estudiante
UNION ALL SELECT 'curso',       COUNT(*) FROM curso
UNION ALL SELECT 'leccion',     COUNT(*) FROM leccion
UNION ALL SELECT 'inscripcion', COUNT(*) FROM inscripcion;


-- =====================================================================
-- CASO DE PRUEBA 1: Eliminación en cascada curso -> lecciones
--   Dado que existe el curso "QA Curso Prueba"
--   Y que el curso tiene 2 lecciones
--   Cuando se elimina el curso
--   Entonces el curso no existe
--   Y las lecciones del curso no existen
-- =====================================================================

-- Paso 00: SNAPSHOT inicial (la consulta de totales del inicio del archivo)
-- esperado: categoria 10, profesor 10, estudiante 20, curso 15, leccion 30, inscripcion 29

-- ---------- PREPARACIÓN ----------
-- 0) Verificar que los datos de prueba NO existen (esperado: 0 filas en cada una)
SELECT * FROM categoria WHERE nombre = 'QA Categoria';
SELECT * FROM profesor  WHERE correo_electronico = 'qa.profesor@test.edutech';
SELECT * FROM curso     WHERE titulo = 'QA Curso Prueba';

-- 1) Categoría y profesor (curso los exige NOT NULL)
INSERT INTO categoria (nombre) VALUES ('QA Categoria');

INSERT INTO profesor (nombre, apellido, correo_electronico)
VALUES ('QA', 'Profesor', 'qa.profesor@test.edutech');

-- 2) Curso (los ids se obtienen con subconsultas)
INSERT INTO curso (titulo, descripcion, precio, id_categoria, id_profesor)
VALUES (
  'QA Curso Prueba', 'Curso para testing', 1000.00,
  (SELECT id FROM categoria WHERE nombre = 'QA Categoria'),
  (SELECT id FROM profesor  WHERE correo_electronico = 'qa.profesor@test.edutech')
);

-- 3) Dos lecciones
INSERT INTO leccion (titulo, duracion, id_curso) VALUES
('QA Leccion 1', '00:30:00', (SELECT id FROM curso WHERE titulo = 'QA Curso Prueba')),
('QA Leccion 2', '00:45:00', (SELECT id FROM curso WHERE titulo = 'QA Curso Prueba'));

-- 4) Verificar precondición: 1 curso y 2 lecciones
SELECT * FROM curso WHERE titulo = 'QA Curso Prueba';                 -- esperado: 1 fila
SELECT l.*
FROM leccion l
JOIN curso c ON c.id = l.id_curso
WHERE c.titulo = 'QA Curso Prueba';                                   -- esperado: 2 filas

-- ---------- EJECUCIÓN ----------
DELETE FROM curso WHERE titulo = 'QA Curso Prueba';

-- ---------- VERIFICACIONES ----------
SELECT * FROM curso   WHERE titulo = 'QA Curso Prueba';              -- esperado: 0 filas
SELECT * FROM leccion WHERE titulo LIKE 'QA Leccion%';               -- esperado: 0 filas

-- ---------- LIMPIEZA (curso y lecciones ya se borraron) ----------
DELETE FROM profesor  WHERE correo_electronico = 'qa.profesor@test.edutech';
DELETE FROM categoria WHERE nombre = 'QA Categoria';

-- Verificar limpieza total (esperado: 0 filas en cada una)
SELECT * FROM profesor  WHERE correo_electronico = 'qa.profesor@test.edutech';
SELECT * FROM categoria WHERE nombre = 'QA Categoria';

-- Repetir SNAPSHOT: debe coincidir con el inicial.
-- Esperado:categoría 10, profesor 10, estudiante 20, curso 15, lección 30 e inscripción 29

-- =====================================================================
-- CASO DE PRUEBA 2: Actualización de email del profesor
--   Dado que existe el profesor "QA Profesor"
--   Cuando se actualiza su correo electrónico
--   Entonces el profesor tiene el correo actualizado
--   Y el correo anterior ya no está asociado a ningún profesor
-- =====================================================================

-- Paso 00: SNAPSHOT inicial (la consulta de totales del inicio del archivo)
-- esperado: categoria 10, profesor 10, estudiante 20, curso 15, leccion 30, inscripcion 29


-- ---------- PREPARACIÓN ----------

-- Paso 01: verificar que el profesor de prueba no existe, ni con el correo original
-- ni con el actualizado (esperado: 0 filas)
SELECT * FROM profesor
WHERE correo_electronico IN ('qa.profesor@test.edutech', 'qa.profesor.nuevo@test.edutech');

-- Paso 02: insertar el profesor (esperado: 1 fila insertada)
INSERT INTO profesor (nombre, apellido, correo_electronico)
VALUES ('QA', 'Profesor', 'qa.profesor@test.edutech');

-- Paso 03: verificar la precondición, el profesor existe (esperado: 1 fila)
SELECT * FROM profesor WHERE correo_electronico = 'qa.profesor@test.edutech';


-- ---------- EJECUCIÓN ----------

-- Paso 04: actualizar el correo del profesor (esperado: 1 fila afectada)
UPDATE profesor
SET correo_electronico = 'qa.profesor.nuevo@test.edutech'
WHERE correo_electronico = 'qa.profesor@test.edutech';


-- ---------- VERIFICACIONES ----------

-- Paso 05: el profesor tiene el correo nuevo (esperado: 1 fila)
SELECT * FROM profesor WHERE correo_electronico = 'qa.profesor.nuevo@test.edutech';

-- Paso 06: el correo anterior ya no existe (esperado: 0 filas)
SELECT * FROM profesor WHERE correo_electronico = 'qa.profesor@test.edutech';


-- ---------- LIMPIEZA ----------

-- Paso 07: eliminar el profesor (esperado: 1 fila eliminada)
DELETE FROM profesor WHERE correo_electronico = 'qa.profesor.nuevo@test.edutech';

-- Paso 08: verificar que el profesor ya no existe (esperado: 0 filas)
SELECT * FROM profesor WHERE correo_electronico LIKE 'qa.profesor%@test.edutech';


-- ---------- ESTADO FINAL ----------

-- Paso 09: SNAPSHOT final (repetir la consulta de totales del inicio del archivo)
-- esperado: los mismos totales que en el paso 00

-- =====================================================================
-- CASO DE PRUEBA 3: Restricción de borrado (ON DELETE RESTRICT)
--   Dado que existe el estudiante "QA Estudiante"
--   Y que está inscripto al curso "QA Curso Prueba"
--   Cuando se intenta eliminar el estudiante
--   Entonces la base rechaza la eliminación (error 1451)
--   Y el estudiante y su inscripción siguen existiendo
-- =====================================================================

-- Paso 00: SNAPSHOT inicial (la consulta de totales del inicio del archivo)
-- esperado: categoria 10, profesor 10, estudiante 20, curso 15, leccion 30, inscripcion 29


-- ---------- PREPARACIÓN ----------

-- Paso 01: verificar que la categoría de prueba no existe (esperado: 0 filas)
SELECT * FROM categoria WHERE nombre = 'QA Categoria';

-- Paso 02: verificar que el profesor de prueba no existe (esperado: 0 filas)
SELECT * FROM profesor WHERE correo_electronico = 'qa.profesor@test.edutech';

-- Paso 03: verificar que el estudiante de prueba no existe (esperado: 0 filas)
SELECT * FROM estudiante WHERE correo_electronico = 'qa.estudiante@test.edutech';

-- Paso 04: verificar que el curso de prueba no existe (esperado: 0 filas)
SELECT * FROM curso WHERE titulo = 'QA Curso Prueba';

-- Paso 05: verificar que la inscripción de prueba no existe (esperado: 0 filas)
SELECT i.*
FROM inscripcion i
JOIN estudiante e ON e.id = i.id_estudiante
WHERE e.correo_electronico = 'qa.estudiante@test.edutech';

-- Paso 06: insertar la categoría (esperado: 1 fila insertada)
INSERT INTO categoria (nombre) VALUES ('QA Categoria');

-- Paso 07: insertar el profesor (esperado: 1 fila insertada)
INSERT INTO profesor (nombre, apellido, correo_electronico)
VALUES ('QA', 'Profesor', 'qa.profesor@test.edutech');

-- Paso 08: insertar el estudiante (esperado: 1 fila insertada)
INSERT INTO estudiante (nombre, apellido, correo_electronico)
VALUES ('QA', 'Estudiante', 'qa.estudiante@test.edutech');

-- Paso 09: insertar el curso (esperado: 1 fila insertada)
-- Los ids de categoría y profesor se obtienen con subconsultas.
INSERT INTO curso (titulo, descripcion, precio, id_categoria, id_profesor)
VALUES (
  'QA Curso Prueba', 'Curso para testing', 1000.00,
  (SELECT id FROM categoria WHERE nombre = 'QA Categoria'),
  (SELECT id FROM profesor  WHERE correo_electronico = 'qa.profesor@test.edutech')
);

-- Paso 10: insertar la inscripción (esperado: 1 fila insertada)
INSERT INTO inscripcion (id_estudiante, id_curso, costo_pagado)
VALUES (
  (SELECT id FROM estudiante WHERE correo_electronico = 'qa.estudiante@test.edutech'),
  (SELECT id FROM curso      WHERE titulo = 'QA Curso Prueba'),
  1000.00
);

-- Paso 11: verificar la precondición, la inscripción existe (esperado: 1 fila)
SELECT i.*
FROM inscripcion i
JOIN estudiante e ON e.id = i.id_estudiante
WHERE e.correo_electronico = 'qa.estudiante@test.edutech';


-- ---------- EJECUCIÓN ----------

-- Paso 12: intentar eliminar el estudiante
-- Ejecutar esta sentencia SOLA: el error corta la ejecución de lo que venga después.
-- Esta misma sentencia es la acción ("Cuando") y donde se ve el rechazo ("Entonces"):
-- phpMyAdmin muestra el error en pantalla. Esa es la captura.
-- esperado: #1451 - Cannot delete or update a parent row: a foreign key constraint fails
DELETE FROM estudiante WHERE correo_electronico = 'qa.estudiante@test.edutech';


-- ---------- VERIFICACIONES ----------

-- Paso 13: el estudiante sigue existiendo (esperado: 1 fila)
SELECT * FROM estudiante WHERE correo_electronico = 'qa.estudiante@test.edutech';

-- Paso 14: la inscripción sigue existiendo (esperado: 1 fila)
SELECT i.*
FROM inscripcion i
JOIN estudiante e ON e.id = i.id_estudiante
WHERE e.correo_electronico = 'qa.estudiante@test.edutech';


-- ---------- LIMPIEZA (hijos antes que padres) ----------

-- Paso 15: eliminar la inscripción (esperado: 1 fila eliminada)
DELETE FROM inscripcion
WHERE id_estudiante = (SELECT id FROM estudiante WHERE correo_electronico = 'qa.estudiante@test.edutech');

-- Paso 16: eliminar el estudiante (esperado: 1 fila eliminada)
DELETE FROM estudiante WHERE correo_electronico = 'qa.estudiante@test.edutech';

-- Paso 17: eliminar el curso (esperado: 1 fila eliminada)
DELETE FROM curso WHERE titulo = 'QA Curso Prueba';

-- Paso 18: eliminar el profesor (esperado: 1 fila eliminada)
DELETE FROM profesor WHERE correo_electronico = 'qa.profesor@test.edutech';

-- Paso 19: eliminar la categoría (esperado: 1 fila eliminada)
DELETE FROM categoria WHERE nombre = 'QA Categoria';

-- Paso 20: verificar que el estudiante ya no existe (esperado: 0 filas)
SELECT * FROM estudiante WHERE correo_electronico = 'qa.estudiante@test.edutech';

-- Paso 21: verificar que el curso ya no existe (esperado: 0 filas)
SELECT * FROM curso WHERE titulo = 'QA Curso Prueba';

-- Paso 22: verificar que el profesor ya no existe (esperado: 0 filas)
SELECT * FROM profesor WHERE correo_electronico = 'qa.profesor@test.edutech';

-- Paso 23: verificar que la categoría ya no existe (esperado: 0 filas)
SELECT * FROM categoria WHERE nombre = 'QA Categoria';


-- ---------- ESTADO FINAL ----------

-- Paso 24: SNAPSHOT final (repetir la consulta de totales del inicio del archivo)
-- esperado: los mismos totales que en el paso 00
