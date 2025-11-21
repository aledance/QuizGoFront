# QuizGoFront
Repositorio de la parte de front del proyecto de desarrollo de software

## Registro de cambios recientes (BackOffice / Admin features)

Fecha: 2025-11-19

Resumen: en la rama `E12/BackOfficeV1` se añadieron y mejoraron múltiples capacidades administrativas, incluidas moderación de Kahoots, edición desde el backoffice, gestión de temas, y un sistema de notificaciones de administración para pruebas (mock). También se realizaron mejoras en la UI de administración (drawer, páginas, utilidades). A continuación se detallan las tareas realizadas y los archivos principales afectados.

Tareas realizadas
- Añadido soporte de moderación/gestión de Kahoots (listar, bloquear/activar, eliminar, editar desde Backoffice).
- Renombrada la entrada del Drawer a `Admin Kahoots!`.
- Habilitada edición completa de Kahoots desde la lista de moderación conservando `author` y `theme`.
- Seed del mock server con preguntas y respuestas para que el editor cargue datos reales de prueba.
- Implementada gestión de `Temas` (endpoints en mock server, data source, UI de CRUD y selector de tema en el editor).
- Implementado un sistema de Notificaciones (versión rápida/demo) para que administradores envíen notificaciones a todos o a un usuario específico (endpoints mock + UI + data source).
- En la página de usuarios se añadió la visualización del `id` y un botón para copiarlo al portapapeles.
- Localización rápida: mensajes de éxito/error en la UI de Notificaciones en español.



