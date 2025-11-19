import 'dart:convert';
import 'dart:io';

/// Simple in-memory mock server for /kahoots endpoints.
/// Run with: dart run bin/mock_server.dart

void main(List<String> args) async {
  final port = int.tryParse(Platform.environment['MOCK_SERVER_PORT'] ?? '') ?? 3000;
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  stderr.writeln('Mock server listening on http://localhost:$port');

  final storage = <String, Map<String, dynamic>>{};
  // simple in-memory storage for admin users
  final storageUsers = <String, Map<String, dynamic>>{};

  Map<String, dynamic> normalizeUser(Map<String, dynamic> src) {
    final user = Map<String, dynamic>.from(src);
    // If legacy 'roles' array exists, pick the first valid role
    if (user.containsKey('roles') && user['roles'] is List) {
      final lst = (user['roles'] as List).where((e) => e != null).map((e) => e.toString()).toList();
      if (lst.isNotEmpty) {
        user['role'] = lst.first;
      }
      user.remove('roles');
    }
    // Ensure a single 'role' string exists
    if (!user.containsKey('role') || user['role'] == null) {
      user['role'] = 'player';
    }
    // ensure active is boolean
    if (!user.containsKey('active')) user['active'] = true;
    // derive compatible response fields: 'status' (string) and 'userType' (alias for role)
    final isActive = user['active'] == true;
    user['status'] = isActive ? 'active' : 'blocked';
    // map internal role names to the 'userType' expected in the spec (e.g. 'educator' -> 'teacher')
    final role = (user['role'] ?? 'player').toString();
    user['userType'] = role == 'educator' ? 'teacher' : role;
    return user;
  }

  server.listen((HttpRequest req) async {
    try {
      // Add CORS headers for convenience
      req.response.headers.add('Access-Control-Allow-Origin', '*');
      req.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  req.response.headers.add('Access-Control-Allow-Headers', 'Content-Type, Authorization');

      if (req.method == 'OPTIONS') {
        req.response.statusCode = HttpStatus.noContent;
        await req.response.close();
        return;
      }

      final pathSegments = req.uri.pathSegments.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

      // POST /kahoots -> create
      if (req.method == 'POST' && pathSegments.length == 1 && pathSegments[0] == 'kahoots') {
        final body = await utf8.decoder.bind(req).join();
        final data = (body.isNotEmpty) ? json.decode(body) as Map<String, dynamic> : <String, dynamic>{};
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        data['id'] = id;
        data['createdAt'] = DateTime.now().toIso8601String();
        storage[id] = data;
        req.response.statusCode = HttpStatus.created; // 201
        req.response.headers.contentType = ContentType.json;
        req.response.write(json.encode(data));
        await req.response.close();
        return;
      }

      // GET /kahoots or /kahoots/:id
      if (req.method == 'GET' && pathSegments.isNotEmpty && pathSegments[0] == 'kahoots') {
        if (pathSegments.length == 1) {
          // list
          final list = storage.values.toList();
          req.response.statusCode = HttpStatus.ok;
          req.response.headers.contentType = ContentType.json;
          req.response.write(json.encode(list));
          await req.response.close();
          return;
        }

        final id = pathSegments[1];
        final existing = storage[id];
        if (existing == null) {
          req.response.statusCode = HttpStatus.notFound;
          req.response.headers.contentType = ContentType.json;
          req.response.write(json.encode({'error': 'Not found'}));
          await req.response.close();
          return;
        }
        req.response.statusCode = HttpStatus.ok;
        req.response.headers.contentType = ContentType.json;
        req.response.write(json.encode(existing));
        await req.response.close();
        return;
      }

      // PUT /kahoots/:id -> update
      if (req.method == 'PUT' && pathSegments.length == 2 && pathSegments[0] == 'kahoots') {
        final id = pathSegments[1];
        final existing = storage[id];
        if (existing == null) {
          req.response.statusCode = HttpStatus.notFound;
          req.response.headers.contentType = ContentType.json;
          req.response.write(json.encode({'error': 'Not found'}));
          await req.response.close();
          return;
        }
        final body = await utf8.decoder.bind(req).join();
        final data = (body.isNotEmpty) ? json.decode(body) as Map<String, dynamic> : <String, dynamic>{};
        // Merge fields, but keep id/createdAt if not provided
        data['id'] = id;
        data['createdAt'] = existing['createdAt'] ?? DateTime.now().toIso8601String();
        storage[id] = data;
        req.response.statusCode = HttpStatus.ok;
        req.response.headers.contentType = ContentType.json;
        req.response.write(json.encode(data));
        await req.response.close();
        return;
      }

      // DELETE /kahoots/:id
      if (req.method == 'DELETE' && pathSegments.length == 2 && pathSegments[0] == 'kahoots') {
        final id = pathSegments[1];
        final existed = storage.remove(id);
        if (existed == null) {
          req.response.statusCode = HttpStatus.notFound;
          req.response.headers.contentType = ContentType.json;
          req.response.write(json.encode({'error': 'Not found'}));
          await req.response.close();
          return;
        }
        req.response.statusCode = HttpStatus.noContent; // 204
        await req.response.close();
        return;
      }

      // Admin users endpoints: /admin/users OR /users (alias)
      if (pathSegments.isNotEmpty && (pathSegments[0] == 'admin' || pathSegments[0] == 'users')) {
        final usersIndex = pathSegments[0] == 'admin' ? 1 : 0;
        // /admin/users or /users or /admin/users/:id or /users/:id
        if (pathSegments.length > usersIndex && pathSegments[usersIndex] == 'users') {
          // POST /admin/users -> create user
          if (req.method == 'POST' && pathSegments.length == usersIndex + 1) {
            final body = await utf8.decoder.bind(req).join();
            final data = (body.isNotEmpty) ? json.decode(body) as Map<String, dynamic> : <String, dynamic>{};
            // Validate incoming user payload: role (if provided) must be one of allowed, active (if provided) must be boolean
            final allowedRoles = ['admin', 'educator', 'moderator', 'player'];
            if (data.containsKey('role') && data['role'] != null && !allowedRoles.contains(data['role'].toString())) {
              req.response.statusCode = HttpStatus.badRequest;
              req.response.headers.contentType = ContentType.json;
              req.response.write(json.encode({'error': 'Invalid role'}));
              await req.response.close();
              return;
            }
            if (data.containsKey('active') && data['active'] is! bool) {
              req.response.statusCode = HttpStatus.badRequest;
              req.response.headers.contentType = ContentType.json;
              req.response.write(json.encode({'error': 'Invalid field: active must be boolean'}));
              await req.response.close();
              return;
            }
            final id = DateTime.now().millisecondsSinceEpoch.toString();
            data['id'] = id;
            data['createdAt'] = DateTime.now().toIso8601String();
            // Accept legacy 'roles' array when creating
            if (data.containsKey('roles') && data['roles'] is List) {
              final lst = (data['roles'] as List).where((e) => e != null).map((e) => e.toString()).toList();
              data['role'] = lst.isNotEmpty ? lst.first : 'player';
              data.remove('roles');
            }
            data['active'] = data['active'] ?? true;
            // Normalize single role and default to 'player' when none valid
            final incomingRole = data['role']?.toString();
            final normalized = (incomingRole != null && allowedRoles.contains(incomingRole)) ? incomingRole : 'player';
            data['role'] = normalized;
            storageUsers[id] = normalizeUser(data);
            req.response.statusCode = HttpStatus.created;
            req.response.headers.contentType = ContentType.json;
            req.response.write(json.encode(storageUsers[id]));
            await req.response.close();
            return;
          }

          // GET /admin/users or /users -> list (supports query: q/search, role, page, limit, orderBy, order)
            if (req.method == 'GET' && pathSegments.length == usersIndex + 1) {
            final params = req.uri.queryParameters;
            // accept both 'q' and 'search' for compatibility with spec and UI
            final searchQ = (params['q'] ?? params['search'] ?? '').trim().toLowerCase();
            final roleQ = (params['role'] ?? '').trim();
            final pageParam = params['page'];
            final limitParam = params['limit'];
            // validate page/limit when provided
            if ((pageParam != null && int.tryParse(pageParam) == null) || (limitParam != null && int.tryParse(limitParam) == null)) {
              req.response.statusCode = HttpStatus.badRequest;
              req.response.headers.contentType = ContentType.json;
              req.response.write(json.encode({'error': 'Invalid query params: page and limit must be numbers'}));
              await req.response.close();
              return;
            }
            final page = int.tryParse(pageParam ?? '1') ?? 1;
            final limit = int.tryParse(limitParam ?? '20') ?? 20;
            final orderBy = (params['orderBy'] ?? '').trim();
            final orderDir = (params['order'] ?? '').trim().toLowerCase();
            if (orderDir.isNotEmpty && orderDir != 'asc' && orderDir != 'desc') {
              req.response.statusCode = HttpStatus.badRequest;
              req.response.headers.contentType = ContentType.json;
              req.response.write(json.encode({'error': "Invalid order: must be 'asc' or 'desc'"}));
              await req.response.close();
              return;
            }

            var list = storageUsers.values.toList();
            if (searchQ.isNotEmpty) {
              list = list.where((m) {
                final name = (m['name'] ?? '').toString().toLowerCase();
                final email = (m['email'] ?? '').toString().toLowerCase();
                return name.contains(searchQ) || email.contains(searchQ);
              }).toList();
            }
            if (roleQ.isNotEmpty) {
              list = list.where((m) => (m['role'] ?? '') == roleQ).toList();
            }
            // ordering
            if (orderBy.isNotEmpty) {
              final allowedOrder = ['createdAt', 'name', 'email', 'id'];
              if (allowedOrder.contains(orderBy)) {
                list.sort((a, b) {
                  final va = a[orderBy];
                  final vb = b[orderBy];
                  if (va == null && vb == null) return 0;
                  if (va == null) return -1;
                  if (vb == null) return 1;
                  if (orderBy == 'createdAt') {
                    final da = DateTime.tryParse(va.toString()) ?? DateTime.fromMillisecondsSinceEpoch(0);
                    final db = DateTime.tryParse(vb.toString()) ?? DateTime.fromMillisecondsSinceEpoch(0);
                    return da.compareTo(db);
                  }
                  return va.toString().toLowerCase().compareTo(vb.toString().toLowerCase());
                });
                if (orderDir == 'desc') list = list.reversed.toList();
              }
            }
            // simple pagination
            final start = (page - 1) * limit;
            final end = (start + limit) < list.length ? (start + limit) : list.length;
            final pageList = (start < list.length) ? list.sublist(start, end) : <Map<String, dynamic>>[];
            // normalize each user in the page
            final normalizedPage = pageList.map((e) => normalizeUser(e)).toList();

            // Return wrapped response to match API spec: { data: [...], pagination: { page, limit, totalCount, totalPages } }
            final totalCount = list.length;
            final totalPages = (totalCount / limit).ceil();
            final resp = {
              'data': normalizedPage,
              'pagination': {
                'page': page,
                'limit': limit,
                'totalCount': totalCount,
                'totalPages': totalPages
              }
            };
            req.response.statusCode = HttpStatus.ok;
            req.response.headers.contentType = ContentType.json;
            req.response.write(json.encode(resp));
            await req.response.close();
            return;
          }

          // routes with id /admin/users/:id  OR /users/:id
            if (pathSegments.length == usersIndex + 2) {
            final id = pathSegments[usersIndex + 1];
            // GET /admin/users/:id
            if (req.method == 'GET') {
              final existing = storageUsers[id];
              if (existing == null) {
                req.response.statusCode = HttpStatus.notFound;
                req.response.headers.contentType = ContentType.json;
                req.response.write(json.encode({'error': 'Not found'}));
                await req.response.close();
                return;
              }
              req.response.statusCode = HttpStatus.ok;
              req.response.headers.contentType = ContentType.json;
              req.response.write(json.encode(normalizeUser(existing)));
              await req.response.close();
              return;
            }

            // PATCH /admin/users/:id -> partial update (e.g., change status/blocked/active)
            if (req.method == 'PATCH') {
              // Authorization required for moderation actions
              final authHeader = req.headers.value('authorization');
              if (authHeader == null) {
                req.response.statusCode = HttpStatus.unauthorized;
                req.response.headers.contentType = ContentType.json;
                req.response.write(json.encode({'error': 'Unauthorized'}));
                await req.response.close();
                return;
              }
              // validate token
              final token = authHeader.replaceFirst(RegExp('^[Bb]earer\\s+'), '').trim();
              if (token != 'admin_token') {
                req.response.statusCode = HttpStatus.forbidden;
                req.response.headers.contentType = ContentType.json;
                req.response.write(json.encode({'error': 'Forbidden'}));
                await req.response.close();
                return;
              }
              final existing = storageUsers[id];
              if (existing == null) {
                req.response.statusCode = HttpStatus.notFound;
                req.response.headers.contentType = ContentType.json;
                req.response.write(json.encode({'error': 'Not found'}));
                await req.response.close();
                return;
              }
              final body = await utf8.decoder.bind(req).join();
              final data = (body.isNotEmpty) ? json.decode(body) as Map<String, dynamic> : <String, dynamic>{};
              // Validate incoming moderation shape and apply to canonical 'active' field only.
              // Accept shapes: {"active": bool} or {"blocked": bool} or {"status": "blocked"|"active"}
              if (data.containsKey('active') && data['active'] is! bool) {
                req.response.statusCode = HttpStatus.badRequest;
                req.response.headers.contentType = ContentType.json;
                req.response.write(json.encode({'error': 'Invalid field: active must be boolean'}));
                await req.response.close();
                return;
              }
              if (data.containsKey('blocked') && data['blocked'] is! bool) {
                req.response.statusCode = HttpStatus.badRequest;
                req.response.headers.contentType = ContentType.json;
                req.response.write(json.encode({'error': 'Invalid field: blocked must be boolean'}));
                await req.response.close();
                return;
              }
              if (data.containsKey('status') && data['status'] != null) {
                final s = data['status'].toString();
                if (s != 'blocked' && s != 'active') {
                  req.response.statusCode = HttpStatus.badRequest;
                  req.response.headers.contentType = ContentType.json;
                  req.response.write(json.encode({'error': 'Invalid status value'}));
                  await req.response.close();
                  return;
                }
                existing['active'] = s == 'active';
              }
              if (data.containsKey('blocked')) {
                final blocked = data['blocked'] == true;
                existing['active'] = !blocked;
              }
              if (data.containsKey('active')) {
                existing['active'] = data['active'];
              }
              // merge other provided fields shallowly (ignore any legacy 'status')
              data.forEach((k, v) {
                if (k != 'status' && k != 'blocked' && k != 'active') existing[k] = v;
              });
              // normalize and store; ensure 'status' is not persisted
              existing.remove('status');
              storageUsers[id] = normalizeUser(existing);
              req.response.statusCode = HttpStatus.ok;
              req.response.headers.contentType = ContentType.json;
              req.response.write(json.encode(storageUsers[id]));
              await req.response.close();
              return;
            }

            // PUT /admin/users/:id -> update (full replace)
            if (req.method == 'PUT') {
              final existing = storageUsers[id];
              if (existing == null) {
                req.response.statusCode = HttpStatus.notFound;
                req.response.headers.contentType = ContentType.json;
                req.response.write(json.encode({'error': 'Not found'}));
                await req.response.close();
                return;
              }
              final body = await utf8.decoder.bind(req).join();
              final data = (body.isNotEmpty) ? json.decode(body) as Map<String, dynamic> : <String, dynamic>{};
              // Validate incoming payload for PUT: role (if provided) must be allowed, active (if provided) must be boolean
              final allowed = ['admin', 'educator', 'moderator', 'player'];
              if (data.containsKey('role') && data['role'] != null && !allowed.contains(data['role'].toString())) {
                req.response.statusCode = HttpStatus.badRequest;
                req.response.headers.contentType = ContentType.json;
                req.response.write(json.encode({'error': 'Invalid role'}));
                await req.response.close();
                return;
              }
              if (data.containsKey('active') && data['active'] is! bool) {
                req.response.statusCode = HttpStatus.badRequest;
                req.response.headers.contentType = ContentType.json;
                req.response.write(json.encode({'error': 'Invalid field: active must be boolean'}));
                await req.response.close();
                return;
              }
              data['id'] = id;
              data['createdAt'] = existing['createdAt'] ?? DateTime.now().toIso8601String();
              // Accept legacy 'roles' array when updating
              if (data.containsKey('roles') && data['roles'] is List) {
                final lst = (data['roles'] as List).where((e) => e != null).map((e) => e.toString()).toList();
                data['role'] = lst.isNotEmpty ? lst.first : 'player';
                data.remove('roles');
              }
              // normalize role: if provided and valid, use it; if not provided, keep existing; if invalid, default to 'player'
              final allowedRoles2 = ['admin', 'educator', 'moderator', 'player'];
              if (data.containsKey('role')) {
                final r = data['role']?.toString();
                data['role'] = (r != null && allowedRoles2.contains(r)) ? r : 'player';
              } else {
                data['role'] = existing['role'] ?? 'player';
              }
              // ensure active flag
              data['active'] = data.containsKey('active') ? data['active'] : existing['active'] ?? true;
              storageUsers[id] = normalizeUser(data);
              req.response.statusCode = HttpStatus.ok;
              req.response.headers.contentType = ContentType.json;
              req.response.write(json.encode(storageUsers[id]));
              await req.response.close();
              return;
            }

            // DELETE /admin/users/:id
            if (req.method == 'DELETE') {
              // Authorization required for delete
              final authHeader = req.headers.value('authorization');
              if (authHeader == null) {
                req.response.statusCode = HttpStatus.unauthorized;
                req.response.headers.contentType = ContentType.json;
                req.response.write(json.encode({'error': 'Unauthorized'}));
                await req.response.close();
                return;
              }
              final token = authHeader.replaceFirst(RegExp('^[Bb]earer\\s+'), '').trim();
              if (token != 'admin_token') {
                req.response.statusCode = HttpStatus.forbidden;
                req.response.headers.contentType = ContentType.json;
                req.response.write(json.encode({'error': 'Forbidden'}));
                await req.response.close();
                return;
              }
              final existed = storageUsers.remove(id);
              if (existed == null) {
                req.response.statusCode = HttpStatus.notFound;
                req.response.headers.contentType = ContentType.json;
                req.response.write(json.encode({'error': 'Not found'}));
                await req.response.close();
                return;
              }
              req.response.statusCode = HttpStatus.noContent; // 204
              await req.response.close();
              return;
            }
          }
        }
        // if admin route not matched
        req.response.statusCode = HttpStatus.notFound;
        req.response.headers.contentType = ContentType.json;
        req.response.write(json.encode({'error': 'Unknown admin endpoint'}));
        await req.response.close();
        return;
      }

      // Unknown route
      req.response.statusCode = HttpStatus.notFound;
      req.response.headers.contentType = ContentType.json;
      req.response.write(json.encode({'error': 'Unknown endpoint'}));
      await req.response.close();
    } catch (e, st) {
      stderr.writeln('Error handling request: $e\n$st');
      try {
        req.response.statusCode = HttpStatus.internalServerError;
        req.response.headers.contentType = ContentType.json;
        req.response.write(json.encode({'error': e.toString()}));
        await req.response.close();
      } catch (_) {}
    }
  });
}
