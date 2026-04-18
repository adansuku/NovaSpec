---
name: collaborative-decision
description: Cierra un punto de decisión con el usuario presentando 2-4 opciones
  con trade-offs y un default sugerido anclado en código o contexto. Úsala desde
  cualquier comando cuando una decisión de diseño necesita criterio del
  desarrollador en vez de resolverse en silencio. El usuario es colaborador,
  no aprobador.
---

# Decisión colaborativa

Tu trabajo: convertir un punto de decisión ambiguo en una decisión cerrada
mediante una pregunta estructurada con trade-offs y un default razonado.

No decides sola. No redactas. Solo orquestas la pregunta y recoges la
respuesta.

## Input esperado

El comando que te invoca te pasa, en prosa, cuatro campos:

- **Tema** de la decisión (una línea).
- **Contexto** (1-2 líneas, anclado en el ticket o el código).
- **Opciones** (2-4), cada una con su implicación concreta.
- **Default sugerido**: una de las opciones, con una razón anclada en
  código, ticket o patrón existente.

Si el comando no te pasa alguno de los cuatro, pide el que falte antes de
preguntar al usuario. No rellenes huecos por tu cuenta.

## Formato de la pregunta

Usa este formato literal. No lo decores.

```
## Decisión: <tema>

Contexto: <1-2 líneas>

Opciones:
- A) <opción>: <implicación>
- B) <opción>: <implicación>

Default sugerido: <letra>, porque <razón anclada>.

¿Cuál eliges?
```

## Interpretación de la respuesta

### Afirmación suelta = default

Si el usuario responde con una afirmación sin letra ni opción explícita,
se interpreta como aceptación del default.

Sinónimos aceptados: `ok`, `sí`, `vale`, `adelante`, `default`,
`usa el default`, `el default`, respuesta en blanco.

### Letra o nombre de opción = esa opción

Si el usuario responde con la letra (`A`, `B`…) o con el nombre de una
de las opciones listadas, se registra esa opción.

### Propuesta alternativa = decisión custom

Si el usuario propone una opción que no estaba en la lista **con
justificación**, se acepta y se registra como decisión custom. La
justificación del usuario pasa a ser la razón registrada.

El espíritu es: dev colaborador, no aprobador. Si ve una opción mejor,
debe poder aportarla.

### Ambigüedad

Si la respuesta no afirma, no elige letra ni opción listada, y no trae
una propuesta alternativa justificada, re-pregunta **una vez**
pidiendo elección explícita.

Si la segunda respuesta tampoco cierra, **para** y avisa al comando
que te invocó. No asumas.

## Output

Devuelve al contexto conversacional, en una línea breve, la decisión
cerrada y su razón, con este formato:

```
Decisión <tema>: <opción elegida> — <razón>
```

El comando que te invocó es quien decide qué hacer con la decisión
(reflejarla en `plan.md`, encadenar otra decisión, etc.).

## Reglas

- No redactes spec, plan, ni código.
- No decidas sola: siempre pregunta.
- No inventes opciones ni defaults. Usa lo que te pasa el comando.
- No intercales comentarios tuyos entre la pregunta y la respuesta
  del usuario.
- Responde en el idioma del usuario.
