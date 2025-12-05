**API - Gestión de Grupos y Roles**

- Ubicación: `api/openapi/groups.yaml`
- Formato: OpenAPI 3.0
- Autenticación: `Bearer JWT` (esquema `bearerAuth`)

Quickstart:

Generar cliente Dart con openapi-generator:
```bash
openapi-generator-cli generate -i api/openapi/groups.yaml -g dart-dio -o client/dart_groups_api
```

Generar cliente TypeScript (axios):
```bash
openapi-generator-cli generate -i api/openapi/groups.yaml -g typescript-axios -o client/ts_groups_api
```

Ejemplos curl:
- Listar grupos (GET `/api/groups`):
```bash
curl -H "Authorization: Bearer <JWT>" "/api/groups"
```
- Crear grupo (POST `/api/groups`):
```bash
curl -X POST -H "Authorization: Bearer <JWT>" -H "Content-Type: application/json" -d '{"name":"Grupo de Ejemplo"}' "/api/groups"
```

Siguientes pasos sugeridos:
- Revisar y adaptar las respuestas y campos a los modelos reales del backend.
- Generar clientes y añadir pruebas de integración.
- Implementar validaciones (fechas, pertenencia) en el servidor.

Si quieres, puedo:
- Generar los DTOs/servicios Dart en `lib/infrastructure/dtos` y `lib/infrastructure/services`.
- Crear mocks para pruebas unitarias en `test/` usando este spec.
