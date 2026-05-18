# Brief — Agente de tests

## Framework

Swift Testing. Nunca XCTest en targets de unit tests.
`import Testing` · `@testable import JourneyTI` · `import Foundation` si se usa `localizedDescription`.

## Estructura

```swift
@Suite("NombreFeature")
@MainActor
struct NombreFeatureTests {

    private func makeSUT(...) -> SUT { ... }  // factory siempre

    @Test("descripción comportamiento esperado")
    func nombreTest() async throws { }
}

// Helpers de test al final del fichero
private extension Tipo {
    static let stub = Tipo(...)
}
```

## Patrones críticos

**StubRepository:**
```swift
final class StubRepo: Protocolo, @unchecked Sendable {
    var result: Result<T, Error>
    func metodo() async throws -> T {
        try await Task.sleep(for: .milliseconds(50))  // ← obligatorio: crea punto de suspensión
        return try result.get()
    }
}
```

**Estado intermedio (isLoading, isAnimating...):**
```swift
let task = Task { await sut.accion() }
await Task.yield()            // ← cede el hilo para que async arranque
#expect(sut.isLoading == true)
await task.value
```

**`#require` vs `#expect`:** `#require` cuando falla → test no tiene sentido continuar (unwrap optionales, precondiciones).

## Tests existentes

`LoginViewModelTests.swift` — 6 tests: `isLoginEnabled` (3), `isLoading` (1), `errorMessage` (2).

## Verificación antes de entregar

- Todos los tests en verde (`⌘U` o `xcodebuild test`)
- Ningún test con `@MainActor` en el cuerpo — ponerlo en el `@Suite`
- Sin XCTest imports en unit tests
- Sin lógica de producción en ficheros de test
