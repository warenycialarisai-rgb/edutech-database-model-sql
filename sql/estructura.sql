-- ==========================================
-- Script de Creación de Base de Datos (DDL)
-- Proyecto: EduTech - Plataforma de cursos online
-- ==========================================

CREATE DATABASE IF NOT EXISTS EduTech;
USE EduTech;

--  Estructura para la tabla categoria
CREATE TABLE categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL UNIQUE
);
 
--  Estructura para la tabla profesor
CREATE TABLE profesor (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    apellido VARCHAR(130) NOT NULL,
    correo_electronico VARCHAR(150) NOT NULL UNIQUE
);
 
-- Estructura para la tabla estudiante
CREATE TABLE estudiante (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    apellido VARCHAR(130) NOT NULL,
    correo_electronico VARCHAR(150) NOT NULL UNIQUE
);
 
-- Estructura para la tabla curso
-- id_profesor NOT NULL + FK: todo curso tiene un profesor existente
CREATE TABLE curso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(120),
    precio DECIMAL(15, 2) NOT NULL,
    id_categoria INT NOT NULL,
    id_profesor INT NOT NULL,
    CONSTRAINT chk_curso_precio CHECK (precio >= 0),
    CONSTRAINT fk_curso_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_curso_profesor FOREIGN KEY (id_profesor) REFERENCES profesor(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
 
-- Estructura para la tabla leccion
-- Si se borra un curso, sus lecciones se borran con el 
CREATE TABLE leccion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(50) NOT NULL,
    duracion TIME NOT NULL, -- Formato horas, minutos y segundos
    id_curso INT NOT NULL,
    CONSTRAINT chk_leccion_duracion CHECK (duracion > '00:00:00'),
    CONSTRAINT fk_leccion_curso FOREIGN KEY (id_curso) REFERENCES curso(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
 
-- Estructura para la tabla inscripcion 
-- UNIQUE id_estudiante y id_curso un estudiante no se inscribe dos veces al mismo curso
-- costo_pagado guarda el precio pagado(historial), aunque el precio de lista cambie despsues
CREATE TABLE inscripcion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_curso INT NOT NULL,
    fecha_inscripcion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    costo_pagado DECIMAL(15, 2) NOT NULL,
    CONSTRAINT chk_inscripcion_costo CHECK (costo_pagado >= 0),
    CONSTRAINT uq_inscripcion UNIQUE (id_estudiante, id_curso),
    CONSTRAINT fk_inscripcion_estudiante FOREIGN KEY (id_estudiante) REFERENCES estudiante(id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_inscripcion_curso FOREIGN KEY (id_curso) REFERENCES curso(id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
 