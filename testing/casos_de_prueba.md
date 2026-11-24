# Casos de prueba de la base EduTech

Este directorio documenta la ejecución de los casos de prueba sobre la base de datos **EduTech**. Cada caso tiene su propio archivo, con la sentencia SQL de cada paso, el resultado esperado y la captura del resultado obtenido en phpMyAdmin.

Las sentencias completas, listas para ejecutar, están en [`casos_de_prueba.sql`](casos_de_prueba.sql).

## Entorno

- Motor: MySQL, administrado con phpMyAdmin.
- Base de datos: `EduTech`, creada con los scripts de [`sql/`](../sql/) (estructura y datos de ejemplo).

## Casos

| Caso | Descripción | Tipo | Estado |
|---|---|---|---|
| [CP1](CP1_cascada_curso_lecciones.md) | Eliminación en cascada de curso a lecciones (`ON DELETE CASCADE`) | Positivo | Ejecutado |
| [CP2](CP2_actualizacion_email_profesor.md) | Actualización del correo de un profesor | Positivo | Ejecutado |
| [CP3](CP3_restriccion_borrado_estudiante.md) | Restricción de borrado de un estudiante con inscripción (`ON DELETE RESTRICT`) | Negativo | Ejecutado |

## Reglas que siguen todos los casos

1. Los datos de la prueba no existen al inicio: se crean para la prueba.
2. No se modifica ningún dato existente en la base.
3. Todo lo que se crea se elimina al finalizar la prueba.
4. Los datos de prueba llevan "QA" en el nombre o el dominio `@test.edutech`, y se identifican por valores únicos, no por IDs fijos.
5. Cada caso empieza y termina con una consulta de totales por tabla, que debe dar el mismo resultado antes y después.

## Estructura de las evidencias

Las capturas están en `evidencias/<caso>/` y se nombran así:

```
<caso>_<fase>_<paso>_<descripcion>.png
```

- **fase:** `snapshot`, `prep` (preparación), `ejec` (ejecución), `verif` (verificaciones) o `limp` (limpieza).
- **paso:** número de dos dígitos, que coincide con el "Paso N" del documento del caso.

Ejemplo: `evidencias/CP1/CP1_ejec_10_delete_curso.png`.
