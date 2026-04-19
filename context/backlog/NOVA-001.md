# NOVA-001 — Extraer `/nova-review` a subagente

**Tipo**: refactor (arquitectura)
**Prioridad**: media
**Estimación**: media (3-4h)

## Problema

`novaspec/commands/nova-review.md` (96 LOC) ejecuta el code review inline
dentro del contexto principal. Esto contamina la conversación con el diff,
los ADRs y la spec completa — material que el orquestador no necesita
volver a leer después.

La carpeta `novaspec/agents/` está vacía. No se aprovecha el patrón de
subagentes.

## Propuesta

Crear `novaspec/agents/reviewer.md` siguiendo el formato de subagente de
Claude Code (`name`, `description`, `tools` en frontmatter + instrucciones).
El command `/nova-review` delega vía Task tool:

```markdown
Invoca el agente `reviewer` con: ticket-id, rutas de proposal/plan/tasks,
lista de ADRs aplicables, y diff. El agente devuelve el reporte en 4 ejes
y escribe `review.md`. Tú solo expones el veredicto.
```

Beneficios:
- El diff + ADRs no entran al context del orquestador.
- Permite invocar reviews en paralelo (múltiples PRs).
- Reutilizable desde otros comandos (pre-commit hook, por ejemplo).

## Criterio de aceptación

1. `novaspec/agents/reviewer.md` con frontmatter válido.
2. `nova-review.md` ≤ 30 LOC, solo orquestación.
3. Reporte y veredicto idénticos al comportamiento actual.
4. `review.md` se escribe correctamente en `context/changes/active/<ticket>/`.

## Riesgos

- Subagentes no tienen acceso al filesystem-completo por defecto: verificar
  herramientas permitidas (Read, Grep, Bash para diff).
