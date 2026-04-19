# NOVA-013 — Comando `/nova-init` para inicializar NovaSpec en repo existente

**Tipo**: feature
**Prioridad**: alta
**Estimación**: media (1-2h)

## Problema

`install.sh` crea la estructura de carpetas pero genera plantillas vacías.
Un equipo que instala NovaSpec en un repo existente tiene que rellenar
manualmente `CONTEXT.md` por servicio, `glossary.md`, y el primer ADR.
Esto crea fricción en el primer uso y reduce el valor percibido del framework.

## Propuesta

Crear `novaspec/commands/nova-init.md` — un comando `/nova-init` que
analiza el repo actual y genera contenido real, no plantillas.

### Fase 1 — Scan (solo lectura)
- Detectar servicios/módulos: leer `package.json`, `go.mod`, estructura
  de carpetas raíz, cualquier `README` existente
- Detectar si ya hay `context/` inicializado (modo idempotente: no sobreescribe)
- Reportar al usuario qué encontró antes de tocar nada

### Fase 2 — Scaffold (con aprobación)
- Crear `context/` con subdirectorios estándar si no existen
- Generar `CONTEXT.md` por servicio detectado con secciones reales
  (qué hace, dependencias detectadas, tech stack)
- Generar `glossary.md` con términos semilla extraídos de nombres de
  módulos, endpoints o entidades encontradas
- Crear `ADR-0001.md`: "Adoptamos NovaSpec como framework SDD"
  con fecha actual y contexto del proyecto

### Fase 3 — Wire
- Crear symlinks `.claude/commands → ../novaspec/commands` y
  `.claude/skills → ../novaspec/skills` si no existen
- Añadir a `.gitignore`: `context/backlog/*` y `.claude/worktrees/`
- Copiar `CLAUDE.md` si no existe; si existe, añadir solo la sección
  del flujo nova-spec sin sobreescribir el contenido actual

### Guardrail de idempotencia
Si `context/changes/` ya existe → mostrar resumen del estado actual
y preguntar si continuar. Nunca sobreescribir archivos con contenido.

## Relación con install.sh

`install.sh` queda como alternativa headless para CI/CD o repos sin
Claude Code. `/nova-init` es la experiencia de primer uso guiada.

## Criterio de aceptación

1. `/nova-init` en un repo Node.js vacío genera estructura completa con
   `CONTEXT.md` no vacío para cada `package.json` detectado.
2. Ejecutar `/nova-init` dos veces no sobreescribe ningún archivo existente.
3. Al terminar, `/nova-start NOVA-001` funciona sin configuración adicional.
4. `.gitignore` actualizado correctamente.
5. ADR-0001 creado con fecha real y nombre del repo.

## Archivos afectados

- `novaspec/commands/nova-init.md` (nuevo)
