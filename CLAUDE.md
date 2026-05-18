# CLAUDE.md — Journey TI (Orquestador)

## Proyecto

App iOS que demuestra el uso de IA (Claude) en el desarrollo de software.
Repositorio: `JesusAntonioGil/JourneyTI` | Jira: `KAN` | Confluence: `JT` | `journey-ti.atlassian.net`

---

## Routing de agentes

Incluye siempre el fichero de contexto indicado en el prompt del agente.

| Tarea | Tipo agente | Modelo | Fichero de contexto |
|---|---|---|---|
| Búsqueda / lectura de código | `Explore` | `haiku` | — |
| Implementación iOS (Swift/SwiftUI) | `general-purpose` | `sonnet` | `.claude/agents/ios-implementation.md` |
| Tests unitarios | `general-purpose` | `sonnet` | `.claude/agents/testing.md` |
| CI / GitHub Actions | `general-purpose` | `sonnet` | `.claude/agents/ci-devops.md` |
| Git / Jira / PR / Confluence | `general-purpose` | `haiku` | `.claude/agents/project-management.md` |
| Diseño de arquitectura | `Plan` | `opus` | Todos los ficheros de `.claude/agents/` |
| Tareas paralelas independientes | múltiples `Agent` en un mensaje | según tipo | cada uno su contexto |

**Reglas de paralelismo:**
- Lanza múltiples agentes en el mismo mensaje cuando las tareas no dependan entre sí
- Define contratos (protocolos, entidades) antes de paralelizar implementaciones
- `run_in_background: true` para agentes que no bloquean el flujo
- `TaskCreate` / `TaskUpdate` para visibilidad del progreso

---

## Skills disponibles

| Skill | Cuándo |
|---|---|
| `/github-commit` | Antes de hacer un commit |
| `/github-pull-request` | Para abrir un PR |
| `/atlassian-jira-hu-creation` | Para crear una HU en Jira |
| `/swift-testing-expert` | Tests con Swift Testing |
| `/swift-concurrency` | async/await, actores, Swift 6 |
| `/swiftui-expert-skill` | SwiftUI, estado, iOS 26+ |

---

## MCPs activos

- **atlassian** — Jira (KAN) y Confluence (JT)
- **github** — PRs, issues, releases, búsqueda de código
- **xcodebuildmcp** — build, test y simulador desde Claude
- **figma** — diseño y generación de UI

---

## Contextos por directorio (carga automática)

Claude Code carga automáticamente el `CLAUDE.md` del directorio en el que trabaja:

- `JourneyTI/JourneyTI/CLAUDE.md` → al editar código de la app iOS
- `JourneyTI/JourneyTITests/CLAUDE.md` → al editar tests
- `.github/CLAUDE.md` → al editar workflows de CI
