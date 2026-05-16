# CLAUDE.md — Journey TI

## Proyecto

App iOS de demostración que muestra el uso de IA (Claude) en el desarrollo de software.
Repositorio: `JesusAntonioGil/JourneyTI` (público)
Jira: proyecto `KAN` en `journey-ti.atlassian.net`
Confluence: espacio `JT` en `journey-ti.atlassian.net`

---

## Stack técnico

| Elemento | Valor |
|---|---|
| Lenguaje | Swift 6.3 |
| UI | SwiftUI |
| Testing | Swift Testing (`@Suite`, `@Test`, `#expect`, `#require`) |
| Observabilidad | `@Observable` macro (iOS 17+), `@Bindable` para bindings |
| Gestión de dependencias | Sin SPM — todo en el target Xcode |
| Deployment target | iOS 17.0 |
| Xcode | 26.x |
| Linter | SwiftLint (ver `.swiftlint.yml`) |

---

## Arquitectura

MVVM + Clean Architecture. Tres capas:

```
JourneyTI/
├── Domain/               # Lógica de negocio pura — sin imports de UIKit/SwiftUI
│   ├── Entities/         # Modelos: User, AuthError
│   ├── Repositories/     # Protocolos: AuthRepository
│   └── UseCases/         # Casos de uso: LoginUseCase
├── Infrastructure/       # Implementaciones concretas de los repositorios
│   └── Repositories/     # MockAuthRepository (y futuros repositorios reales)
└── Presentation/         # Solo SwiftUI — no lógica de negocio aquí
    ├── Views/            # LoginView, SplashView
    └── ViewModels/       # LoginViewModel (@Observable), SplashViewModel
```

**Reglas de capas:**
- Domain no depende de nada externo (ni SwiftUI, ni Foundation salvo lo imprescindible)
- Infrastructure implementa los protocolos de Domain
- Presentation solo habla con ViewModels; los ViewModels llaman a UseCases
- Los ficheros nuevos se añaden en la carpeta correcta — Xcode los incluye automáticamente (`PBXFileSystemSynchronizedRootGroup`)

---

## Convenciones de código

- **Sin comentarios** salvo que el WHY sea no obvio
- **Sin docstrings** multi-línea
- **Nombres descriptivos** — el código se explica solo
- Variables `@State` siempre `private`; `@Binding` solo cuando el hijo modifica estado del padre
- ViewModels con `@Observable`; inyección vía `init`
- No añadir manejo de errores para casos imposibles; no validar en capas internas
- SwiftLint activo: línea máx 120 (warning) / 200 (error); nombres de variable mínimo 3 caracteres

---

## Workflow Git — GitFlow

```
main          ← producción, protegida (requiere CI verde + review)
develop       ← integración, protegida
feature/KAN-XX-descripcion
fix/descripcion
chore/descripcion
release/vX.X.X
hotfix/KAN-XX-descripcion
```

**Flujo habitual:** crear rama desde `develop` → PR a `develop` → merge → PR develop→main cuando corresponda.

### Commits — Conventional Commits

```
tipo(KAN-XX): descripción en imperativo, máx 72 chars
```

Tipos: `feat`, `fix`, `chore`, `refactor`, `test`, `docs`, `style`, `ci`
La clave Jira `(KAN-XX)` es **obligatoria**. Sin punto final.

---

## CI — GitHub Actions

Fichero: `.github/workflows/ci.yml`
Runner: `macos-latest`, Xcode 26.x

Pasos en orden:
1. Checkout (`actions/checkout@v6`)
2. Seleccionar Xcode 26
3. Caché Homebrew (SwiftLint + xcbeautify)
4. Instalar SwiftLint y xcbeautify si no hay caché
5. SwiftLint (`--reporter github-actions-logging`)
6. Resolver simulador (grep UDID del primer iPhone disponible)
7. Build & Test (`xcodebuild test` + xcbeautify)
8. Export coverage (`xccov view --report --json`)
9. Upload a Codecov (`codecov/codecov-action@v6`, `file: xccov_report.json`)
10. Upload artifact TestResults.xcresult

**Para correr tests localmente:**
```bash
xcodebuild test \
  -project JourneyTI/JourneyTI.xcodeproj \
  -scheme JourneyTI \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO
```

---

## Skills disponibles

Invoca con `/nombre-del-skill`:

| Skill | Cuándo usarlo |
|---|---|
| `/github-commit` | Antes de hacer un commit — genera el mensaje correcto |
| `/github-pull-request` | Para abrir un PR con la plantilla del proyecto |
| `/atlassian-jira-hu-creation` | Para crear una Historia de Usuario en Jira |
| `/swift-testing-expert` | Tests con Swift Testing, `#expect`, parameterización |
| `/swift-concurrency` | `async/await`, actores, `Sendable`, Swift 6 |
| `/swiftui-expert-skill` | SwiftUI: estado, composición, rendimiento, iOS 26+ |

---

## Selección de modelo por tarea

Usa el modelo más económico que sea suficiente para la tarea. El parámetro `model` en cada llamada `Agent` controla esto.

| Modelo | Cuándo usarlo |
|---|---|
| `haiku` | Búsquedas, lectura de ficheros, grep, lint, tareas de un solo paso sin razonamiento complejo |
| `sonnet` | Implementación de código, tests, PRs, corrección de bugs, tareas de desarrollo habituales |
| `opus` | Diseño de arquitectura, planning multi-fichero, revisiones críticas, decisiones con muchas dependencias |

**Regla general:** empieza por `haiku` para exploración y `sonnet` para implementación. Escala a `opus` solo cuando la tarea requiera razonamiento profundo sobre el sistema completo.

---

## Agentes y paralelismo

Usa agentes y subagentes en paralelo **siempre que las tareas sean independientes entre sí**. Este es el modo de trabajo preferido en este proyecto.

**Cuándo lanzar agentes en paralelo:**
- Implementar varias capas simultáneamente (Domain + Infrastructure + Presentation)
- Crear tests mientras se implementa el código de producción
- Investigar varias partes del código a la vez
- Ejecutar búsquedas o lecturas de ficheros independientes

**Cómo hacerlo:**
- Lanza múltiples llamadas `Agent` en el mismo mensaje (un bloque de tool calls)
- Usa `run_in_background: true` para agentes que no bloquean el flujo
- Define contratos compartidos (protocolos, entidades) antes de lanzar agentes en paralelo, para que todos trabajen contra la misma interfaz
- Usa `TaskCreate` / `TaskUpdate` para hacer el progreso visible mientras los agentes trabajan

**Tipos de agente recomendados:**
- `Explore` — búsquedas y lectura de código (read-only, rápido)
- `general-purpose` — implementación de código, multi-paso
- `Plan` — diseño de arquitectura antes de implementar

---

## MCPs activos

- **atlassian** — Jira y Confluence (leer/escribir issues, páginas)
- **github** — PRs, issues, releases, búsqueda de código
- **xcodebuildmcp** — build, test y simulador desde Claude
- **figma** — diseño y generación de UI
