# CP2: Actualización del correo de un profesor

> Parte de los [casos de prueba de EduTech](casos_de_prueba.md). Las sentencias completas, listas para ejecutar, están en [`casos_de_prueba.sql`](casos_de_prueba.sql).

**Escenario**

```gherkin
Dado que existe el profesor "QA Profesor"
Cuando se actualiza su correo electrónico
Entonces el profesor tiene el correo actualizado
Y el correo anterior ya no está asociado a ningún profesor
```

**Qué se verifica:** que al actualizar el correo de un profesor el valor nuevo queda guardado, que el anterior deja de existir, y que el resto de los datos no se ve afectado.

### Estado inicial

#### Paso 0: Totales de registros antes de la prueba

Esta consulta se ejecuta al inicio y al final del caso. Los totales deben ser idénticos.

```sql
SELECT 'categoria' AS tabla, COUNT(*) AS total FROM categoria
UNION ALL SELECT 'profesor',    COUNT(*) FROM profesor
UNION ALL SELECT 'estudiante',  COUNT(*) FROM estudiante
UNION ALL SELECT 'curso',       COUNT(*) FROM curso
UNION ALL SELECT 'leccion',     COUNT(*) FROM leccion
UNION ALL SELECT 'inscripcion', COUNT(*) FROM inscripcion;
```

**Resultado esperado:** con los datos de ejemplo cargados, categoria 10, profesor 10, estudiante 20, curso 15, leccion 30 e inscripcion 29.

**Resultado obtenido:**

![Totales iniciales](evidencias/CP2/CP2_snapshot_00_inicial.png)

- [x] Coincide con el resultado esperado

### Preparación

#### Paso 1: Verificar que el profesor de prueba no existe

Se buscan los dos correos que usa la prueba: el original y el actualizado.

```sql
SELECT * FROM profesor
WHERE correo_electronico IN ('qa.profesor@test.edutech', 'qa.profesor.nuevo@test.edutech');
```

**Resultado esperado:** 0 filas.

**Resultado obtenido:**

![Verificación de que el profesor no existe](evidencias/CP2/CP2_prep_01_verifica_no_existe_profesor.png)

- [x] Coincide con el resultado esperado

#### Paso 2: Insertar el profesor

```sql
INSERT INTO profesor (nombre, apellido, correo_electronico)
VALUES ('QA', 'Profesor', 'qa.profesor@test.edutech');
```

**Resultado esperado:** 1 fila insertada.

**Resultado obtenido:**

![Inserción del profesor](evidencias/CP2/CP2_prep_02_inserta_profesor.png)

- [x] Coincide con el resultado esperado

#### Paso 3: Verificar la precondición del profesor

```sql
SELECT * FROM profesor WHERE correo_electronico = 'qa.profesor@test.edutech';
```

**Resultado esperado:** 1 fila.

**Resultado obtenido:**

![Verificación de la precondición del profesor](evidencias/CP2/CP2_prep_03_verifica_precondicion_profesor.png)

- [x] Coincide con el resultado esperado

### Ejecución

#### Paso 4: Actualizar el correo del profesor

```sql
UPDATE profesor
SET correo_electronico = 'qa.profesor.nuevo@test.edutech'
WHERE correo_electronico = 'qa.profesor@test.edutech';
```

**Resultado esperado:** 1 fila afectada, sin errores.

**Resultado obtenido:**

![Actualización del correo del profesor](evidencias/CP2/CP2_ejec_04_update_email_profesor.png)

- [x] Coincide con el resultado esperado

### Verificaciones

#### Paso 5: Verificar que el profesor tiene el correo nuevo

```sql
SELECT * FROM profesor WHERE correo_electronico = 'qa.profesor.nuevo@test.edutech';
```

**Resultado esperado:** 1 fila, con el correo `qa.profesor.nuevo@test.edutech`.

**Resultado obtenido:**

![Verificación del correo nuevo](evidencias/CP2/CP2_verif_05_email_nuevo_existe.png)

- [x] Coincide con el resultado esperado

#### Paso 6: Verificar que el correo anterior ya no existe

```sql
SELECT * FROM profesor WHERE correo_electronico = 'qa.profesor@test.edutech';
```

**Resultado esperado:** 0 filas.

**Resultado obtenido:**

![Verificación de que el correo anterior no existe](evidencias/CP2/CP2_verif_06_email_viejo_no_existe.png)

- [x] Coincide con el resultado esperado

### Limpieza

#### Paso 7: Eliminar el profesor

```sql
DELETE FROM profesor WHERE correo_electronico = 'qa.profesor.nuevo@test.edutech';
```

**Resultado esperado:** 1 fila eliminada.

**Resultado obtenido:**

![Eliminación del profesor](evidencias/CP2/CP2_limp_07_delete_profesor.png)

- [x] Coincide con el resultado esperado

#### Paso 8: Verificar que el profesor ya no existe

```sql
SELECT * FROM profesor WHERE correo_electronico LIKE 'qa.profesor%@test.edutech';
```

**Resultado esperado:** 0 filas.

**Resultado obtenido:**

![Verificación de la limpieza del profesor](evidencias/CP2/CP2_limp_08_verifica_limpieza_profesor.png)

- [x] Coincide con el resultado esperado

### Estado final

#### Paso 9: Totales de registros después de la prueba

Se repite la consulta del paso 0.

**Resultado esperado:** los mismos totales que antes de la prueba (categoria 10, profesor 10, estudiante 20, curso 15, leccion 30 e inscripcion 29).

**Resultado obtenido:**

![Totales finales](evidencias/CP2/CP2_snapshot_09_final.png)

- [x] Coincide con el resultado esperado

### Resultado del caso

- [x] **CP2 aprobado:** todos los pasos dieron el resultado esperado y la base quedó igual que al inicio.
