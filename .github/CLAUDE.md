# Contexto CI — Journey TI

## Pipeline actual

Fichero: `workflows/ci.yml` · Runner: `macos-latest` · Xcode 26.x · Actions en Node 24

| Paso | Acción / Comando |
|---|---|
| Checkout | `actions/checkout@v6` |
| Seleccionar Xcode | `xcode-select -s /Applications/Xcode_26.0.app` (`continue-on-error: true`) |
| Caché Homebrew | `actions/cache@v5` — SwiftLint + xcbeautify en `/opt/homebrew/Cellar/` |
| Instalar tools | `brew install swiftlint xcbeautify` (solo si no hay caché) |
| SwiftLint | `swiftlint lint --reporter github-actions-logging` |
| Resolve simulator | grep UDID del primer iPhone disponible; fallback: `simctl create` |
| Build & Test | `xcodebuild test` + `xcbeautify --renderer github-actions` |
| Export coverage | `xcrun xccov view --report --json TestResults.xcresult > xccov_report.json` |
| Codecov | `codecov/codecov-action@v6` con `file: xccov_report.json` |
| Upload artifact | `actions/upload-artifact@v7` — `TestResults.xcresult` |

## Decisiones clave — no revertir sin revisar

**Deployment target iOS 17.0**
El runner tiene iOS 26.2 como runtime máximo pero sin simuladores pre-creados para iOS 26.x. iOS 18.x sí tiene dispositivos disponibles. Deployment target 17.0 es compatible con todas las APIs usadas.

**UDID dinámico en lugar de `OS=latest`**
`OS=latest` resolvía en iOS 26.x donde no existen devices. El paso "Resolve simulator" extrae el UDID del primer iPhone disponible con grep y lo pasa como `id=UDID` a xcodebuild.

**xccov en lugar de inputs `xcode`/`xcode_archive_path` de Codecov**
Esos inputs fueron eliminados de codecov-action v4+. El JSON de `xccov view --report` es interpretado nativamente por la CLI de Codecov.

**Actions en versiones Node 24 nativas**
checkout@v6, cache@v5, upload-artifact@v7, codecov@v6. No hacer downgrade — Node 20 se elimina de los runners en septiembre 2026.

## Comandos útiles para debug local

```bash
# Listar simuladores disponibles
xcrun simctl list devices available | grep iPhone

# Correr tests localmente
xcodebuild test \
  -project JourneyTI/JourneyTI.xcodeproj \
  -scheme JourneyTI \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO

# Exportar cobertura
xcrun xccov view --report --json TestResults.xcresult > xccov_report.json
```
