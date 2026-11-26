# Documento de requerimientos: plataforma de cursos online (EduTech)


## 1. Objetivo general

Diseñar e implementar una base de datos relacional que permita gestionar la oferta de cursos en línea, su clasificación por categorías, los profesores que los dictan, los estudiantes registrados y el proceso de inscripción de los estudiantes a los cursos.

## 2. Entidades y reglas de negocio

### A. Categoría

- Cada curso debe pertenecer obligatoriamente a una categoría (por ejemplo: Programación, Diseño Gráfico, Bases de Datos).
- De cada categoría se registra: identificador único y nombre.
- El nombre de la categoría es obligatorio, no puede repetirse y tiene un máximo de 25 caracteres.
- Una categoría puede tener muchos cursos, o ninguno mientras no se haya cargado alguno.

### B. Profesor

- Es la persona que crea y dicta cursos en la plataforma.
- De cada profesor se registra: identificador único, nombre, apellido y correo electrónico.
- Nombre (máximo 120 caracteres), apellido (máximo 130) y correo electrónico (máximo 150) son obligatorios.
- El correo electrónico no puede repetirse entre profesores.
- Un profesor puede dictar muchos cursos, o ninguno.

### C. Estudiante

- Es la persona que se inscribe a los cursos de la plataforma.
- De cada estudiante se registra: identificador único, nombre, apellido y correo electrónico.
- Nombre (máximo 120 caracteres), apellido (máximo 130) y correo electrónico (máximo 150) son obligatorios.
- El correo electrónico no puede repetirse entre estudiantes.
- Un estudiante puede inscribirse a muchos cursos, o a ninguno.

### D. Curso

- Cada curso es dictado por un solo profesor y pertenece a una sola categoría.
- De cada curso se registra: identificador único, título, descripción corta, precio de lista, profesor responsable y categoría.
- El título es obligatorio (máximo 50 caracteres).
- La descripción corta es opcional (máximo 120 caracteres).
- El precio de lista es obligatorio, con hasta 2 decimales, y no puede ser negativo.
- El profesor responsable y la categoría son obligatorios y deben existir.

### E. Lección

- Un curso puede tener muchas lecciones (clases o videos del contenido), o ninguna mientras no se haya cargado alguna.
- Una lección pertenece a un solo curso.
- De cada lección se registra: identificador único, título, duración y curso al que pertenece.
- El título es obligatorio (máximo 50 caracteres).
- La duración es obligatoria y se registra en formato de hora (horas, minutos y segundos, `hh:mm:ss`). Debe ser mayor a `00:00:00`.

### F. Inscripción (relación Estudiante - Curso)

- Un estudiante puede inscribirse en múltiples cursos y un curso puede tener múltiples estudiantes inscriptos.
- Un estudiante no puede inscribirse dos veces al mismo curso.
- Al realizarse la inscripción se registra: identificador único, estudiante, curso, fecha y hora de la inscripción y el precio real que pagó el estudiante (para conservar el historial aunque el precio de lista del curso cambie después).
- Si no se indica la fecha y hora, se registra automáticamente el momento de la inscripción.
- El precio pagado es obligatorio, con hasta 2 decimales, y no puede ser negativo.

## 3. Reglas de negocio generales

1. Solo un profesor puede dictar un curso: la clave foránea del curso apunta a la entidad Profesor.
2. Solo un estudiante puede inscribirse a un curso: la clave foránea de la inscripción apunta a la entidad Estudiante.
3. Todo curso tiene exactamente un profesor y exactamente una categoría.
4. Toda lección pertenece a un curso existente.
5. Los montos (precio y costo pagado) nunca son negativos.
6. La duración de toda lección es mayor a cero.
7. No se puede eliminar un registro que tiene otros registros que dependen de él, con una única excepción: al eliminar un curso se eliminan también sus lecciones (ver sección 4).

## 4. Restricciones de integridad

### Identificadores

Todas las entidades tienen un identificador único numérico entero (`INT`), generado automáticamente por la base de datos.

### Comportamiento ante eliminación y modificación

| Relación (hija → padre) | Al eliminar el padre | Al modificar el identificador del padre |
|---|---|---|
| Curso → Categoría | **Se rechaza** si tiene cursos | Se actualiza en los cursos |
| Curso → Profesor | **Se rechaza** si tiene cursos | Se actualiza en los cursos |
| Lección → Curso | **Se eliminan** las lecciones del curso | Se actualiza en las lecciones |
| Inscripción → Estudiante | **Se rechaza** si tiene inscripciones | Se actualiza en las inscripciones |
| Inscripción → Curso | **Se rechaza** si tiene inscripciones | Se actualiza en las inscripciones |

Consecuencias:

- No se puede eliminar una categoría ni un profesor que tengan cursos.
- No se puede eliminar un estudiante que tenga inscripciones, ni un curso que tenga inscripciones. Esto protege el historial de inscripciones y de precios pagados.
- Al eliminar un curso sin inscripciones, sus lecciones se eliminan junto con él, porque una lección no tiene sentido sin su curso.

## 5. Decisiones de diseño y supuestos

- **Profesor y Estudiante como entidades independientes.** No existe una entidad Usuario con un atributo de rol. Así, las reglas 1 y 2 se garantizan por la estructura de las tablas y no hace falta ningún mecanismo adicional.
- **Limitación conocida.** Nombre, apellido y correo se repiten en ambas entidades, y la unicidad del correo se controla dentro de cada una, no entre las dos. Si una misma persona enseña y estudia, tendría un registro en cada entidad sin vínculo entre ellos.
- **Supuesto.** Un estudiante no se inscribe dos veces al mismo curso (restricción de unicidad sobre el par estudiante-curso).
- **Precio histórico.** El costo pagado se guarda en la inscripción para que los cambios futuros del precio de lista no alteren los registros anteriores.
- **Duración de la lección.** Se registra como hora (`hh:mm:ss`) y no como un número de minutos, para poder expresar duraciones con segundos.
- **Cursos sin lecciones.** La base permite que un curso exista sin lecciones, por ejemplo mientras se está armando su contenido.
- **Eliminación protegida.** Se prioriza conservar el historial: los registros con dependientes no se pueden eliminar, salvo las lecciones de un curso.
