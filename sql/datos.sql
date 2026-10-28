-- ==========================================
-- Script de Inserción de Datos (DML)
-- ==========================================
USE EduTech;
 
-- Datos para la tabla `categoria` 
INSERT INTO categoria (nombre) VALUES
('Programación'),
('Base de Datos'),
('Diseño UX/UI');
 
-- Datos para la tabla `profesor` 
INSERT INTO profesor (nombre, apellido, correo_electronico) VALUES
('Carlos', 'Gómez', 'carlos.gomez@edutech.com'),
('Ana', 'Martínez', 'ana.martinez@edutech.com');
 
-- Datos para la tabla `estudiante` 
INSERT INTO estudiante (nombre, apellido, correo_electronico) VALUES
('Lucas', 'Pérez', 'lucas.perez@alumnos.com'),
('Sofía', 'Rodríguez', 'sofia.rodriguez@alumnos.com');
 
-- Datos para la tabla `curso` 
INSERT INTO curso (titulo, descripcion, precio, id_categoria, id_profesor) VALUES
('Introducción a Python', 'Aprenderás las bases de la programación desde cero con Python.', 45000.00, 1, 1),
('SQL y Bases de Datos Relacionales', 'Diseño y consultas eficientes en MySQL.', 50000.00, 2, 2);
 
-- Datos para la tabla `leccion`
INSERT INTO leccion (titulo, duracion, id_curso) VALUES
('Instalación de entorno', '00:30:00', 1),
('Variables y Tipos de Datos', '00:45:00', 1),
('¿Qué es una Base de Datos?', '00:25:00', 2),
('Comando SELECT básico', '00:50:00', 2);
 
-- Datos para la tabla `inscripcion`
INSERT INTO inscripcion (id_estudiante, id_curso, fecha_inscripcion, costo_pagado) VALUES
(1, 1, '2026-10-01 10:30:00', 45000.00), 
(1, 2, '2026-10-02 14:15:00', 50000.00), 
(2, 1, '2026-10-03 09:00:00', 45000.00); 
 

 