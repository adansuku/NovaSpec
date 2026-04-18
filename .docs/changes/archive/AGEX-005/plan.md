# Plan: AGEX-005

## Estrategia

Cambio aditivo y conservador. Primero se crea la skill nueva, luego se
modifica `sdd-plan.md` para invocarla y para insertar la sección
`## Decisiones de planificación` en el template del `plan.md` que
genera, y por último se actualizan las dos menciones en `CLAUDE.md` y
`README.md`. No se toca ningún otro comando ni skill.

## Archivos a tocar

- `.spec/commands/sdd-plan.md`: insertar un paso nuevo entre "Leer la
  spec" y "Generar plan.md" que invoca `collaborative-decision` tres
  veces (estrategia, granularidad, safety net); actualizar el template
  de `plan.md` añadiendo `## Decisiones de planificación` al inicio
  (antes de `## Estrategia`).
- `CLAUDE.md`: mencionar `collaborative-decision` en la estructura del
  framework (sección de reglas/skills más cercana al estilo actual).
- `README.md`: añadir `collaborative-decision` a la columna "Skills que
  usa" de `/sdd-plan` en la tabla de comandos y reflejarla en
  cualquier listado descriptivo de skills que aparezca.

## Archivos nuevos

- `.spec/skills/collaborative-decision/SKILL.md`: skill horizontal con
  frontmatter (`name`, `description` rica para autocarga por contexto)
  y cuerpo que define: propósito, input esperado (tema, contexto,
  opciones con default y razón), formato literal de la pregunta,
  reglas de interpretación de respuestas (afirmación suelta = default;
  propuesta alternativa = decisión custom; ambigüedad = re-preguntar
  una vez y parar), y qué no hace (no redacta, no decide sola).

## Dependencias entre cambios

Orden ejecutable:
1. Crear `SKILL.md` antes de modificar `sdd-plan.md`. Aunque el
   markdown no ejecuta nada, modificar primero el comando dejaría
   una referencia colgante si revisamos en medio.
2. Modificar `sdd-plan.md` una vez la skill existe.
3. Actualizar `CLAUDE.md` y `README.md` en cualquier orden entre sí,
   pero después del punto 2 para que el contenido refleje la
   realidad.
4. Verificación manual al final (tarea de `/sdd-do`), antes de pasar
   a `/sdd-review`.

## Safety net

- **Reversibilidad**: el cambio es aditivo + una modificación en un
  único comando. No aplica feature flag (el framework son prompts
  markdown estáticos). Revertir = borrar
  `.spec/skills/collaborative-decision/` y revertir los diffs de
  `sdd-plan.md`, `CLAUDE.md` y `README.md`. Un único `git revert`
  del merge basta.
- **Qué puede romperse**:
  - Si el agente interpreta mal el formato de la pregunta, el usuario
    puede quedarse sin saber cómo responder. El formato vive literal
    en `SKILL.md` para acotar esto.
  - En instalaciones donde el symlink `.claude/skills` no apunte a
    `.spec/skills`, la skill no se autocarga (pero eso ya afecta a
    las 4 skills existentes; no es regresión nueva).
  - `/sdd-plan` empieza a requerir respuesta interactiva donde antes
    generaba directo: un usuario acostumbrado al flujo previo nota
    el cambio. Mitigación: los defaults sugeridos permiten cerrar
    las tres con afirmaciones sueltas si son correctos.
- **Plan de rollback**:
  1. `git revert <merge-commit>` o
  2. `rm -rf .spec/skills/collaborative-decision/` +
     `git checkout main -- .spec/commands/sdd-plan.md CLAUDE.md README.md`.

## Characterization tests

No aplica. El repo `agex` es un framework de prompts markdown
consumidos por Claude Code: no hay código ejecutable, runtime de
pruebas ni dependencia en runtime. La verificación del cambio es
manual según la sección "Verificación sin tests automatizados" de la
spec (`.docs/changes/AGEX-005/proposal.md`). Se añade una tarea
explícita de verificación manual al final del plan de ejecución.

## Verificación

Mapeo a los criterios de éxito de la spec:

- **Existencia de la skill**: `ls .spec/skills/collaborative-decision/SKILL.md`
  y comprobar frontmatter `name` y `description`.
- **Invocación en `/sdd-plan`**: leer `.spec/commands/sdd-plan.md` y
  confirmar que el paso nuevo referencia `collaborative-decision` y
  enumera los tres puntos (estrategia, granularidad, safety net).
- **Sección en `plan.md` generado**: ejecutar el flujo completo
  contra un ticket de prueba (real o simulado con `proposal.md`
  mínimo) y verificar que el `plan.md` resultante empieza por
  `## Decisiones de planificación` con las tres entradas.
- **Afirmación suelta → default**: durante la verificación manual,
  responder "ok" a una de las tres preguntas y confirmar que se
  registra la opción default.
- **Propuesta alternativa aceptada**: responder con una opción propia
  justificada a otra pregunta y confirmar que aparece en
  `plan.md` como decisión custom con la razón del usuario.
- **Documentación**: `grep -n collaborative-decision CLAUDE.md README.md`
  devuelve al menos una mención en cada archivo.
- **No regresión**: ejecutar `/sdd-do` y `/sdd-review` sobre el ticket
  de prueba y confirmar que su comportamiento no ha cambiado (los
  comandos no referencian la skill ni alteran su flujo).
