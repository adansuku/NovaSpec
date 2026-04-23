# Backlog de nova-spec

## Índice

| Ticket | Título | Tipo | Prioridad |
|---|---|---|---|
| NOVA-001 | Extraer `/nova-review` a subagente | refactor | media |
| NOVA-002 | Convertir skill `load-context` en subagente | refactor | media |
| NOVA-003 | Extraer resolución `branch.base` a guardrail compartido | refactor | baja |
| NOVA-004 | Fusionar `write-adr` + `update-service-context` → `memory-writer` | refactor | media |
| NOVA-005 | Reclasificar `close-requirement` como subcomando de `/nova-spec` | refactor | baja |
| NOVA-006 | Limpiar carpetas `openspec-*` huérfanas en `novaspec/skills/` | limpieza | baja |
| NOVA-007 | Extraer `## Reglas` comunes a `novaspec/rules.md` compartido | refactor | media |
| NOVA-008 | Comprimir preamble verbose de `## Guardrail` en commands | refactor | media |
| NOVA-009 | Renombrar `context/` a `context/` (visible, branded) | architecture | media |
| NOVA-010 | Reescribir README.md para equipo mid-level | docs | alta |
| NOVA-011 | Crear ticket demo para primer usuario (`novaspec/demo/`) | docs | alta |
| NOVA-012 | Integrar Jira API REST en nova-start y nova-wrap | feature | media |
| NOVA-013 | Comando `/nova-init` para inicializar NovaSpec en repo existente | feature | alta |
| NOVA-014 | Arquitectura SDD-Orchestrator con subagentes especializados | architecture | alta |
| NOVA-015 | Auto ADR / análisis de arquitectura en `/init` para repos existentes | feature | media |
| NOVA-016 | Soporte multi-agente en el flujo nova-spec | architecture | alta |
| NOVA-017 | `/nova-analyst` opcional para elicitación profunda pre-spec | feature | media |
| NOVA-018 | Hardening de `install.sh` para repos con `.claude/` existente | feature | alta |

## Convención de IDs

- Tickets previos al rebrand: prefijo **AGEX-** (histórico, no se reutilizan).
- Tickets nuevos: prefijo **NOVA-** — el número coincide con el ticket de Jira.
- Próximo ID libre: **NOVA-019**.

## Cómo promover un item a ticket activo

1. Ejecutar `/nova-start NOVA-NNN` o pegar la URL del ticket de Jira.
2. Durante `/nova-spec`, usar este archivo como input para `close-requirement`.
3. Al cerrar el ticket, el archivo del backlog queda absorbido por `context/changes/archive/NOVA-NNN/`.
