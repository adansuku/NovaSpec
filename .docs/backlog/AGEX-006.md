# AGEX-006: Refactorizar guardrails a carpeta independiente

## Descripción
Extraer los guardrails duplicados de los comandos SDD a una carpeta `.spec/guardrails/` con archivos canónicos. Cada comando pasa a referenciar los guardrails en vez de copiarlos.

## Motivación
- El guardrail de rama activa está copiado 5 veces con variaciones que crean inconsistencias
- Las secciones `## Precondición` redundan con los guardrails
- La excepción quick-fix vive en 2 sitios sin definición canónica
- `close-requirement` re-lee contexto que `load-context` ya cargó

## Archivos nuevos
- `.spec/guardrails/branch-ticket.md`
- `.spec/guardrails/proposal-exists.md`
- `.spec/guardrails/plan-and-tasks-exist.md`
- `.spec/guardrails/tasks-complete.md`
- `.spec/guardrails/review-approved.md`

## Archivos a modificar
- `.spec/commands/sdd-spec.md`
- `.spec/commands/sdd-plan.md`
- `.spec/commands/sdd-do.md`
- `.spec/commands/sdd-review.md`
- `.spec/commands/sdd-wrap.md`
- `.spec/skills/close-requirement/SKILL.md`

## Criterios de aceptación
1. Cada guardrail existe en un solo archivo canónico
2. Los comandos referencian los guardrails sin duplicar lógica
3. La lógica quick-fix tiene una definición canónica única
4. Las secciones `## Precondición` eliminadas donde el guardrail ya cubre
5. `close-requirement` no re-lee contexto cargado por `load-context`

## Prioridad
Media — no bloquea desarrollo pero reduce riesgo de inconsistencias.
