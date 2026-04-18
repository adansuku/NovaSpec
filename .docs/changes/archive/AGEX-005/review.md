## Review: AGEX-005

### Cumplimiento de spec

- [✓] Criterio 1 — La skill `collaborative-decision` existe con
  frontmatter `name` y `description`: verificado en
  `.spec/skills/collaborative-decision/SKILL.md:1-7`.
- [✓] Criterio 2 — `/sdd-plan` pregunta las 3 decisiones (estrategia,
  granularidad, safety net) antes de escribir nada: paso nuevo en
  `.spec/commands/sdd-plan.md:39-79` invoca la skill tres veces antes
  del paso `Generar plan.md`.
- [✓] Criterio 3 — Las 3 decisiones aparecen en `plan.md` bajo sección
  `## Decisiones de planificación` al inicio: template actualizado en
  `.spec/commands/sdd-plan.md:87-91`, antes de `## Estrategia`.
- [✓] Criterio 4 — Afirmación suelta → default: regla documentada en
  `.spec/skills/collaborative-decision/SKILL.md:38-45`.
- [✓] Criterio 5 — Propuesta alternativa se acepta como custom con la
  justificación del usuario: regla en
  `.spec/skills/collaborative-decision/SKILL.md:52-61`.
- [✓] Criterio 6 — `CLAUDE.md` menciona la skill:
  `CLAUDE.md:30-34`.
- [✓] Criterio 7 — `README.md` menciona la skill: celda de la fila
  `/sdd-plan` en `README.md:41`.
- [✓] Criterio 8 — `/sdd-do` y `/sdd-review` no cambian: confirmado
  por `git diff main --name-only` (solo `sdd-plan.md`, `CLAUDE.md`,
  `README.md` modificados; skill añadida como untracked).

### Convenciones

- Frontmatter de skill (`name`, `description` rica para autocarga)
  replica exactamente el patrón de `load-context` y `close-requirement`.
- Estilo del `SKILL.md`: imperativo en español, headers `##`/`###`,
  bloque de código para formato literal, sección final de "Reglas".
  Coherente con las otras 4 skills del framework.
- Modificación de `sdd-plan.md`: inserción limpia de un paso nuevo con
  renumeración consistente de los pasos posteriores (3, 4, 5). El
  guardrail, la precondición, las reglas finales y el resto del template
  permanecen intactos.
- `README.md`: la celda "Skills que usa" sigue el mismo estilo que la
  de `/sdd-spec` (skill entre backticks, sin comillas adicionales).
- Sin dead code, imports sobrantes o prints: todo el diff es markdown
  de prompts.

### ADRs

Sin conflictos. `.docs/adr/` está vacío. La spec anticipa la
posibilidad de redactar un ADR en `/sdd-wrap` para consolidar el
patrón de **skill horizontal**, pero esa acción pertenece a `wrap`,
no es un requisito de este review.

### Riesgos

- Safety net del plan: reversibilidad vía `git revert` (cambio
  aditivo + una modificación puntual de `sdd-plan.md`). Coherente
  con la realidad del diff.
- Sin efectos colaterales sobre `/sdd-start`, `/sdd-spec`, `/sdd-do`,
  `/sdd-review`, `/sdd-wrap`, `/sdd-status`: archivos no tocados.
- Una anomalía menor ya registrada en la tarea 6: el criterio del
  default "condicional" en la decisión 2 (granularidad) depende de
  la lectura que haga el agente del alcance del cambio. No bloqueante:
  encaja con la decisión 6 de la spec (sin heurísticas condicionales
  en esta iteración) y el usuario puede ajustar siempre.

### Bloqueantes

Ninguno.

### Sugerencias

- En `/sdd-wrap`, valorar redactar un ADR que consolide el patrón de
  "skill horizontal reutilizable entre comandos" (anticipado en la
  sección `## Impacto arquitectónico` de `proposal.md`). No es
  obligatorio, pero cerraría la decisión arquitectónica que este
  ticket introduce de facto.
- Al cerrar, actualizar `.docs/services/agex/CONTEXT.md` para que la
  sección "Skills (`/.spec/skills/`)" mencione `collaborative-decision`
  como la quinta skill, destacándola como la primera horizontal del
  framework. Esto lo cubre la skill `update-service-context` que
  ejecutará `/sdd-wrap`.

### Veredicto

✓ Listo para `/sdd-wrap`.
