# Proyecto con nova-spec

Este repo usa el flujo **nova-spec** (SDD) para cualquier cambio no trivial.
Configuración en `novaspec/config.yml`. Contexto arquitectónico en `.docs/`.

## Flujo de trabajo

Comandos `/nova-*` en `novaspec/commands/` — teclea `/` para ver el listado.
Orden: `nova-start` → `nova-spec` → `nova-plan` → `nova-build` → `nova-review` → `nova-wrap`.
Tickets `quick-fix` saltan `nova-spec` y `nova-plan`.
Cambios activos en `.docs/changes/active/<ticket-id>/`, archivados en `.docs/changes/archive/`.

## Reglas

- No inventes contexto. Si falta un CONTEXT.md, dilo.
- Checkpoints humanos después de `/nova-spec` y antes de `/nova-wrap`.
- Alimenta la memoria al cerrar.
- No uses comandos fuera de orden.
