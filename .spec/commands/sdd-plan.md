---
description: Genera plan de implementación y tareas a partir de la spec aprobada
---

Traduces la spec en un plan ejecutable.

## Guardrail

**Ejecuta esto antes de cualquier otro paso.**

1. Lee la rama git actual y extrae el `<ticket-id>`.
   Si la rama no sigue el patrón `(feature|fix|arch)/<TICKET>-<slug>`:

   ```
   ⛔ Guardrail: no hay rama de ticket activa.
   Ejecuta /sdd-start <TICKET> primero.
   ```
   **Para aquí. No sigas.**

2. Comprueba que existe `.docs/changes/<ticket-id>/proposal.md`.
   Si no existe:

   ```
   ⛔ Guardrail: no existe proposal.md para <ticket-id>.
   Ejecuta /sdd-spec primero.
   ```
   **Para aquí. No sigas.**

## Precondición

Debe existir `.docs/changes/<ticket-id>/proposal.md`.

## Pasos

### 1. Leer la spec

Identifica servicios afectados, decisiones cerradas, criterios de éxito.

### 2. Cerrar decisiones de planificación

Antes de redactar `plan.md`, invoca la skill `collaborative-decision`
**tres veces consecutivas**, en este orden, pasándole los cuatro campos
(tema, contexto, opciones, default sugerido con razón anclada en la
spec o el código):

1. **Estrategia de implementación**
   - Opciones por defecto:
     - A) Conservadora: mínimos cambios, characterization tests primero,
       no tocar código adyacente.
     - B) Agresiva: refactorizar si facilita el cambio principal.
   - Default sugerido habitual: A si la spec no pide refactor explícito.

2. **Granularidad de tareas**
   - Opciones por defecto:
     - A) Pocas tareas grandes (3-5 pasos de 45-60 min).
     - B) Muchas tareas pequeñas (8-15 pasos de 15-30 min).
   - Default sugerido: depende del alcance. Cambios aditivos en uno o
     dos archivos → A; cambios con pasos dependientes o
     characterization tests → B.

3. **Safety net**
   - Opciones por defecto:
     - A) Feature flag o toggle explícito.
     - B) Toggle de config (`.spec/config.yml` u otro).
     - C) Sin protección (cambio reversible con `git revert`).
   - Default sugerido: depende de si se toca código existente en
     producción. Cambio puramente aditivo → C aceptable.

Las opciones y el default son puntos de partida ancla: si la spec o
el código aportan una opción mejor, inclúyela. Si la spec cierra
explícitamente una decisión, menciónalo en el contexto y deja claro
que el default la refleja.

Espera respuesta en cada decisión antes de lanzar la siguiente. Si la
skill se detiene por ambigüedad, para el comando entero y pide al
usuario que reformule.

Guarda las tres decisiones cerradas para reflejarlas en `plan.md` en
el paso siguiente.

### 3. Generar plan.md

Crea `.docs/changes/<ticket-id>/plan.md`:

```
# Plan: <TICKET-ID>

## Decisiones de planificación
- **Estrategia de implementación**: <opción elegida> — <razón>
- **Granularidad de tareas**: <opción elegida> — <razón>
- **Safety net**: <opción elegida> — <razón>

## Estrategia
<2-3 líneas sobre cómo abordar el cambio>

## Archivos a tocar
- `<ruta>`: <qué se modifica>

## Archivos nuevos
- `<ruta>`: <qué contiene>

## Dependencias entre cambios
<si el orden importa, explícalo>

## Safety net
- Reversibilidad: <feature flag | toggle | cómo revertir>
- Qué puede romperse: <específico>
- Plan de rollback: <pasos>

## Characterization tests
Antes de modificar código existente:
- [ ] Test de <comportamiento>
- [ ] Test de <edge case>

## Verificación
Cómo verificar cada criterio de éxito de la spec.
```

### 4. Generar tasks.md

Crea `.docs/changes/<ticket-id>/tasks.md`:

```
# Tareas: <TICKET-ID>

- [ ] 1. <tarea concreta> — <archivo(s)>
- [ ] 2. <tarea concreta> — <archivo(s)>
```

Reglas:
- cada tarea ejecutable en 15-60 min
- orden ejecutable
- incluir characterization tests antes de modificar código
- usar checkboxes `- [ ]`

### 5. Checkpoint humano

> "Plan y tareas generados. Revísalos. Ejecuta `/sdd-do` cuando estés listo."

## Reglas

- Las tareas deben salir del plan, no inventarlas.
- Si detectas decisiones no cubiertas en la spec, para.
- Para quick-fix el plan puede ser muy breve.
