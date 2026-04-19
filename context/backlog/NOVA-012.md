# NOVA-012 — Integrar Jira MCP en nova-start y nova-wrap

**Tipo**: feature (integración)
**Prioridad**: media
**Estimación**: media (1-2h)

## Problema

`nova-start` acepta un ID de ticket como string pero no hace fetch real de
Jira. El desarrollador tiene que copiar manualmente título, descripción y
criterios de aceptación del ticket a la conversación. `nova-wrap` tampoco
actualiza el estado del ticket en Jira al cerrar.

## Prerequisito

Configurar el MCP server de Atlassian en Claude Code:

```json
// ~/.claude/settings.json
{
  "mcpServers": {
    "atlassian": {
      "command": "npx",
      "args": ["-y", "@atlassian/mcp-atlassian"],
      "env": {
        "JIRA_URL": "https://tu-empresa.atlassian.net",
        "JIRA_EMAIL": "tu@email.com",
        "JIRA_API_TOKEN": "tu-token"
      }
    }
  }
}
```

Token en: `https://id.atlassian.com/manage-profile/security/api-tokens`

## Propuesta

### nova-start.md
Añadir bloque opcional al inicio:

```
Si el TICKET tiene formato Jira (e.g. PROJ-123), usa el MCP atlassian
para hacer fetch del ticket: título, descripción, criterios de aceptación,
labels, assignee. Si el MCP no está disponible, pide al usuario que pegue
el contenido del ticket manualmente.
```

### nova-wrap.md
Añadir bloque opcional al cierre:

```
Si el MCP atlassian está disponible:
1. Transiciona el ticket a "Done" (o el estado configurado en config.yml).
2. Añade un comentario con el link al PR y el resumen de la spec.
```

### novaspec/config.yml
Añadir sección opcional:

```yaml
jira:
  base_url: ""          # https://tu-empresa.atlassian.net
  done_status: "Done"   # nombre exacto del estado de cierre en tu board
```

La integración es **opt-in**: si `jira.base_url` está vacío o el MCP no
está configurado, el flujo funciona exactamente igual que hoy.

## Criterio de aceptación

1. `/nova-start PROJ-123` hace fetch automático del ticket si el MCP está
   disponible.
2. `/nova-wrap` transiciona el estado y comenta el PR link en Jira.
3. Sin MCP configurado, el flujo no cambia ni lanza errores.
4. `novaspec/config.yml` tiene sección `jira:` documentada.

## Archivos afectados

- `novaspec/commands/nova-start.md`
- `novaspec/commands/nova-wrap.md`
- `novaspec/config.yml`
