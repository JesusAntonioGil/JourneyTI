# Brief — Agente de gestión de proyecto

## Git / GitFlow

| Rama | Propósito |
|---|---|
| `main` | Producción — protegida, requiere CI verde + review |
| `develop` | Integración — protegida |
| `feature/KAN-XX-descripcion` | Nueva funcionalidad |
| `fix/descripcion` | Corrección de bug |
| `chore/descripcion` | Mantenimiento / configuración |
| `hotfix/KAN-XX-descripcion` | Corrección urgente sobre `main` |

**Flujo:** rama desde `develop` → PR a `develop` → merge → PR develop→main cuando corresponda.

## Commits — Conventional Commits

```
tipo(KAN-XX): descripción en imperativo, máx 72 chars
```

Tipos: `feat` `fix` `chore` `refactor` `test` `docs` `style` `ci`
Clave Jira **obligatoria**. Sin punto final. Descripción en minúsculas e imperativo.

## Jira

Proyecto: `KAN` · Site: `journey-ti.atlassian.net`
Issue types: Épica · Historia (ID: `10004`) · Subtask
Estados: Tareas por hacer → En progreso → En revisión → Completado

**Plantilla Historia de Usuario:**
```
Como [rol], quiero [acción], para [beneficio].

## Criterios de aceptación
- [ ] ...

## Notas técnicas
- ...

## Dependencias
- ...

## Definición de hecho (DoD)
- [ ] Código revisado y aprobado
- [ ] Tests escritos con Swift Testing
- [ ] Sin warnings de compilación en Swift 6.3
- [ ] Integrado en rama develop siguiendo GitFlow
```

## Confluence

Espacio: `JT` · Site: `journey-ti.atlassian.net`

| Página | ID | Contenido |
|---|---|---|
| Documentación Técnica | 884737 | Arquitectura, funcionalidades implementadas |
| Documentación Stack Tecnológico | 1015809 | Links a docs oficiales del stack |
| Documentación Histórica | 655363 | Decisiones, riesgos, involuciones con fecha |

Al añadir una funcionalidad importante: actualizar "Documentación Técnica".
Al tomar una decisión técnica no trivial: añadir entrada en "Documentación Histórica".

## PRs

Título = formato commit (`tipo(KAN-XX): descripción`).
Base habitual: `develop`. Hotfix → `main`.
Body: descripción · `Closes KAN-XX` · cambios principales · checklist DoD.
Merge method: squash.
