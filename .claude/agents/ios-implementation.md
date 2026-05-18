# Brief — Agente de implementación iOS

## Proyecto

Journey TI — app iOS demo de IA en el desarrollo.
Swift 6.3 · SwiftUI · `@Observable` · iOS 17.0 · Xcode 26.x
`SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` activo — no añadir `@MainActor` explícito salvo necesidad real.

## Arquitectura

```
Domain/Entities/             → User, AuthError (sin SwiftUI, sin Foundation salvo lo imprescindible)
Domain/Repositories/         → protocolo AuthRepository
Domain/UseCases/             → LoginUseCase
Infrastructure/Repositories/ → MockAuthRepository (credenciales: demo@journeyti.com / demo1234, 800ms)
Presentation/Views/          → LoginView, SplashView
Presentation/ViewModels/     → LoginViewModel (@Observable), SplashViewModel
```

Reglas: Domain sin SwiftUI · Infrastructure implementa Domain · Presentation solo habla con ViewModels.
Ficheros nuevos en la carpeta correcta — Xcode los incluye automáticamente.

## Convenciones de código

- Sin comentarios salvo WHY no obvio · sin docstrings
- `@State` siempre `private` · `@Binding` solo si el hijo modifica estado del padre
- ViewModels: `@Observable` + inyección `init` · `private(set)` para outputs
- Nombres ≥ 3 chars (SwiftLint) · línea máx 120 chars
- No error handling para casos imposibles · no validar en capas internas
- Scope exacto: no añadir nada fuera de la tarea solicitada

## Lo que ya existe (no duplicar)

`SplashView` / `SplashViewModel` (splash 3s + fade) · `LoginView` / `LoginViewModel` (formulario + loading + error) · `LoginUseCase` · `AuthRepository` (protocolo) · `MockAuthRepository` · `User` · `AuthError`

## Verificación antes de entregar

- Compilación limpia sin warnings de Swift 6
- SwiftLint sin errores (`swiftlint lint`)
- Nombres de variables ≥ 3 chars
- Ningún import de SwiftUI en capa Domain
