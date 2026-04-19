# NOVA-010 — Reescribir README.md para equipo mid-level

**Tipo**: docs (onboarding)
**Prioridad**: alta
**Estimación**: muy baja (30 min)

## Problema

El README actual tiene 165 líneas con secciones técnicas (memory layering,
estructura de carpetas, configuración) que son ruido para un mid-level que
acaba de descubrir el framework. No responde la primera pregunta real del
equipo: "¿Por qué este y no spec-kit u OpenSpec?"

## Propuesta

Reescribir a ≤80 LOC con tres secciones:

1. **Por qué NovaSpec** — 3 bullets directos comparando con spec-kit y OpenSpec:
   - spec-kit: automatiza el flujo, no enseña nada, no recuerda tu proyecto
   - OpenSpec: muy abstracto, sin guía paso a paso
   - NovaSpec: flujo guiado con aprobación humana en cada fase + memoria compartida
2. **Instalación** — 2 comandos + link a INSTALL.md para el detalle
3. **Tu primer ticket** — link a `novaspec/demo/` (NOVA-014)

La premisa en una línea destacada al inicio:
> *NovaSpec no hace el trabajo por ti. Te enseña a hacer el trabajo bien.*

## Criterio de aceptación

1. README ≤ 80 LOC.
2. Sección de comparativa presente con los 3 bullets.
3. Un mid-level sin contexto previo lee el README en <3 min y sabe por qué
   usarlo y cómo empezar.
4. Links a INSTALL.md y `novaspec/demo/` funcionan.

## Archivos afectados

- `README.md`
