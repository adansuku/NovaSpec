# NOVA-014 — Arquitectura SDD-Orchestrator con subagentes especializados

**Tipo**: architecture
**Prioridad**: alta
**Estimación**: alta (4-6h, toca todos los comandos + crea 5 agentes nuevos)

## Problema

El framework hoy ejecuta todo en el mismo agente y contexto. Cada comando
acumula el historial completo de la conversación, lo que encarece cada paso
y aumenta el riesgo de que el LLM pierda foco. No hay delegación real:
`/nova-build` implementa tareas de una en una en el mismo contexto;
`/nova-review` lee todos los archivos en la misma sesión que lleva N pasos
de historia.

Referencia validada: `sdd-engram-plugin` (j0k3r-dev-rgl, MIT, v1.1.7)
implementa exactamente este patrón en producción para opencode.

## Propuesta

Convertir los comandos existentes en **orquestadores ligeros** que delegan
el trabajo pesado a subagentes preconfigurados (sin contexto de conversación).
El orquestador sigue gestionando los checkpoints humanos — los subagentes
solo ejecutan y devuelven resultados.

### Agentes nuevos en `novaspec/agents/`

| Agente | Responsabilidad | Modelo recomendado |
|---|---|---|
| `spec-writer.md` | Genera `proposal.md` a partir de ticket + contexto | Opus (heavy thinking) |
| `spec-writer-fallback.md` | Versión simplificada si spec-writer falla | Sonnet |
| `plan-writer.md` | Genera `plan.md` + `tasks.md` desde `proposal.md` | Sonnet |
| `task-implementer.md` | Implementa UNA tarea concreta, devuelve diff + resumen | Haiku (barato) |
| `code-reviewer.md` | Revisa diff contra spec + ADRs, devuelve `review.md` | Sonnet |
| `memory-writer.md` | Escribe ADR + actualiza `CONTEXT.md`, sin historial | Sonnet |

Cada agente recibe exactamente lo que necesita (archivos relevantes +
tarea), sin historial de conversación previo.

### Cambios en comandos existentes

**`/nova-spec`** — spawn en paralelo:
- `context-loader` (lee `context/`, devuelve contexto estructurado)
- ticket reader inline (parsea el ticket)
- Orquestador combina → spawn `spec-writer` → `proposal.md`
- Checkpoint humano

**`/nova-plan`** — spawn secuencial:
- `plan-writer` recibe `proposal.md` → devuelve `plan.md` + `tasks.md`
- Checkpoint humano

**`/nova-build`** — patrón gather-then-apply:
- Spawn N `task-implementer` en paralelo (uno por tarea pendiente)
- Orquestador recibe todos los diffs
- UN checkpoint humano para todas las tareas
- Aplica cambios en orden

**`/nova-review`** — spawn en paralelo:
- `spec-checker` (cumple la spec?)
- `adr-checker` (viola algún ADR?)
- `conventions-checker` (estilo, dead code)
- Orquestador combina → `review.md` → checkpoint humano

**`/nova-wrap`** — spawn secuencial:
- `memory-writer` recibe resumen de cambios → ADR + CONTEXT.md
- Orquestador hace commit + PR

### Model routing en `novaspec/config.yml`

```yaml
agents:
  spec-writer:      claude-opus-4-7       # heavy thinking
  plan-writer:      claude-sonnet-4-6
  task-implementer: claude-haiku-4-5      # barato, determinista
  code-reviewer:    claude-sonnet-4-6
  memory-writer:    claude-sonnet-4-6
  fallback:         claude-sonnet-4-6     # para cualquier agente que falle
```

### Fallback policy (inspirado en sdd-engram-plugin)

Si un agente falla o produce output inválido, el orquestador redirige al
agente `-fallback` equivalente con un prompt simplificado. El dev ve un
aviso pero el flujo no se rompe.

## Impacto en tokens

| Fase | Hoy | Post-NOVA-014 |
|---|---|---|
| `/nova-build` (5 tareas) | 1 agente × 5 iteraciones × historial acumulado | 5 agentes × contexto mínimo |
| `/nova-review` | 1 agente lee todo | 3 agentes en paralelo, cada uno lee solo lo suyo |
| `/nova-wrap` | misma sesión con historial completo | 1 agente fresco solo para memoria |

Reducción estimada: 40-60% de tokens en workflows largos (>3 tareas).

## Criterio de aceptación

1. `/nova-build` con 3 tareas lanza 3 `task-implementer` en paralelo y
   presenta un único checkpoint con los 3 diffs.
2. Si `spec-writer` falla, el flujo redirige a `spec-writer-fallback` sin
   intervención manual.
3. Cada agente en `novaspec/agents/` tiene ≤ 60 LOC.
4. `novaspec/config.yml` tiene sección `agents:` con model routing.
5. Los checkpoints humanos siguen funcionando igual — el orquestador no
   avanza sin aprobación explícita.
6. Token cost de `/nova-build` con 5 tareas es ≤ 50% del baseline actual.

## Dependencias

- NOVA-010 (comprimir guardrails) recomendable antes: menos LOC que
  los comandos arrastran al orquestador.
- NOVA-003 y NOVA-004 son subconjuntos de este ticket — si se hace
  NOVA-014, NOVA-003 y NOVA-004 quedan absorbidos.

## Archivos afectados

- `novaspec/agents/spec-writer.md` (nuevo)
- `novaspec/agents/spec-writer-fallback.md` (nuevo)
- `novaspec/agents/plan-writer.md` (nuevo)
- `novaspec/agents/task-implementer.md` (nuevo)
- `novaspec/agents/code-reviewer.md` (nuevo)
- `novaspec/agents/memory-writer.md` (nuevo)
- `novaspec/commands/nova-spec.md`
- `novaspec/commands/nova-plan.md`
- `novaspec/commands/nova-build.md`
- `novaspec/commands/nova-review.md`
- `novaspec/commands/nova-wrap.md`
- `novaspec/config.yml`

## Referencias

- [sdd-engram-plugin](https://github.com/j0k3r-dev-rgl/sdd-engram-plugin)
  — mismo patrón orquestador+subagentes en producción (MIT, opencode)
- Claude Code Agent tool — primitiva para spawn de subagentes sin contexto
