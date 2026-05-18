# Contexto iOS — Journey TI

## Arquitectura (MVVM + Clean Architecture)

```
Domain/               ← sin imports de SwiftUI ni Foundation salvo lo imprescindible
├── Entities/         # User, AuthError
├── Repositories/     # protocolo AuthRepository
└── UseCases/         # LoginUseCase

Infrastructure/       ← implementa los protocolos de Domain
└── Repositories/     # MockAuthRepository

Presentation/         ← solo SwiftUI, sin lógica de negocio
├── Views/            # LoginView, SplashView
└── ViewModels/       # LoginViewModel (@Observable), SplashViewModel
```

Ficheros nuevos: añadir en la carpeta correcta — Xcode los incluye automáticamente (`PBXFileSystemSynchronizedRootGroup`).

## Stack

- Swift 6.3 · SwiftUI · `@Observable` (iOS 17+) · `@Bindable` para bindings
- Deployment target: iOS 17.0 · Xcode 26.x
- `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` activo — no añadir `@MainActor` explícito salvo necesidad real

## Convenciones

- Sin comentarios salvo que el WHY sea no obvio · sin docstrings multi-línea
- `@State` siempre `private` · `@Binding` solo cuando el hijo modifica estado del padre
- ViewModels: `@Observable` + inyección vía `init` · `private(set)` para outputs
- Nombres de variable mínimo 3 chars (SwiftLint `identifier_name`) · línea máx 120 chars
- No añadir error handling para casos imposibles · no validar en capas internas
- Scope exacto: no añadir features, abstracciones ni refactors fuera de la tarea

## Implementaciones actuales

| Fichero | Capa | Descripción |
|---|---|---|
| `JourneyTIApp.swift` | App | Entry point — ZStack con SplashView sobre LoginView |
| `SplashView.swift` | Presentation/Views | Splash 3s con fade a LoginView |
| `SplashViewModel.swift` | Presentation/ViewModels | Timer y control de visibilidad |
| `LoginView.swift` | Presentation/Views | Formulario email/password, loading overlay, error |
| `LoginViewModel.swift` | Presentation/ViewModels | Estado: email, password, isLoading, errorMessage |
| `LoginUseCase.swift` | Domain/UseCases | Valida y delega en AuthRepository |
| `AuthRepository.swift` | Domain/Repositories | Protocolo: `login(email:password:) async throws -> User` |
| `User.swift` | Domain/Entities | `id`, `email`, `name` |
| `AuthError.swift` | Domain/Entities | `invalidCredentials`, `networkUnavailable`, `unknown` |
| `MockAuthRepository.swift` | Infrastructure/Repositories | Credenciales `demo@journeyti.com` / `demo1234`, latencia 800ms |
