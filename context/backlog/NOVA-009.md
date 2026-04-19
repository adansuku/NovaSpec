# NOVA-009 — Renombrar `context/` a `context/` (visible, branded)

**Tipo**: architecture (rebrand)
**Prioridad**: media
**Estimación**: media (2-3h, toca todos los comandos y skills)

## Problema

`context/` es un nombre genérico que no refleja lo que contiene ni a quién
pertenece. El directorio almacena la **memoria arquitectónica** del proyecto
(ADRs, CONTEXT.md por servicio, specs, glossary) + el **workflow en curso**
(changes/active/, changes/archive/, backlog/).

Problemas del nombre actual:

- **Invisible por convención** (leading dot) — quien clone el repo no
  descubre la memoria sin saber que existe.
- **Genérico** — cualquier proyecto tiene `context/`. No comunica que es
  parte del framework nova-spec.
- **Colisiona** con otros usos habituales de `context/` (Jekyll, Sphinx,
  docs-as-code genérico).

Contraste: `novaspec/` ya es visible y descriptivo. La memoria merece
el mismo tratamiento.

## Propuesta

Renombrar `context/` → `context/` (visible, sin punto):

```
context/
├── adr/
├── services/
├── specs/
├── glossary.md
├── post-mortems/
├── changes/
│   ├── active/
│   └── archive/
└── backlog/
```

**Alternativas consideradas**:
- `memory/` — evoca "memoria arquitectónica" pero puede confundirse con
  runtime memory. Descartar.
- Separar `context/` (estable) y `changes/` (workflow) en la raíz —
  más limpio semánticamente pero duplica top-level. Evaluar en NOVA-NNN
  si surge fricción.

## Alcance

### En alcance
- `git mv .docs context`
- Find-and-replace en todos los comandos y skills:
  `context/` → `context/`
- Actualizar `CLAUDE.md` (sección "Memoria arquitectónica").
- Actualizar `README.md` e `INSTALL.md` (estructura instalada).
- Actualizar `install.sh` (rutas del `mkdir -p`).
- Actualizar `.gitignore` (`context/backlog/*` → `context/backlog/*`).
- Actualizar `novaspec/config.yml` si menciona `context/`.
- Actualizar guardrails que referencian rutas (`review-approved.md`, etc.).

### Fuera de alcance
- Reestructurar contenido interno de `context/` (mantener mismos
  subdirectorios).
- Los ficheros en `context/changes/archive/` conservan referencias a
  `context/` (frozen-in-time, registro histórico).

## Criterio de aceptación

1. `git mv` preserva historial de todos los archivos.
2. `grep -r "\context/" . --exclude-dir=.git --exclude-dir=archive` → 0.
3. `ls context/` muestra la estructura esperada.
4. `bash install.sh` en repo vacío crea `context/` sin `context/`.
5. Ejecutar `/nova-status` sobre un ticket activo devuelve el estado
   correcto leyendo de `context/changes/active/`.
6. Ejecutar `/nova-wrap` archiva correctamente a `context/changes/archive/`.

## Dependencias

- Ninguna bloqueante. Puede hacerse antes o después de NOVA-001..011.
- Si se hace antes de NOVA-011 (dedup CLAUDE.md), CLAUDE.md se actualiza
  dos veces — inofensivo.

## Riesgos

- Rename masivo: un find-and-replace mal hecho rompe todos los comandos.
  Mitigar con `grep` post-rename y con smoke-test end-to-end.
- Los worktrees locales (`.claude/worktrees/*`) tienen su propia copia
  del repo — no se actualizan automáticamente. Documentar en el ticket.
