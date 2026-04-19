# NOVA-005 — Reclasificar `close-requirement` como subcomando de `/nova-spec`

**Tipo**: refactor (arquitectura)
**Prioridad**: baja
**Estimación**: media (2-3h)

## Problema

`close-requirement` (115 LOC) está declarado como **skill** pero
funcionalmente es un comando: orquesta una conversación estructurada
con el usuario (preguntas ancladas en código) con input y output definidos.

Las skills se auto-cargan por contexto. Esto crea problemas:
- La skill se activa fuera del flujo esperado (cualquier conversación
  que mencione "requisito" la dispara).
- Su prompt se carga sin necesidad, inflando el context.

## Propuesta

Reclasificar como paso interno de `/nova-spec`:

- Eliminar `novaspec/skills/close-requirement/`.
- Incorporar la lógica (preguntas estructuradas) como sección de
  `novaspec/commands/nova-spec.md`, cargada solo cuando se invoca el comando.
- Alternativa si crece: separar a `novaspec/agents/requirement-closer.md`.

## Criterio de aceptación

1. Skill `close-requirement` eliminada.
2. `/nova-spec` sigue cerrando requisitos con preguntas estructuradas.
3. `close-requirement` no aparece en el listado de skills auto-cargadas.
4. Si se elige ruta agente, `novaspec/agents/requirement-closer.md` existe.

## Riesgos

- Si el usuario invocaba `close-requirement` fuera de `/nova-spec`,
  pierde ese acceso. Verificar en `notes.md` si ha ocurrido.
