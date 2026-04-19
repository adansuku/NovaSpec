# NOVA-002 — Convertir skill `load-context` en subagente

**Tipo**: refactor (arquitectura)
**Prioridad**: media
**Estimación**: media (2-3h)

## Problema

La skill `load-context` (90 LOC) hace un trabajo pesado: escanea
`context/services/`, lee múltiples `CONTEXT.md`, busca ADRs, agrega resumen.
Todo este material entra al context del orquestador aunque solo se use
el resumen.

## Propuesta

Crear `novaspec/agents/context-loader.md` (agente tipo Explore) que:
- Recibe lista de servicios afectados.
- Escanea `context/services/`, `context/adr/`, `context/specs/`.
- Devuelve un resumen estructurado (servicios, ADRs, restricciones, huecos).

La skill `load-context` se mantiene como envoltorio ligero (≤20 LOC) que
invoca al agente. Alternativa: eliminar la skill y que `/nova-start` use
Task tool directamente.

## Criterio de aceptación

1. `novaspec/agents/context-loader.md` funcional.
2. `/nova-start` obtiene el mismo resumen de contexto que hoy.
3. Solo el resumen entra al context del orquestador (no los CONTEXT.md crudos).
4. Skill `load-context` reducida a ≤20 LOC o eliminada.

## Riesgos

- Si el agente no tiene acceso al filesystem completo, el scan falla.
  Configurar herramientas: Read, Glob, Grep.
