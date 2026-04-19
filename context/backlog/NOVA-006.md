# NOVA-006 — Limpiar carpetas `openspec-*` huérfanas en `novaspec/skills/`

**Tipo**: limpieza
**Prioridad**: baja (higiene)
**Estimación**: muy baja (5min)

## Problema

`novaspec/skills/` contiene 4 directorios vacíos sin `SKILL.md`:

- `openspec-apply-change/`
- `openspec-archive-change/`
- `openspec-explore/`
- `openspec-propose/`

Son restos de una iteración anterior (exploración de integración con
OpenSpec que no llegó a implementarse). Ningún comando los referencia.

Ya flagged en `analisis.md` como problema crítico #2.

## Propuesta

Borrar los 4 directorios.

Si en el futuro se decide integrar con OpenSpec real (Fission-AI), se
reabre como ticket nuevo con diseño explícito.

## Criterio de aceptación

1. `ls novaspec/skills/` no muestra directorios `openspec-*`.
2. Ningún archivo del framework referencia esas skills.
3. Commit separado para trazabilidad.
