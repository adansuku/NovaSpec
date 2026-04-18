# AGEX-005: Introducir skill `collaborative-decision` e integrarla en `/sdd-plan`

## Historia

Como desarrollador que usa agex, quiero que `/sdd-plan` me convierta en
colaborador de las decisiones clave del plan (estrategia, granularidad,
safety net) en lugar de solo presentármelas para aprobar, para que el
plan refleje mi criterio y no las heurísticas silenciosas del agente.

## Objetivo

Introducir la primera **skill horizontal** del framework —
`collaborative-decision` — que cualquier comando puede invocar para
cerrar un punto de decisión con el usuario mediante preguntas de
trade-off con defaults anclados en el contexto. Integrar esta skill
en `/sdd-plan` en tres puntos concretos, dejando el patrón preparado
para futuras integraciones en `/sdd-do` y `/sdd-review`.

## Contexto

Hoy `/sdd-plan` genera `plan.md` y `tasks.md` tomando decisiones en
silencio: estrategia, orden de tareas, safety net, characterization
tests. El desarrollador revisa el resultado y aprueba o no, pero no
participa en el diseño.

El patrón de `close-requirement` (preguntas estructuradas con
trade-offs y defaults anclados en código) ya funciona bien para cerrar
decisiones de producto en `/sdd-spec`. Extraerlo a una skill
reutilizable y genérica habilita el mismo mecanismo para cualquier
comando que necesite cerrar un punto de decisión con el usuario.

Hasta ahora las skills existentes (`load-context`, `close-requirement`,
`write-adr`, `update-service-context`) son específicas de una fase del
flujo. `collaborative-decision` rompe ese patrón: es **horizontal**,
pensada para ser orquestada desde varios comandos.

## Alcance

### En alcance

- Nueva skill `.spec/skills/collaborative-decision/SKILL.md`.
- Modificación de `.spec/commands/sdd-plan.md` para invocar la skill
  en tres puntos: estrategia, granularidad de tareas, safety net.
- Actualización de `plan.md` generado: incluye una sección
  `## Decisiones de planificación` al inicio con las decisiones
  cerradas en la sesión.
- Actualización de `CLAUDE.md`: mención breve de la nueva skill.
- Actualización de `README.md`: reflejar la nueva skill en la tabla
  de comandos/skills y/o en la sección descriptiva correspondiente.

### Fuera de alcance

- Integrar la skill en `/sdd-do` o `/sdd-review` (tickets futuros).
- Decisiones automáticas sin preguntar (el flujo siempre es
  conversacional).
- Persistir las decisiones en un archivo separado: viven en `plan.md`.
- Heurísticas para condicionar qué decisiones se preguntan según la
  spec (posible iteración futura).
- Contrato estructurado (YAML/JSON) entre comando y skill.

## Decisiones cerradas

1. **Contrato input/output de la skill**: prosa + convención, igual que
   `close-requirement`. El comando describe en lenguaje natural los
   campos (tema, contexto, opciones con default y razón anclada); la
   skill imprime la pregunta en el formato del ticket y la decisión
   elegida queda en el contexto conversacional. Sin parsers ni
   delimitadores estructurados.

2. **Descubrimiento de la skill**: mismo patrón que las 4 skills
   existentes. `frontmatter.description` rica para autocarga por
   contexto, y `/sdd-plan` la nombra explícitamente en sus pasos.
   Prepara la puerta para que `/sdd-do` y `/sdd-review` la descubran
   cuando se integren en tickets posteriores.

3. **Formato y posición de la sección en `plan.md`**: sección
   `## Decisiones de planificación` insertada al principio, antes de
   `## Estrategia`. Formato de lista simple:
   ```
   - **<Tema>**: <opción elegida> — <razón breve>
   ```
   Coherente con el estilo del resto del template (listas de una línea,
   sin tablas).

