# Contexto Tests — Journey TI

## Framework

Swift Testing exclusivamente: `@Suite`, `@Test`, `#expect`, `#require`.
XCTest solo para UI tests (`XCUIApplication`). No mezclar en el mismo fichero.

## Estructura estándar

```swift
@Suite("NombreFeature")
@MainActor
struct NombreFeatureTests {

    private func makeSUT(...) -> SUT { ... }

    @Test("descripción del comportamiento esperado")
    func nombreTest() async throws {
        let sut = makeSUT()
        // act
        // #expect / #require
    }
}
```

## Patrones establecidos

**StubRepository:** recibe `Result<T, Error>` configurable en `init`. Añade siempre `Task.sleep(for: .milliseconds(50))` para crear un punto de suspensión real y evitar que el test termine antes de que el async code ejecute.

**Tests de estado intermedio (ej. `isLoading`):**
```swift
let task = Task { await sut.login() }
await Task.yield()                        // cede el hilo para que el async arranque
#expect(sut.isLoading == true)
await task.value
```

**`#require` vs `#expect`:** usa `#require` cuando el test no tiene sentido si la condición falla (unwrap de optionales, precondiciones).

**Nombres de test:** string descriptivo en `@Test("...")` — describe el comportamiento, no la implementación.

## Tests existentes

| Fichero | Tests | Qué cubre |
|---|---|---|
| `LoginViewModelTests.swift` | 6 | `isLoginEnabled` (3), `isLoading` (1), `errorMessage` (2) |

## Convenciones

- Tests excluidos de SwiftLint (ver `.swiftlint.yml` — `excluded: JourneyTITests`)
- `import Foundation` siempre que se use `localizedDescription` u otras APIs de Foundation
- `@testable import JourneyTI` para acceder a tipos internos
- Helpers privados de test (`extension User { static let stub = ... }`) al final del fichero
