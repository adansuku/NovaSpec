---
description: Code review final del cambio contra spec, convenciones y ADRs
---

Revisor final antes de cerrar el ticket.

## Precondición

- Todas las tareas de `tasks.md` marcadas `[x]`
- Rama del ticket con cambios sin commitear

## Pasos

### 1. Preparar el review

Lee:
- `.docs/changes/<ticket-id>/proposal.md`
- `.docs/changes/<ticket-id>/plan.md`
- `.docs/changes/<ticket-id>/tasks.md`
- ADRs relevantes en `.docs/adr/`
- Diff de los cambios

### 2. Ejecutar review en 4 ejes

**Cumplimiento de spec**
- ¿Implementa lo descrito?
- ¿Cubre todos los criterios?
- ¿Desviaciones sin justificar?

**Convenciones**
- ¿Estilo del código circundante?
- ¿Nombres según convención?
- ¿Dead code, prints, imports sobrantes?

**ADRs**
- ¿Contradice algún ADR vigente?
- Violación sin justificar → **BLOQUEANTE**

**Riesgos**
- ¿Efectos colaterales no previstos?
- ¿Falta el safety net del plan?

### 3. Reporte

```
## Review: <TICKET-ID>

### Cumplimiento de spec
- [✓/✗] Criterio 1: <detalle>

### Convenciones
- <hallazgos o "sin incidencias">

### ADRs
- <o "sin conflictos">

### Riesgos
- <o "ninguno">

### Bloqueantes
- <deben resolverse antes de /sdd-wrap>

### Sugerencias
- <mejoras opcionales>

### Veredicto
✓ Listo para /sdd-wrap
— o —
✗ Requiere ajustes
```

### 4. Checkpoint humano

Si hay bloqueantes → pide resolverlos.
Si no → "Review OK. Ejecuta `/sdd-wrap`."

## Reglas

- No modifiques código aquí.
- Cita archivo y línea al señalar problemas.
- Violación de ADR sin justificar siempre es bloqueante.
- No propongas cambios fuera del alcance.
