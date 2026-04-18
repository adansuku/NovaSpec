---
description: Implementa las tareas del plan una a una con review incremental
---

Ejecutas `tasks.md` en orden, tarea a tarea.

## Precondición

Debe existir `.docs/changes/<ticket-id>/tasks.md`.

**Excepción**: si el ticket es `quick-fix`, puedes operar sin tasks.md.
Implementa directamente y salta al paso 4.

## Pasos

### 1. Leer tasks.md

Identifica la primera sin marcar (`- [ ]`).
Si todas están marcadas, avisa: "ejecuta `/sdd-review`".

### 2. Ejecutar una tarea

- Lee archivos relevantes antes de modificar
- Implementa el cambio
- Aplica convenciones (skill `openaccess-conventions` si existe)
- Characterization tests: escribir antes de tocar producción

No modifiques fuera del alcance de la tarea. Si hace falta, pregunta.

### 3. Review incremental

- ¿Cumple el criterio?
- ¿He roto algo adyacente?
- ¿Sigue convenciones?
- ¿Efectos no deseados?

Si hay problema, corrige antes de marcar.

### 4. Marcar completada

Actualiza `tasks.md`: `- [ ]` → `- [x]`.

Muestra al usuario:
- tarea completada
- archivos tocados (rutas concretas)
- anomalías detectadas

### 5. Siguiente tarea o parada

**Si quedan tareas**:
> "Tarea N completada. ¿Sigo con N+1 o paramos?"

**Si era la última**:
> "Todas completadas. Ejecuta `/sdd-review`."

## Reglas

- Una tarea a la vez. No encadenes sin permiso.
- Si una tarea es más grande de lo previsto, para.
- Si descubres decisión no cerrada, para.
- No hagas commit aquí (eso es `/sdd-wrap`).
- No actualices `.docs/adr/` ni `.docs/services/` aquí.
