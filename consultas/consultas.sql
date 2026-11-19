-- ==========================================================
-- Consultas sobre la base EduTech
-- Organizadas por nivel: BASICO -> INTERMEDIO/AVANZADO -> AVANZADO
-- Antes de ejecutar: importar la estructura y los datos de la base.
-- Cada consulta indica la pregunta que responde y la captura 
-- con el resultado obtenido en phpMyAdmin (carpeta capturas/).
-- Requiere MySQL / MariaDB.
-- Las consultas que devuelven varias filas llevan ORDER BY, para que el
-- resultado salga siempre en el mismo orden.
-- ==========================================================
USE EduTech;


-- ==========================================================
-- NIVEL 1: BASICO (una sola tabla)
-- ==========================================================

-- B01. Ver todos los estudiantes
-- Resultado: capturas/b01.png
SELECT * FROM estudiante
ORDER BY id;

-- B02. Nombre completo de cada estudiante (CONCAT y alias con AS)
-- Resultado: capturas/b02.png
SELECT CONCAT(nombre, ' ', apellido) AS nombre_completo,
       correo_electronico
FROM estudiante
ORDER BY id;

-- B03. Cursos que cuestan mas de 50000 (WHERE)
-- Resultado: capturas/b03.png
SELECT titulo, precio FROM curso WHERE precio > 50000
ORDER BY precio DESC;

-- B04. Cursos con precio entre 40000 y 50000 (BETWEEN)
-- Resultado: capturas/b04.png
SELECT titulo, precio FROM curso WHERE precio BETWEEN 40000 AND 50000
ORDER BY precio;

-- B05. Cursos cuyo titulo contiene "Introducción" (LIKE)
-- Resultado: capturas/b05.png
SELECT titulo FROM curso WHERE titulo LIKE '%Introducción%'
ORDER BY titulo;

-- B06. Cursos de las categorias 1 y 2 con precio menor a 50000 (IN y AND)
-- Resultado: capturas/b06.png
SELECT titulo, id_categoria, precio
FROM curso
WHERE id_categoria IN (1, 2) AND precio < 50000
ORDER BY id;

-- B07. Los 5 cursos mas caros (ORDER BY + LIMIT)
-- Resultado: capturas/b07.png
SELECT titulo, precio FROM curso ORDER BY precio DESC LIMIT 5;

-- B08. Precio promedio, minimo y maximo de los cursos (AVG, MIN, MAX)
-- Resultado: capturas/b08.png
SELECT COUNT(*) AS total_cursos,
       AVG(precio) AS precio_promedio,
       MIN(precio) AS mas_barato,
       MAX(precio) AS mas_caro
FROM curso;


-- ==========================================================
-- NIVEL 2: INTERMEDIO / AVANZADO (JOIN, GROUP BY, HAVING, LEFT JOIN)
-- ==========================================================

-- I01. Cursos con su categoria y su profesor (JOIN de 3 tablas)
-- Resultado: capturas/i01.png
SELECT c.titulo,
       cat.nombre AS categoria,
       CONCAT(p.nombre, ' ', p.apellido) AS profesor,
       c.precio
FROM curso c
JOIN categoria cat ON cat.id = c.id_categoria
JOIN profesor p ON p.id = c.id_profesor
ORDER BY c.id;

-- I02. Estudiantes inscriptos en "Introducción a Python"
-- Resultado: capturas/i02.png
SELECT e.nombre, e.apellido, i.fecha_inscripcion
FROM inscripcion i
JOIN estudiante e ON e.id = i.id_estudiante
JOIN curso c ON c.id = i.id_curso
WHERE c.titulo = 'Introducción a Python'
ORDER BY i.fecha_inscripcion;

-- I03. Lecciones de cada curso, con el titulo del curso
-- Resultado: capturas/i03.png
SELECT c.titulo AS curso, l.titulo AS leccion, l.duracion
FROM leccion l
JOIN curso c ON c.id = l.id_curso
ORDER BY c.id, l.id;

-- I04. Cuantos estudiantes tiene cada curso (GROUP BY + LEFT JOIN)
-- LEFT JOIN incluye tambien los cursos sin inscriptos (con 0)
-- Resultado: capturas/i04.png
SELECT c.titulo, COUNT(i.id) AS estudiantes_inscriptos
FROM curso c
LEFT JOIN inscripcion i ON i.id_curso = c.id
GROUP BY c.id, c.titulo
ORDER BY estudiantes_inscriptos DESC, c.id;

-- I05. Cuanto dinero recaudo cada curso (SUM)
-- Resultado: capturas/i05.png
SELECT c.titulo,
       COALESCE(SUM(i.costo_pagado), 0) AS ingresos
FROM curso c
LEFT JOIN inscripcion i ON i.id_curso = c.id
GROUP BY c.id, c.titulo
ORDER BY ingresos DESC, c.id;

