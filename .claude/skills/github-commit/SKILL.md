---
name: github-commit
description: Genera mensajes de commit siguiendo Conventional Commits con la clave del issue de Jira (KAN-XX). Úsala antes de hacer un commit para asegurar que el mensaje sigue la estructura definida en el proyecto Journey TI.
---

# GitHub Commit — Journey TI

## Contexto del proyecto

- **Repositorio:** JourneyTI
- **Estrategia Git:** GitFlow
- **Jira project:** KAN (journey-ti.atlassian.net)

## Estructura del mensaje de commit

```
tipo(KAN-XX): descripción corta en imperativo

[cuerpo opcional — explica el POR QUÉ, no el QUÉ]

[footer opcional]
```

## Tipos permitidos

| Tipo | Cuándo usarlo |
|------|---------------|
| `feat` | Nueva funcionalidad |
| `fix` | Corrección de bug |
| `chore` | Tareas de mantenimiento, configuración, dependencias |
| `refactor` | Refactorización sin cambio de comportamiento |
| `test` | Añadir o modificar tests |
| `docs` | Cambios en documentación |
| `style` | Formato, espacios, punto y coma (sin cambio de lógica) |
| `ci` | Cambios en configuración de CI/CD |

## Reglas

1. La descripción va en **imperativo** y **minúsculas**: `añadir`, `crear`, `configurar`, no `añadido` ni `Añadir`.
2. Máximo **72 caracteres** en la primera línea.
3. La clave Jira es **obligatoria**: `(KAN-XX)`.
4. No añadir punto final en la descripción.
5. Si el commit cierra un issue, añadir en el footer: `Closes KAN-XX`.

## Ejemplos

```
chore(KAN-13): crear repositorio JourneyTI en GitHub

feat(KAN-18): crear proyecto Xcode con SwiftUI app lifecycle

fix(KAN-XX): corregir crash al navegar al detalle

test(KAN-XX): añadir tests unitarios para el caso de uso LoginUseCase

refactor(KAN-XX): extraer lógica de autenticación a AuthRepository

Closes KAN-XX
```

## Comportamiento del agente

1. Si el usuario no ha indicado el issue de Jira, pregúntalo.
2. Analiza los cambios en staged (o los descritos por el usuario) para inferir el tipo correcto.
3. Propón el mensaje de commit completo y pide confirmación antes de ejecutarlo.
4. Si hay múltiples cambios de distinto tipo, sugiere dividir en varios commits.
