# JourneyTI

![CI](https://github.com/JesusAntonioGil/JourneyTI/actions/workflows/ci.yml/badge.svg)
[![codecov](https://codecov.io/gh/JesusAntonioGil/JourneyTI/branch/main/graph/badge.svg)](https://codecov.io/gh/JesusAntonioGil/JourneyTI)

Proyecto interno de demostración que explora cómo incorporar IA en las fases de **desarrollo y pruebas** del ciclo de vida software iOS.

## Descripción

JourneyTI es una app iOS construida como campo de pruebas para adoptar herramientas de IA (Claude) en el flujo de trabajo de desarrollo. Cada funcionalidad se implementa documentando qué aporta la IA al proceso: diseño, implementación, testing y revisión de código.

## Stack tecnológico

| Área | Tecnología |
|------|-----------|
| Lenguaje | Swift 6.3 |
| UI | SwiftUI |
| Testing | Swift Testing |
| IDE | Xcode 26+ |
| Arquitectura | MVVM + Clean Architecture |
| Dependencias | Swift Package Manager |
| CI | GitHub Actions |
| IA | Claude (Anthropic) |

## Requisitos

- Xcode 26 o superior
- Simulador iPhone 17 o superior (iOS 26.4+)

## Arquitectura

```
JourneyTI/
├── Presentation/
│   ├── Views/
│   └── ViewModels/
├── Domain/
│   ├── Entities/
│   └── UseCases/
└── Infrastructure/
    └── Repositories/
```

## CI

Cada push y pull request sobre `main` y `develop` ejecuta automáticamente:

1. **SwiftLint** — análisis estático con anotaciones nativas en el PR
2. **Build & Test** — compilación y tests en simulador iPhone 17 Pro con output legible via `xcbeautify`
3. **Cobertura** — reporte automático a Codecov con anotaciones por PR
4. **Artefactos** — `.xcresult` disponible para descarga en cada run

La rama `main` está protegida: no se puede mergear sin que el job `Build & Test` pase.

## Documentación

La documentación técnica y de producto está en el espacio Confluence **Journey TI**:
[https://journey-ti.atlassian.net/wiki/spaces/JT](https://journey-ti.atlassian.net/wiki/spaces/JT)
