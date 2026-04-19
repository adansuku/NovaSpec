# NOVA-007 — Extraer `## Reglas` comunes a `novaspec/rules.md` compartido

**Tipo**: refactor (DRY token-saving)
**Prioridad**: media
**Estimación**: baja (1h)

## Problema

Los 7 comandos terminan con una sección `## Reglas` de 3-6 ítems. Muchas
reglas se repiten casi textualmente:

- "No inventes contexto"
- "No escribas código aquí" / "No propongas spec"
- "Si falta info, pregunta"
- "No ejecutes sin confirmación"
- "Si algo falla, para y reporta"

Las 7 secciones suman ~35 LOC de prompt que se cargan uno por uno según
qué comando esté activo, pero la intención es compartida.

## Propuesta

Crear `novaspec/rules.md` con las reglas transversales del framework
(≤15 LOC). Cada comando reemplaza su sección `## Reglas` por:

> Reglas globales: `novaspec/rules.md` + [regla específica del comando si
> la hay].

Reglas verdaderamente específicas de un comando (p.ej. "No modifiques
código en `/nova-review`") se quedan en ese comando.

## Criterio de aceptación

1. `novaspec/rules.md` existe con ≤15 LOC.
2. Cada comando referencia `novaspec/rules.md` en vez de listar reglas
   genéricas.
3. Total LOC commands baja ≥25 respecto al baseline.
4. Mismo comportamiento observable del flujo.