4. **Respuestas afirmativas sueltas**: la skill acepta como
   confirmación del default cualquier respuesta afirmativa sin letra
   explícita ("ok", "sí", "vale", "adelante", "default", "usa el
   default", respuesta en blanco). La regla queda documentada dentro
   del SKILL.md.

5. **Respuesta fuera de las opciones dadas**: la skill acepta una
   propuesta alternativa del desarrollador con su justificación y la
   registra como decisión custom en `plan.md`. El espíritu del ticket
   es "dev colaborador, no aprobador": si ve una opción mejor debe
   poder aportarla.

6. **¿Siempre las 3 decisiones, o condicionales?**: siempre las tres
   en esta iteración. Sin heurísticas que decidan si alguna "no
   aplica". Si una resulta trivial (p.ej. safety net en un cambio
   puramente aditivo), la respuesta razonable es "sin protección,
   cambio aislado" y queda documentada como tal. Condicionar se
   valora en un ticket futuro con datos de uso real.

## Comportamiento esperado

- **Normal**: al ejecutar `/sdd-plan`, el agente lee la spec, y antes
  de escribir `plan.md` invoca `collaborative-decision` tres veces
  consecutivas (estrategia, granularidad, safety net). Cada invocación
  imprime la pregunta con el formato del ticket, espera respuesta,
  registra la decisión y pasa a la siguiente. Al terminar las tres,
  escribe `plan.md` con la sección `## Decisiones de planificación`
  al inicio reflejando lo cerrado, seguida del resto del template
  actual.

