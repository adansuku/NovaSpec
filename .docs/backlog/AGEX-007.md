# AGEX-007: Refactor completo — Renombrar framework a "Ori"

## Épica
Migrar toda la estructura, comandos, referencias y documentación del framework de la nomenclatura actual (agex / sdd-*) a la nueva identidad: **Ori**.

## Contexto
- **Ori** = el producto/framework (lo que instalas y usas)
- **AX (Agent Experience)** = el concepto/filosofía detrás
- Ori implementa AX: define cómo los agentes de IA entienden, navegan y evolucionan tu codebase

## Alcance

### 1. Estructura de carpetas
| Antes | Después |
|---|---|
| `.spec/` | `.ori/` |
| `.spec/commands/` | `.ori/workflow/` |
| `.spec/skills/` | `.ori/skills/` |
| `.spec/config.yml` | `.ori/config.yml` |
| `.docs/` (raíz) | `.ori/memory/` |
| `.docs/services/` | `.ori/memory/services/` |
| `.docs/adr/` | `.ori/memory/adr/` |
| `.docs/specs/` | `.ori/memory/specs/` |
| `.docs/glossary.md` | `.ori/memory/glossary.md` |
| `.docs/changes/` | `.ori/changes/` |
| `.docs/changes/archive/` | `.ori/changes/archive/` |
| `.docs/backlog/` | `.ori/backlog/` |
| (nuevo) | `.ori/guardrails/` (placeholder para AGEX-006) |

### 2. Renombrar comandos
| Antes | Después | Verbo |
|---|---|---|
| `/sdd-start` | `/ori-init` | Inicializar ticket |
| `/sdd-spec` | `/ori-define` | Cerrar requisitos y redactar spec |
| `/sdd-plan` | `/ori-plan` | Generar plan ejecutable |
| `/sdd-do` | `/ori-build` | Implementar |
| `/sdd-review` | `/ori-review` | Code review |
| `/sdd-wrap` | `/ori-ship` | Cerrar, archivar, commit |
| `/sdd-status` | `/ori-status` | Inspección del estado |

### 3. Archivos a renombrar
| Antes | Después |
|---|---|
| `sdd-start.md` | `ori-init.md` |
| `sdd-spec.md` | `ori-define.md` |
| `sdd-plan.md` | `ori-plan.md` |
| `sdd-do.md` | `ori-build.md` |
| `sdd-review.md` | `ori-review.md` |
| `sdd-wrap.md` | `ori-ship.md` |
| `sdd-status.md` | `ori-status.md` |

### 4. Actualizar contenido interno
- Todas las referencias a `/sdd-*` dentro de los archivos → `/ori-*`
- Todas las referencias a `.spec/` → `.ori/`
- Todas las referencias a `.docs/` → `.ori/memory/` o `.ori/changes/` según contexto
- Referencias a "agex" como nombre del framework → "Ori"
- Mantener "AX (Agent Experience)" como concepto donde se mencione la filosofía
- `config.yml`: actualizar rutas y nombre del framework
- `CLAUDE.md`: actualizar rutas y referencias
- `README.md`: reescribir con nueva identidad Ori
- `INSTALL.md`: actualizar rutas de instalación
- `install.sh`: actualizar todas las rutas y referencias
- `.claude/` symlinks: actualizar para apuntar a `.ori/` en vez de `.spec/`

### 5. Prefijo de tickets
- Cambiar de `AGEX-` a `ORI-` a partir de este ticket
- Este ticket es el último con prefijo AGEX

### 6. Documentación
- README.md: nuevo título "Ori — an Agent Experience (AX) framework"
- Subtítulo: "Define how AI agents understand, navigate, and evolve your codebase. Created by Libnova."
- INSTALL.md: actualizar rutas y ejemplos

## Subtareas
- [ ] ST-1: Crear estructura `.ori/` y mover archivos
- [ ] ST-2: Renombrar archivos de comandos (sdd-*.md → ori-*.md)
- [ ] ST-3: Actualizar contenido interno de todos los comandos (refs a /sdd-* → /ori-*)
- [ ] ST-4: Actualizar contenido interno de todas las skills
- [ ] ST-5: Actualizar config.yml, CLAUDE.md, README.md, INSTALL.md, install.sh
- [ ] ST-6: Actualizar symlinks de .claude/
- [ ] ST-7: Migrar .docs/ → .ori/memory/ y .ori/changes/
- [ ] ST-8: Verificación: grep -ri "sdd-\|\.spec/\|\.docs/" debe devolver 0 en archivos activos
- [ ] ST-9: Actualizar CONTEXT.md del framework con nueva estructura
- [ ] ST-10: Commit, merge y push

## Criterios de aceptación
1. `grep -ri "sdd-" . --exclude-dir=.git --exclude-dir=archive` → 0 resultados
2. `grep -ri "\.spec/" . --exclude-dir=.git --exclude-dir=archive` → 0 resultados
3. `grep -ri "\.docs/" . --exclude-dir=.git --exclude-dir=archive` → 0 resultados
4. Todos los comandos funcionan con prefijo `ori-`
5. Los symlinks de `.claude/` apuntan correctamente a `.ori/`
6. README refleja la nueva identidad
7. install.sh funciona con la nueva estructura
8. Archivos en archive/ se preservan intactos (registro histórico)

## Dependencias
- Absorbe AGEX-006 (refactorizar guardrails) — al mover a `.ori/guardrails/` se crea el placeholder

## Estimación
Media-alta. Toca prácticamente todos los archivos del framework.

## Prioridad
Alta — define la identidad definitiva del producto antes de seguir añadiendo features.

## Notas
- Este es el último ticket con prefijo AGEX
- A partir de aquí, los tickets usan prefijo ORI-
- Los archivos en archive/ mantienen las referencias históricas a sdd/agex/libnova
