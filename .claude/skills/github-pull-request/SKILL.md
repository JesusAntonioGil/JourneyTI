---
name: github-pull-request
description: Crea Pull Requests en GitHub siguiendo la plantilla definida en el proyecto Journey TI, con referencia al issue de Jira (KAN-XX) y checklist del DoD. Úsala cuando el usuario quiera abrir un PR desde una rama feature, release o hotfix.
---

# GitHub Pull Request — Journey TI

## Contexto del proyecto

- **Repositorio:** JourneyTI
- **Estrategia Git:** GitFlow
- **Jira project:** KAN (journey-ti.atlassian.net)
- **Rama base habitual:** `develop` (excepto hotfix → `main`)

## Convención de nombres de rama

| Tipo | Formato | Ejemplo |
|------|---------|---------|
| Feature | `feature/KAN-XX-descripcion` | `feature/KAN-18-crear-proyecto-xcode` |
| Release | `release/vX.X.X` | `release/v1.0.0` |
| Hotfix | `hotfix/KAN-XX-descripcion` | `hotfix/KAN-XX-fix-crash-login` |

## Plantilla de Pull Request

```
## Descripción
[Resumen breve de los cambios y su propósito]

## Issue relacionado
Closes KAN-XX

## Tipo de cambio
- [ ] feat — nueva funcionalidad
- [ ] fix — corrección de bug
- [ ] chore — mantenimiento / configuración
- [ ] refactor — refactorización
- [ ] test — tests
- [ ] docs — documentación

## Cambios principales
- ...
- ...

## Checklist (DoD)
- [ ] Código revisado y aprobado
- [ ] Tests escritos con Swift Testing
- [ ] Sin warnings de compilación en Swift 6.3
- [ ] Integrado en rama `develop` siguiendo GitFlow

## Capturas / evidencias (opcional)
[Añadir si aplica]
```

## Reglas

1. El título del PR debe seguir el mismo formato que el commit: `tipo(KAN-XX): descripción`.
2. Siempre incluir `Closes KAN-XX` para cerrar automáticamente el issue en Jira al mergear.
3. La rama base por defecto es `develop`. Solo los hotfix van contra `main`.
4. No mergear sin al menos un review aprobado (branch protection en `main`).
5. Resolver todos los conflictos antes de solicitar review.

## Comportamiento del agente

1. Si el usuario no ha indicado el issue de Jira, pregúntalo.
2. Revisar los commits de la rama para inferir el título y los cambios principales.
3. Proponer el PR completo (título + cuerpo) y pedir confirmación antes de crearlo.
4. Usar el MCP de GitHub (`mcp__github__create_pull_request`) para crearlo directamente.
5. Una vez creado, mostrar la URL del PR y actualizar el issue de Jira a "En revisión".