- **Edge cases**:
  - Usuario responde con afirmación suelta ("ok", "sí", en blanco) →
    se acepta el default.
  - Usuario responde con letra válida (A/B/C) → se registra esa
    opción.
  - Usuario propone una opción propia con justificación → se registra
    como decisión custom con la justificación dada.
  - Respuesta trivial aceptable (ej. safety net "sin protección,
    cambio aditivo") → se registra tal cual.

- **Fallo**:
  - Respuesta ambigua que no afirma, no elige letra, y no propone
    alternativa → la skill re-pregunta una vez pidiendo elección
    explícita.
  - Dos re-preguntas consecutivas sin cerrar → la skill para y avisa
    al usuario en lugar de asumir.
  - Si `/sdd-plan` detecta que la skill no está disponible (p.ej.
    instalación incompleta) → falla ruidosamente antes de redactar
    `plan.md` y pide verificar la instalación.

## Output esperado

1. Fichero nuevo: `.spec/skills/collaborative-decision/SKILL.md` con
   frontmatter (`name`, `description`) y cuerpo que define:
   - Propósito de la skill.
   - Input esperado (tema, contexto, opciones con default razonado).
   - Formato de la pregunta (el del ticket, literal).
   - Reglas de interpretación de respuestas (default implícito,
     propuesta alternativa, ambigüedad).
   - Qué hace y qué no hace (no redacta, no decide sola).

2. `.spec/commands/sdd-plan.md` modificado:
   - Paso nuevo o extensión del paso 1 que invoca
     `collaborative-decision` tres veces antes de redactar `plan.md`.
   - Template de `plan.md` actualizado: sección
     `## Decisiones de planificación` insertada al inicio.

3. `CLAUDE.md`: añadir `collaborative-decision` a la lista/mención de
   skills disponibles (sección existente o nueva, a decidir en el
   plan según encaje).

4. `README.md`: reflejar la nueva skill en la tabla de comandos y/o
   en la estructura del repo o en una mención breve donde tenga
   sentido según el estilo actual.

## Criterios de éxito

- La skill `collaborative-decision` existe en
  `.spec/skills/collaborative-decision/SKILL.md` con frontmatter
  `name` y `description`.
- Al ejecutar `/sdd-plan` sobre un ticket con `proposal.md`, el
  agente pregunta las tres decisiones (estrategia, granularidad,
  safety net) usando el formato del ticket antes de escribir nada.
- Las tres decisiones elegidas aparecen reflejadas en la sección
  `## Decisiones de planificación` al inicio del `plan.md` generado.
- Una respuesta afirmativa sin letra ("ok", "sí") se interpreta
  como aceptación del default sugerido.
- Una propuesta alternativa del usuario se acepta y queda
  documentada como decisión custom.
- `CLAUDE.md` y `README.md` mencionan la skill.
- `/sdd-do` y `/sdd-review` no cambian su comportamiento.

## Impacto arquitectónico

- Servicios afectados: `agex` (único).
- ADRs referenciados: ninguno (no hay ADRs vigentes todavía).
- ¿Requiere ADR nuevo?: **posible**. Este ticket introduce el patrón
  de **skill horizontal reutilizable entre comandos**, que marca una
  convención nueva del framework. Valorar en `/sdd-wrap` si se
  redacta un ADR para consolidar el patrón.

## Verificación sin tests automatizados

### Flujo manual

1. En una rama de un ticket de prueba (real o simulado) con un
   `proposal.md` ya escrito, ejecutar `/sdd-plan`.
2. Confirmar que el agente imprime tres preguntas consecutivas con
   el formato del ticket (Decisión / Contexto / Opciones / Default
   sugerido / ¿Cuál eliges?).
3. Responder la primera con una letra explícita ("A").
4. Responder la segunda con una afirmación suelta ("ok").
5. Responder la tercera con una propuesta alternativa justificada
   ("prefiero C: toggle de debug en config.yml porque…").
6. Revisar `plan.md` generado y verificar:
   - Sección `## Decisiones de planificación` al inicio.
   - Tres entradas, una por decisión, con la opción elegida y la
     razón.
   - La decisión custom de la tercera respuesta aparece con la
     justificación dada por el usuario.
7. Ejecutar `/sdd-do` y `/sdd-review` sobre el mismo ticket y
   verificar que no han cambiado de comportamiento.

### Qué mirar

- Archivos:
  - `.spec/skills/collaborative-decision/SKILL.md` existe y tiene
    frontmatter válido.
  - `.spec/commands/sdd-plan.md` referencia la skill en sus pasos.
  - `.docs/changes/<ticket-prueba>/plan.md` tiene la nueva sección
    al inicio.
- Documentación:
  - `CLAUDE.md` menciona la skill.
  - `README.md` menciona la skill.
- Regresiones:
  - Guardrail de `/sdd-plan` sigue funcionando (rama + `proposal.md`).
  - `/sdd-do` y `/sdd-review` sin cambios.

## Riesgos

- **Fricción percibida**: tres preguntas seguidas pueden sentirse
  pesadas. Mitigación: defaults anclados y aceptación de
  afirmación suelta permiten cerrar las tres con un "ok, ok, ok"
  cuando los defaults son correctos.

- **Inconsistencia de formato de pregunta entre invocaciones**:
  riesgo de que cada punto de decisión renderice ligeramente
  distinto. Mitigación: el formato vive literal en `SKILL.md` y es
  de obligado uso; `sdd-plan.md` no reescribe la pregunta, solo
  pasa los campos.

- **Sobreingeniería del contrato en la primera iteración**:
  tentación de meter YAML/delimitadores. Mitigación: decisión 1 lo
  descarta explícitamente; si aparece necesidad real con `/sdd-do`
  o `/sdd-review`, se aborda entonces.

- **Ambigüedad del "qué es una afirmación suelta"**: depende de la
  interpretación del agente. Mitigación: la lista de afirmaciones
  aceptadas se documenta literal en `SKILL.md` para que el
  comportamiento sea predecible.

- **Divergencia futura con `/sdd-do` y `/sdd-review`**: al no
  integrarse en esos comandos todavía, la skill se diseña sin
  feedback real de esos usos. Mitigación: mantener el contrato
  deliberadamente simple (prosa + convención) para reducir costes
  de adaptación posterior.
