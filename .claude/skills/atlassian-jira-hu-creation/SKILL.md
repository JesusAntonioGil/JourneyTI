---
name: atlassian-jira-hu-creation
description: Crea una Historia de Usuario en el proyecto Jira Journey TI (KAN) siguiendo la plantilla estándar del proyecto. Úsala cuando el usuario quiera crear una o varias HU. Recoge la información necesaria haciendo preguntas cortas y crea el issue directamente en Jira.
---

# Crear Historia de Usuario — Journey TI

## Contexto del proyecto

- **Jira project:** Journey TI (clave: `KAN`, ID: `10000`)
- **Atlassian site:** `journey-ti.atlassian.net`
- **Stack:** Swift 6.3, SwiftUI, Swift Testing, MVVM + Clean Architecture, SPM, GitFlow
- **IA:** Claude (Anthropic)

## Comportamiento del agente

1. Si el usuario no ha proporcionado el título de la HU, pregúntalo primero.
2. Haz preguntas cortas y en orden para recoger la información de cada sección de la plantilla. No hagas todas las preguntas a la vez.
3. Para secciones opcionales (dependencias), pregunta si las hay. Si no, omite la sección.
4. Antes de crear el issue, muestra un resumen de la HU y pide confirmación.
5. Crea el issue en Jira usando el tipo `Historia` (ID: `10004`) en el proyecto `KAN`.
6. Una vez creado, muestra el ID del issue (ej. `KAN-1`) y el enlace directo.

## Plantilla de Historia de Usuario

Usa esta estructura exacta para el cuerpo del issue en Jira (formato markdown):

```
**Como** [rol], **quiero** [acción], **para** [beneficio].

---

## Criterios de aceptación
- [ ] ...
- [ ] ...

## Notas técnicas
- ...

## Dependencias
- ...

## Definición de hecho (DoD)
- [ ] Código revisado y aprobado
- [ ] Tests escritos con Swift Testing
- [ ] Sin warnings de compilación en Swift 6.3
- [ ] Integrado en rama `develop` siguiendo GitFlow
```

## Preguntas guía por sección

- **Rol / Como:** ¿Quién realiza la acción? (desarrollador, usuario, equipo...)
- **Acción / Quiero:** ¿Qué se quiere conseguir?
- **Beneficio / Para:** ¿Por qué es necesario? ¿Qué valor aporta?
- **Criterios de aceptación:** ¿Qué condiciones deben cumplirse para considerar la HU terminada?
- **Notas técnicas:** ¿Hay alguna restricción técnica, patrón o componente del stack relevante?
- **Dependencias:** ¿Depende de otra HU o issue?

## Errores comunes a evitar

- No crear la HU sin confirmar primero el resumen con el usuario.
- No omitir los criterios de aceptación — son obligatorios.
- No usar el tipo `Tarea` en lugar de `Historia`.
- El DoD base siempre debe incluir los 4 puntos predefinidos; se pueden añadir más.
