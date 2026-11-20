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

-- ---------- PREPARACIÓN ----------
SELECT * FROM profesor
WHERE correo_electronico IN ('qa.profesor@test.edutech', 'qa.profesor.nuevo@test.edutech');
-- esperado: 0 filas

INSERT INTO profesor (nombre, apellido, correo_electronico)
VALUES ('QA', 'Profesor', 'qa.profesor@test.edutech');

SELECT * FROM profesor WHERE correo_electronico = 'qa.profesor@test.edutech';   -- precondición: 1 fila

-- ---------- EJECUCIÓN ----------
UPDATE profesor
SET correo_electronico = 'qa.profesor.nuevo@test.edutech'
WHERE correo_electronico = 'qa.profesor@test.edutech';

-- ---------- VERIFICACIONES ----------
SELECT * FROM profesor WHERE correo_electronico = 'qa.profesor.nuevo@test.edutech';  -- esperado: 1 fila
SELECT * FROM profesor WHERE correo_electronico = 'qa.profesor@test.edutech';        -- esperado: 0 filas

-- ---------- LIMPIEZA ----------
DELETE FROM profesor WHERE correo_electronico = 'qa.profesor.nuevo@test.edutech';

SELECT * FROM profesor WHERE correo_electronico LIKE 'qa.profesor%@test.edutech';    -- esperado: 0 filas

-- Repetir SNAPSHOT: debe coincidir con el inicial.


-- =====================================================================
-- CASO DE PRUEBA 3: Restricción de borrado (ON DELETE RESTRICT)
--   Dado que existe el estudiante "QA Estudiante"
--   Y que está inscripto al curso "QA Curso Prueba"
--   Cuando se intenta eliminar el estudiante
--   Entonces la base rechaza la eliminación (error 1451)
--   Y el estudiante y su inscripción siguen existiendo
-- =====================================================================

-- ---------- PREPARACIÓN ----------
INSERT INTO categoria (nombre) VALUES ('QA Categoria');

INSERT INTO profesor (nombre, apellido, correo_electronico)
VALUES ('QA', 'Profesor', 'qa.profesor@test.edutech');

INSERT INTO estudiante (nombre, apellido, correo_electronico)
VALUES ('QA', 'Estudiante', 'qa.estudiante@test.edutech');

INSERT INTO curso (titulo, descripcion, precio, id_categoria, id_profesor)
VALUES (
  'QA Curso Prueba', 'Curso para testing', 1000.00,
  (SELECT id FROM categoria WHERE nombre = 'QA Categoria'),
  (SELECT id FROM profesor  WHERE correo_electronico = 'qa.profesor@test.edutech')
);

INSERT INTO inscripcion (id_estudiante, id_curso, costo_pagado)
VALUES (
  (SELECT id FROM estudiante WHERE correo_electronico = 'qa.estudiante@test.edutech'),
  (SELECT id FROM curso      WHERE titulo = 'QA Curso Prueba'),
  1000.00
);

-- Precondición: la inscripción existe (esperado: 1 fila)
SELECT i.*
FROM inscripcion i
JOIN estudiante e ON e.id = i.id_estudiante
WHERE e.correo_electronico = 'qa.estudiante@test.edutech';

-- ---------- EJECUCIÓN ----------
-- Ejecutar esta sentencia SOLA. phpMyAdmin mostrará el error:
-- #1451 - Cannot delete or update a parent row: a foreign key constraint fails
DELETE FROM estudiante WHERE correo_electronico = 'qa.estudiante@test.edutech';

-- ---------- VERIFICACIONES ----------
SELECT * FROM estudiante WHERE correo_electronico = 'qa.estudiante@test.edutech';   -- esperado: 1 fila
SELECT i.*
FROM inscripcion i
JOIN estudiante e ON e.id = i.id_estudiante
WHERE e.correo_electronico = 'qa.estudiante@test.edutech';                           -- esperado: 1 fila

-- ---------- LIMPIEZA (hijos antes que padres) ----------
DELETE FROM inscripcion
WHERE id_estudiante = (SELECT id FROM estudiante WHERE correo_electronico = 'qa.estudiante@test.edutech');

DELETE FROM estudiante WHERE correo_electronico = 'qa.estudiante@test.edutech';
DELETE FROM curso      WHERE titulo = 'QA Curso Prueba';
DELETE FROM profesor   WHERE correo_electronico = 'qa.profesor@test.edutech';
DELETE FROM categoria  WHERE nombre = 'QA Categoria';

-- Verificar limpieza total (esperado: 0 filas en cada una)
SELECT * FROM estudiante WHERE correo_electronico = 'qa.estudiante@test.edutech';
SELECT * FROM curso      WHERE titulo = 'QA Curso Prueba';
SELECT * FROM profesor   WHERE correo_electronico = 'qa.profesor@test.edutech';
SELECT * FROM categoria  WHERE nombre = 'QA Categoria';

-- Repetir SNAPSHOT: debe coincidir con el inicial.