-- I06. Cantidad de lecciones y duracion total de cada curso
-- TIME_TO_SEC convierte a segundos para poder sumar(duracion esta como hh:mm:ss); SEC_TO_TIME vuelve a pasarlo a hh:mm:ss
-- Resultado: capturas/i06.png
SELECT c.titulo,
       COUNT(l.id) AS cantidad_lecciones,
       SEC_TO_TIME(SUM(TIME_TO_SEC(l.duracion))) AS duracion_total
FROM curso c
LEFT JOIN leccion l ON l.id_curso = c.id
GROUP BY c.id, c.titulo
ORDER BY c.id;

-- I07. Cuantos cursos dicta cada profesor
-- LEFT JOIN para incluir profesores que todavia no dictan ningun curso
-- Resultado: capturas/i07.png
SELECT CONCAT(p.nombre, ' ', p.apellido) AS profesor,
       COUNT(c.id) AS cursos_dictados
FROM profesor p
LEFT JOIN curso c ON c.id_profesor = p.id
GROUP BY p.id, p.nombre, p.apellido
ORDER BY cursos_dictados DESC, p.id;

-- I08. Categorias que no tienen ningun curso 
-- Resultado: capturas/i08.png
SELECT cat.nombre
FROM categoria cat
LEFT JOIN curso c ON c.id_categoria = cat.id
WHERE c.id IS NULL
ORDER BY cat.id;

-- I09. Estudiantes inscriptos en mas de un curso (HAVING)
-- HAVING filtra sobre el resultado de la agrupacion (WHERE no puede hacerlo)
-- Resultado: capturas/i09.png
SELECT e.nombre, e.apellido, COUNT(i.id) AS cursos_inscriptos
FROM estudiante e
INNER JOIN inscripcion i ON i.id_estudiante = e.id
GROUP BY e.id, e.nombre, e.apellido
HAVING COUNT(i.id) > 1
ORDER BY cursos_inscriptos DESC, e.id;

-- I10. Cantidad de lecciones de cada curso 
-- LEFT JOIN para incluir tambien los cursos que todavia no tienen lecciones cargadas 
-- Resultado: capturas/i10.png
SELECT c.titulo,
       COUNT(l.id) AS cantidad_lecciones
FROM curso c
LEFT JOIN leccion l ON l.id_curso = c.id
GROUP BY c.id, c.titulo
ORDER BY c.id;

-- I11. Cantidad de inscripciones por estudiante 
-- LEFT JOIN para incluir tambien los estudiantes sin inscripciones (con 0)
-- Resultado: capturas/i11.png
SELECT e.nombre,
       e.apellido,
       COUNT(i.id) AS cantidad_inscripciones
FROM estudiante e
LEFT JOIN inscripcion i ON i.id_estudiante = e.id
GROUP BY e.id, e.nombre, e.apellido
ORDER BY e.id;

-- I12. Recaudacion total por categoria (LEFT JOIN encadenados + SUM + COALESCE)
-- COALESCE convierte en 0 el resultado cuando una categoria no tiene dinero recaudado
-- Resultado: capturas/i12.png
SELECT cat.nombre AS categoria,
       COALESCE(SUM(i.costo_pagado), 0) AS recaudado
FROM categoria cat
LEFT JOIN curso c ON cat.id = c.id_categoria
LEFT JOIN inscripcion i ON c.id = i.id_curso
GROUP BY cat.id, cat.nombre
ORDER BY recaudado DESC, cat.id ASC;

-- I13. Reporte por profesor: cursos dictados, inscripciones totales y dinero recaudado
-- COUNT(DISTINCT c.id) evita contar cursos repetidos por las multiples inscripciones.
-- Resultado: capturas/i13.png
SELECT p.nombre,
       p.apellido,
       COUNT(DISTINCT c.id) AS cantidad_cursos_dictados,
       COUNT(i.id) AS inscripciones_totales,
       COALESCE(SUM(i.costo_pagado), 0) AS recaudado_por_curso
FROM profesor p
LEFT JOIN curso c ON c.id_profesor = p.id
LEFT JOIN inscripcion i ON i.id_curso = c.id
GROUP BY p.id, p.nombre, p.apellido
ORDER BY p.id;

-- ==========================================================
-- NIVEL 3: AVANZADO (introduccion: subconsultas, fechas y CASE)
-- ==========================================================

-- A01. Cursos que cuestan mas que el precio promedio (subconsulta)
-- Resultado: capturas/a01.png
SELECT titulo, precio
FROM curso
WHERE precio > (SELECT AVG(precio) FROM curso)
ORDER BY precio DESC;

-- A02. Cantidad de inscripciones por dia (funciones de fecha)
-- Resultado: capturas/a02.png
SELECT DATE(fecha_inscripcion) AS dia, COUNT(*) AS inscripciones
FROM inscripcion
GROUP BY DATE(fecha_inscripcion)
ORDER BY dia;

-- A03. Clasificar cursos segun su precio (CASE)
-- Resultado: capturas/a03.png
SELECT titulo,
       precio,
       CASE
           WHEN precio < 40000 THEN 'Economico'
           WHEN precio < 55000 THEN 'Intermedio'
           ELSE 'Premium'
       END AS gama
FROM curso
ORDER BY precio;
