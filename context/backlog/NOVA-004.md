# NOVA-004 — Fusionar `write-adr` + `update-service-context` en skill `memory-writer`

**Tipo**: refactor (consolidación)
**Prioridad**: media
**Estimación**: media (3h)

## Problema

Las skills `write-adr` (97 LOC) y `update-service-context` (109 LOC)
comparten el patrón:

> "Escribe un archivo markdown estructurado en `context/memory/...` siguiendo
>  una plantilla, preguntando primero para no sobrescribir."

La diferencia es solo el destino (`context/adr/ADR-NNNN.md` vs
`context/services/<svc>/CONTEXT.md`) y la plantilla.

Dos skills parecidas → más prompt cargado en contexto, más mantenimiento,
más divergencia accidental.

## Propuesta

Crear skill única `memory-writer` (≤60 LOC) con parámetros:
- `type`: `adr` | `context` | `glossary` | `decisions` | `incidents`
- `target`: ruta final
- `template`: referencia a `novaspec/templates/<type>.md` (depende de AGEX-017)

El skill carga la plantilla correcta, hace las preguntas apropiadas
(¿sobrescribir? ¿crear nuevo? ¿numerar ADR?), y escribe.

Las skills `write-adr` y `update-service-context` se eliminan del
auto-loading; los comandos las invocan vía `memory-writer`.

## Criterio de aceptación

1. `novaspec/skills/memory-writer/SKILL.md` ≤ 60 LOC.
2. `write-adr/` y `update-service-context/` eliminadas (o reducidas a
   stubs que delegan).
3. Total LOC de skills: 411 → ≤200.
4. `/nova-wrap` ejercita los dos casos (ADR + CONTEXT update) sin
   regresión.

## Dependencias

- AGEX-017 (plantillas externas) — recomendable antes, para que
  `memory-writer` apunte a plantillas en vez de incluirlas inline.
