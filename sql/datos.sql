-- ==========================================
-- Script de Inserción de Datos (DML)
-- ==========================================
USE EduTech;
 
-- Datos para la tabla `categoria` 
INSERT INTO categoria (nombre) VALUES
('Programación'),
('Base de Datos'),
('Diseño UX/UI'),
('Redes'),
('Ciberseguridad'),
('Testing y QA'),
('Marketing Digital'),
('Idiomas'),
('Gestión de Proyectos'),
('Inteligencia Artificial');
 
-- Datos para la tabla `profesor` 
INSERT INTO profesor (nombre, apellido, correo_electronico) VALUES
('Carlos', 'Gómez', 'carlos.gomez@edutech.com'),
('Ana', 'Martínez', 'ana.martinez@edutech.com'),
('Marcos', 'Fernández', 'marcos.fernandez@edutech.com'),
('Laura', 'Sánchez', 'laura.sanchez@edutech.com'),
('Diego', 'López', 'diego.lopez@edutech.com'),
('Valeria', 'Romero', 'valeria.romero@edutech.com'),
('Martín', 'Acosta', 'martin.acosta@edutech.com'),
('Julieta', 'Benítez', 'julieta.benitez@edutech.com'),
('Federico', 'Díaz', 'federico.diaz@edutech.com'),
('Camila', 'Torres', 'camila.torres@edutech.com');
 
-- Datos para la tabla `estudiante` 
INSERT INTO estudiante (nombre, apellido, correo_electronico) VALUES
('Lucas', 'Pérez', 'lucas.perez@alumnos.com'),
('Sofía', 'Rodríguez', 'sofia.rodriguez@alumnos.com'),
('Martina', 'Gutiérrez', 'martina.gutierrez@alumnos.com'),
('Mateo', 'Silva', 'mateo.silva@alumnos.com'),
('Valentina', 'Ramírez', 'valentina.ramirez@alumnos.com'),
('Santiago', 'Flores', 'santiago.flores@alumnos.com'),
('Camila', 'Herrera', 'camila.herrera@alumnos.com'),
('Joaquín', 'Medina', 'joaquin.medina@alumnos.com'),
('Lucía', 'Castro', 'lucia.castro@alumnos.com'),
('Tomás', 'Ortiz', 'tomas.ortiz@alumnos.com'),
('Florencia', 'Ruiz', 'florencia.ruiz@alumnos.com'),
('Nicolás', 'Molina', 'nicolas.molina@alumnos.com'),
('Agustina', 'Vega', 'agustina.vega@alumnos.com'),
('Facundo', 'Ríos', 'facundo.rios@alumnos.com'),
('Milagros', 'Peralta', 'milagros.peralta@alumnos.com'),
('Bruno', 'Aguirre', 'bruno.aguirre@alumnos.com'),
('Julieta', 'Domínguez', 'julieta.dominguez@alumnos.com'),
('Ezequiel', 'Núñez', 'ezequiel.nunez@alumnos.com'),
('Rocío', 'Cabrera', 'rocio.cabrera@alumnos.com'),
('Gonzalo', 'Paz', 'gonzalo.paz@alumnos.com');

 
-- Datos para la tabla `curso` 
INSERT INTO curso (titulo, descripcion, precio, id_categoria, id_profesor) VALUES
('Introducción a Python', 'Aprenderás las bases de la programación desde cero con Python.', 45000.00, 1, 1),
('SQL y Bases de Datos Relacionales', 'Diseño y consultas eficientes en MySQL.', 50000.00, 2, 2),
('JavaScript desde Cero', 'Fundamentos de JavaScript para crear páginas web interactivas.', 42000.00, 1, 3),
('Desarrollo Web con HTML y CSS', 'Maquetación de sitios web modernos y adaptables a celulares.', 38000.00, 1, 3),
('Java para Principiantes', 'Programación orientada a objetos con Java paso a paso.', 48000.00, 1, 4),
('MySQL Avanzado', 'Vistas, índices, procedimientos almacenados y triggers.', 65000.00, 2, 2),
('Introducción a MongoDB', 'Bases de datos no relacionales y modelado de documentos.', 52000.00, 2, 5),
('Redes para Principiantes', 'Conceptos de redes, direccionamiento IP y configuración básica.', 40000.00, 4, 6),
('Seguridad Informática Básica', 'Buenas prácticas para proteger datos, cuentas y dispositivos.', 55000.00, 5, 6),
('Fundamentos de Testing de Software', 'Tipos de prueba, casos de prueba y reporte de defectos.', 47000.00, 6, 7),
('Automatización de Pruebas con Selenium', 'Automatizá pruebas web con Selenium y buenas prácticas.', 70000.00, 6, 7),
('Marketing Digital Esencial', 'Redes sociales, publicidad online y métricas básicas.', 36000.00, 7, 8),
('Metodologías Ágiles con Scrum', 'Roles, eventos y artefactos de Scrum en equipos reales.', 44000.00, 9, 9),
('Introducción a la Inteligencia Artificial', 'Qué es la IA, cómo aprende una máquina y sus aplicaciones.', 60000.00, 10, 5),
('Git y GitHub para Equipos', 'Control de versiones, ramas y trabajo colaborativo.', 30000.00, 1, 4);
 
