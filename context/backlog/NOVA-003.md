# NOVA-003 — Extraer resolución de `branch.base` a guardrail compartido

**Tipo**: refactor (DRY)
**Prioridad**: baja
**Estimación**: muy baja (30min)

## Problema

La lógica de resolución de la rama base aparece **duplicada verbatim** en:

- `novaspec/commands/nova-start.md:42-51` (10 líneas)
- `novaspec/commands/nova-wrap.md:68-71` (4 líneas, versión abreviada)

Cambios futuros (añadir soporte para `main` como fallback, por ejemplo)
requieren sincronizar dos lugares. Tick-tock clásico de deuda.

## Propuesta

Crear `novaspec/guardrails/branch-base-resolution.md` con la lógica canónica:
1. Leer `branch.base` de `novaspec/config.yml`.
2. Si falta, intentar `develop`. Si tampoco existe, preguntar y recomendar.

Ambos comandos referencian el guardrail:

> "Resuelve `branch.base` siguiendo `novaspec/guardrails/branch-base-resolution.md`."

## Criterio de aceptación

1. `novaspec/guardrails/branch-base-resolution.md` contiene la lógica completa.
2. `nova-start.md` y `nova-wrap.md` referencian el guardrail en vez de
   duplicar.
3. Total LOC de los 3 archivos ≤ baseline - 8 líneas.

## Notas

Alternativa futura: mover lógica a `novaspec/scripts/resolve-base.sh` y que
ambos comandos invoquen el script (consistente con AGEX-018).
