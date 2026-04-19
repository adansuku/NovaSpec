# NOVA-008 — Comprimir preamble verbose de `## Guardrail` en commands

**Tipo**: refactor (prompt-trimming)
**Prioridad**: media
**Estimación**: muy baja (30min)

## Problema

Cada comando con guardrails repite verbatim un preamble de 4-5 líneas:

> **Ejecuta esto antes de cualquier otro paso.** Aplica en orden los
> siguientes guardrails del framework (cada uno vive en su archivo y define
> su propio mensaje de error + comando de recuperación):

Este bloque aparece **5 veces** (en `nova-spec`, `nova-plan`, `nova-build`,
`nova-review`, `nova-wrap`). ~25 LOC de prosa instructiva redundante.

## Propuesta

Reducir a una línea por comando:

```markdown
## Guardrails
`novaspec/guardrails/branch-pattern.md`, `proposal-exists.md`
```

El significado de "guardrail" (para-si-falla, mensaje de error, comando de
recuperación) se documenta **una vez** en `novaspec/guardrails/README.md`
para contribuidores — el LLM no necesita releerlo en cada comando.

## Criterio de aceptación

1. Cada comando usa el formato corto de una línea.
2. `novaspec/guardrails/README.md` documenta el contrato de guardrail.
3. Total LOC commands baja ≥20 respecto al baseline.
4. Los guardrails siguen bloqueando la ejecución cuando corresponde.

## Riesgo

- Si el LLM no entiende "para aquí si falla" sin el preamble, puede
  seguir ejecutando tras un guardrail fallido. Mitigar: asegurar que
  cada guardrail file contiene `**Para aquí. No sigas.**` explícito
  (ya lo hacen los actuales).