-- Datos para la tabla `leccion`
INSERT INTO leccion (titulo, duracion, id_curso) VALUES
('Instalación de entorno', '00:30:00', 1),
('Variables y Tipos de Datos', '00:45:00', 1),
('¿Qué es una Base de Datos?', '00:25:00', 2),
('Comando SELECT básico', '00:50:00', 2),
('Introducción a JavaScript', '00:35:00', 3),
('Funciones y eventos', '00:50:00', 3),
('Estructura de una página HTML', '00:40:00', 4),
('Estilos con CSS', '00:55:00', 4),
('Instalación de Java y primer programa', '00:45:00', 5),
('Clases y objetos', '01:00:00', 5),
('Vistas e índices', '00:50:00', 6),
('Procedimientos almacenados', '01:10:00', 6),
('¿Qué es una base de datos no relacional?', '00:30:00', 7),
('Modelado de documentos', '00:55:00', 7),
('Modelo OSI y TCP/IP', '00:45:00', 8),
('Direccionamiento IP', '00:50:00', 8),
('Amenazas informáticas comunes', '00:40:00', 9),
('Contraseñas y autenticación', '00:35:00', 9),
('Qué es el testing de software', '00:30:00', 10),
('Diseño de casos de prueba', '00:55:00', 10),
('Instalación de Selenium', '00:25:00', 11),
('Primer script de automatización', '01:05:00', 11),
('Estrategia en redes sociales', '00:40:00', 12),
('Publicidad online y métricas', '00:50:00', 12),
('Roles y eventos de Scrum', '00:45:00', 13),
('El tablero y el backlog', '00:35:00', 13),
('¿Qué es la inteligencia artificial?', '00:30:00', 14),
('Aprendizaje automático básico', '00:55:00', 14),
('Primeros pasos con Git', '00:30:00', 15),
('Ramas y Pull Requests', '00:50:00', 15);
 
-- Datos para la tabla `inscripcion`
INSERT INTO inscripcion (id_estudiante, id_curso, fecha_inscripcion, costo_pagado) VALUES
(1, 1, '2026-10-01 10:30:00', 45000.00), 
(1, 2, '2026-10-02 14:15:00', 50000.00), 
(2, 1, '2026-10-03 09:00:00', 45000.00),
(3, 1, '2026-10-04 11:20:00', 45000.00),
(3, 3, '2026-10-05 16:45:00', 42000.00),
(4, 1, '2026-10-06 08:55:00', 45000.00),
(4, 2, '2026-10-07 19:10:00', 50000.00),
(4, 10, '2026-10-08 13:30:00', 47000.00),
(5, 3, '2026-10-09 10:05:00', 42000.00),
(5, 4, '2026-10-09 10:40:00', 38000.00),
(6, 5, '2026-10-10 15:25:00', 48000.00),
(6, 2, '2026-10-11 09:15:00', 40000.00),  
(7, 10, '2026-10-12 12:00:00', 47000.00),
(7, 11, '2026-10-13 18:35:00', 63000.00),  
(8, 6, '2026-10-14 14:50:00', 65000.00),
(8, 2, '2026-10-15 10:20:00', 50000.00),
(9, 8, '2026-10-16 11:45:00', 40000.00),
(9, 9, '2026-10-17 17:00:00', 55000.00),
(10, 1, '2026-10-18 20:10:00', 45000.00),
(10, 15, '2026-10-19 09:30:00', 30000.00),
(11, 12, '2026-10-20 13:15:00', 36000.00),
(11, 3, '2026-10-21 16:40:00', 42000.00),
(12, 14, '2026-10-22 10:50:00', 60000.00),
(13, 10, '2026-10-23 15:05:00', 42300.00), 
(14, 4, '2026-10-24 12:25:00', 38000.00),
(15, 5, '2026-10-25 19:55:00', 48000.00),
(16, 6, '2026-10-26 09:40:00', 58500.00), 
(17, 15, '2026-10-27 14:00:00', 30000.00),
(17, 1, '2026-10-28 11:10:00', 45000.00);
 

 