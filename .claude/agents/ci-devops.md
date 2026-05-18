# Brief — Agente CI/DevOps

## Fichero principal

`.github/workflows/ci.yml` · Runner: `macos-latest` · Xcode 26.x

## Versiones en uso (no hacer downgrade)

| Action | Versión | Node |
|---|---|---|
| `actions/checkout` | v6 | 24 nativo |
| `actions/cache` | v5 | 24 nativo |
| `actions/upload-artifact` | v7 | 24 nativo |
| `codecov/codecov-action` | v6 | 24 nativo |

## Decisiones inamovibles

**Deployment target iOS 17.0** — runner tiene iOS 26.2 max sin devices pre-creados. iOS 18.x tiene devices. No subir el target.

**UDID dinámico** — `OS=latest` resuelve en iOS 26.x sin devices. Siempre extraer UDID con grep y pasar `id=UDID` a xcodebuild:
```bash
UDID=$(xcrun simctl list devices available \
  | grep -E "iPhone" \
  | grep -oE '[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}' \
  | tail -1)
```

**Coverage con xccov** — los inputs `xcode`/`xcode_archive_path` de Codecov no existen en v4+. Usar:
```bash
xcrun xccov view --report --json TestResults.xcresult > xccov_report.json
# codecov: file: xccov_report.json
```

**YAML embebido** — nunca incrustar código Python multi-línea con indentación cero en bloques `run: |`. Usar solo shell (grep, awk, sed).

## Estructura del pipeline

Checkout → Xcode select → Caché Homebrew → Install tools → SwiftLint → Resolve simulator → Build & Test → Export coverage → Codecov → Upload artifact

## Verificación antes de entregar

- YAML válido (sin tabs, indentación consistente)
- No se ha hecho downgrade de versiones de actions
- Deployment target no modificado (debe ser 17.0)
- Pipeline probado en PR antes de mergear a develop
