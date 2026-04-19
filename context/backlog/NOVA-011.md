# NOVA-011 — Crear ticket demo para primer usuario

**Tipo**: docs (onboarding)
**Prioridad**: alta
**Estimación**: baja (45 min)

## Problema

No hay un "Hello World" para NovaSpec. Un mid-level que termina de instalar
el framework no sabe qué hacer a continuación. Sin un ticket de ejemplo
guiado, el primer intento real suele ser demasiado complejo o ambiguo, lo
que genera abandono.

## Propuesta

Crear `novaspec/demo/` con:

### `novaspec/demo/DEMO-001.md`
Ticket ficticio acotado: "Añadir endpoint `/health` a un servicio Express".
Requisitos:
- Título, tipo, criterios de aceptación claros
- Complejidad calibrada para 20-30 min de trabajo real
- Archivos afectados explícitos (para que load-context tenga algo que leer)

### `novaspec/demo/README.md`
Guía paso a paso del flujo completo:
1. Instala con `bash install.sh`
2. Ejecuta `/nova-start DEMO-001`
3. Checkpoint: revisa y aprueba la spec generada
4. Ejecuta `/nova-plan`
5. Checkpoint: revisa y aprueba el plan
6. Ejecuta `/nova-build`
7. Ejecuta `/nova-review`
8. Checkpoint: revisa el code review
9. Ejecuta `/nova-wrap`
10. Resultado: rama, spec archivada, PR, ADR actualizado

Incluir output esperado por paso (texto ejemplo, no capturas).

## Criterio de aceptación

1. `novaspec/demo/` existe con `DEMO-001.md` y `README.md`.
2. Un mid-level completa DEMO-001 sin pedir ayuda en <60 min.
3. Al terminar tiene: rama creada, spec en `context/changes/archive/`, PR
   generado (aunque sea draft).
4. El flujo demuestra los 3 checkpoints humanos explícitamente.

## Archivos afectados

- `novaspec/demo/DEMO-001.md` (nuevo)
- `novaspec/demo/README.md` (nuevo)
