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
  // simple in-memory storage for themes
  final storageThemes = <String, Map<String, dynamic>>{};
  // simple in-memory storage for sent notifications (admin)
  final storageNotifications = <String, Map<String, dynamic>>{};

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
    // Ensure a single 'role' string exists and normalize legacy roles to canonical values
    if (!user.containsKey('role') || user['role'] == null) {
      user['role'] = 'student';
    }
    // ensure active is boolean
    if (!user.containsKey('active')) user['active'] = true;
    // derive compatible response fields: 'status' (string) and 'userType' (alias for role)
    final isActive = user['active'] == true;
    user['status'] = isActive ? 'active' : 'blocked';
    // normalize role values: map legacy roles into 'student'|'teacher'
    final rawRole = (user['role'] ?? 'student').toString().toLowerCase();
    final role = (rawRole == 'player' || rawRole == 'student') ? 'student' : 'teacher';
    user['role'] = role;
    // userType mirrors the canonical role
    user['userType'] = role;
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

      // POST /admin/_seed -> populate demo kahoots, users, authors
      if (req.method == 'POST' && pathSegments.length == 2 && pathSegments[0] == 'admin' && pathSegments[1] == '_seed') {
        // Clear existing
        storage.clear();
        storageUsers.clear();

        // create sample authors
        final authors = [
          {'authorId': 'auth1', 'name': 'Prof. Alice'},
          {'authorId': 'auth2', 'name': 'Dr. Bob'},
          {'authorId': 'auth3', 'name': 'Ms. Carol'},
        ];

        // create sample kahoots (12) with topics
        final topics = ['Matemáticas', 'Ciencias', 'Historia', 'Lengua', 'Programación'];
        for (var i = 1; i <= 12; i++) {
          final id = (DateTime.now().millisecondsSinceEpoch + i).toString();
          final author = authors[i % authors.length];
          final topic = topics[i % topics.length];
          // create sample questions with answers so the editor can load them
          final q1Id = '${id}_q1';
          final q2Id = '${id}_q2';
          final questions = [
            {
              'id': q1Id,
              'quizId': id,
              'questionText': 'Pregunta 1 de Kahoot $i',
              'questionType': 'quiz',
              'timeLimit': 20,
              'points': 1000,
              'answers': [
                {'id': '${q1Id}_a1', 'answerText': 'Respuesta A', 'isCorrect': true},
                {'id': '${q1Id}_a2', 'answerText': 'Respuesta B', 'isCorrect': false},
                {'id': '${q1Id}_a3', 'answerText': 'Respuesta C', 'isCorrect': false},
                {'id': '${q1Id}_a4', 'answerText': 'Respuesta D', 'isCorrect': false},
              ]
            },
            {
              'id': q2Id,
              'quizId': id,
              'questionText': 'Pregunta 2 de Kahoot $i',
              'questionType': 'quiz',
              'timeLimit': 15,
              'points': 800,
              'answers': [
                {'id': '${q2Id}_a1', 'answerText': 'Verdadero', 'isCorrect': true},
                {'id': '${q2Id}_a2', 'answerText': 'Falso', 'isCorrect': false},
              ]
            }
          ];

          final kah = {
            'id': id,
            'title': 'Kahoot $i',
            'description': 'Sample kahoot number $i',
            'topic': topic,
            'themeId': topic,
            'createdAt': DateTime.now().subtract(Duration(days: i)).toIso8601String(),
            // moderation flag
            'active': (i % 4) != 0,
            'author': {'authorId': author['authorId'], 'name': author['name']},
            'questions': questions,
          };
          storage[id] = kah;
        }

        // seed some themes
        final sampleThemes = ['Matemáticas', 'Ciencias', 'Historia', 'Lengua', 'Programación'];
        for (var i = 0; i < sampleThemes.length; i++) {
          final tid = 'theme_${i + 1}';
          final th = {'id': tid, 'name': sampleThemes[i], 'createdAt': DateTime.now().subtract(Duration(hours: i)).toIso8601String()};
          storageThemes[tid] = th;
        }

        // create sample users (8)
        final sampleUsers = [
          {'name': 'Ana Perez', 'email': 'ana.perez@example.com', 'role': 'teacher', 'active': true},
          {'name': 'Carlos Gomez', 'email': 'carlos.gomez@example.com', 'role': 'student', 'active': true},
          {'name': 'Lucia Martinez', 'email': 'lucia.martinez@example.com', 'role': 'student', 'active': false},
          {'name': 'Diego Rivera', 'email': 'diego.rivera@example.com', 'role': 'teacher', 'active': true},
          {'name': 'Mariana Lopez', 'email': 'mariana.lopez@example.com', 'role': 'student', 'active': true},
          {'name': 'Sergio Torres', 'email': 'sergio.torres@example.com', 'role': 'student', 'active': false},
          {'name': 'Elena Ruiz', 'email': 'elena.ruiz@example.com', 'role': 'teacher', 'active': true},
          {'name': 'Pablo Diaz', 'email': 'pablo.diaz@example.com', 'role': 'student', 'active': true},
        ];
        for (var i = 0; i < sampleUsers.length; i++) {
          final id = (DateTime.now().millisecondsSinceEpoch + 100 + i).toString();
          final u = Map<String, dynamic>.from(sampleUsers[i]);
          u['id'] = id;
          u['createdAt'] = DateTime.now().subtract(Duration(hours: i * 6)).toIso8601String();
          storageUsers[id] = normalizeUser(u);
        }

        // respond with summary
        final resp = {'kahoots': storage.length, 'users': storageUsers.length, 'authors': authors.length};
        req.response.statusCode = HttpStatus.created;
        req.response.headers.contentType = ContentType.json;
        req.response.write(json.encode(resp));
        await req.response.close();
        return;
      }

      // POST /kahoots -> create
      if (req.method == 'POST' && pathSegments.length == 1 && pathSegments[0] == 'kahoots') {
        final body = await utf8.decoder.bind(req).join();
        final data = (body.isNotEmpty) ? json.decode(body) as Map<String, dynamic> : <String, dynamic>{};
        final id = DateTime.now().millisecondsSinceEpoch.toString();
        data['id'] = id;
        data['createdAt'] = DateTime.now().toIso8601String();
        // default active flag for moderation
        if (!data.containsKey('active')) data['active'] = true;
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
        // preserve active flag unless explicitly provided
        data['active'] = data.containsKey('active') ? data['active'] : (existing['active'] ?? true);
        storage[id] = data;
        req.response.statusCode = HttpStatus.ok;
        req.response.headers.contentType = ContentType.json;
        req.response.write(json.encode(data));
        await req.response.close();
        return;
      }

      // Themes endpoints: /themes
      if (req.uri.pathSegments.isNotEmpty && req.uri.pathSegments[0] == 'themes') {
        final segs = req.uri.pathSegments.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
        // GET /themes -> list
        if (req.method == 'GET' && segs.length == 1) {
          final list = storageThemes.values.toList();
          req.response.statusCode = HttpStatus.ok;
          req.response.headers.contentType = ContentType.json;
          req.response.write(json.encode(list));
          await req.response.close();
          return;
        }

        // POST /themes -> create
        if (req.method == 'POST' && segs.length == 1) {
          final body = await utf8.decoder.bind(req).join();
          final data = (body.isNotEmpty) ? json.decode(body) as Map<String, dynamic> : <String, dynamic>{};
          if (!(data.containsKey('name') && (data['name'] is String) && (data['name'] as String).trim().isNotEmpty)) {
            req.response.statusCode = HttpStatus.badRequest;
            req.response.headers.contentType = ContentType.json;
            req.response.write(json.encode({'error': 'Invalid payload: name required'}));
            await req.response.close();
            return;
          }
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final entry = {'id': id, 'name': data['name'], 'createdAt': DateTime.now().toIso8601String()};
          storageThemes[id] = entry;
          req.response.statusCode = HttpStatus.created;
          req.response.headers.contentType = ContentType.json;
          req.response.write(json.encode(entry));
          await req.response.close();
          return;
        }

        // routes with id: /themes/:id
        if (segs.length == 2) {
          final id = segs[1];
          // GET /themes/:id
          if (req.method == 'GET') {
            final existing = storageThemes[id];
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

          // PATCH /themes/:id -> requires admin
          if (req.method == 'PATCH') {
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
            final existing = storageThemes[id];
            if (existing == null) {
              req.response.statusCode = HttpStatus.notFound;
              req.response.headers.contentType = ContentType.json;
              req.response.write(json.encode({'error': 'Not found'}));
              await req.response.close();
              return;
            }
            final body = await utf8.decoder.bind(req).join();
            final data = (body.isNotEmpty) ? json.decode(body) as Map<String, dynamic> : <String, dynamic>{};
            if (data.containsKey('name') && (data['name'] is String)) existing['name'] = data['name'];
            storageThemes[id] = existing;
            req.response.statusCode = HttpStatus.ok;
            req.response.headers.contentType = ContentType.json;
            req.response.write(json.encode(existing));
            await req.response.close();
            return;
          }

          // DELETE /themes/:id -> requires admin
          if (req.method == 'DELETE') {
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
            final existed = storageThemes.remove(id);
            if (existed == null) {
              req.response.statusCode = HttpStatus.notFound;
              req.response.headers.contentType = ContentType.json;
              req.response.write(json.encode({'error': 'Not found'}));
              await req.response.close();
              return;
            }
            req.response.statusCode = HttpStatus.noContent;
            await req.response.close();
            return;
          }
        }
      }

      // DELETE /kahoots/:id
      if (req.method == 'DELETE' && pathSegments.length == 2 && pathSegments[0] == 'kahoots') {
        final id = pathSegments[1];
        // Require admin auth for destructive actions
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

      // Admin notifications: /admin/notifications
      if (pathSegments.isNotEmpty && pathSegments[0] == 'admin' && pathSegments.length >= 2 && pathSegments[1] == 'notifications') {
        // POST /admin/notifications -> create/send
        if (req.method == 'POST' && pathSegments.length == 2) {
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
          final body = await utf8.decoder.bind(req).join();
          final data = (body.isNotEmpty) ? json.decode(body) as Map<String, dynamic> : <String, dynamic>{};
          // validate minimal payload
          if (!(data.containsKey('title') && data['title'] is String && (data['title'] as String).trim().isNotEmpty)) {
            req.response.statusCode = HttpStatus.badRequest;
            req.response.headers.contentType = ContentType.json;
            req.response.write(json.encode({'error': 'title is required'}));
            await req.response.close();
            return;
          }
          if (!(data.containsKey('message') && data['message'] is String && (data['message'] as String).trim().isNotEmpty)) {
            req.response.statusCode = HttpStatus.badRequest;
            req.response.headers.contentType = ContentType.json;
            req.response.write(json.encode({'error': 'message is required'}));
            await req.response.close();
            return;
          }
          final audience = (data['audience'] ?? 'all').toString();
          if (audience != 'all' && audience != 'user') {
            req.response.statusCode = HttpStatus.badRequest;
            req.response.headers.contentType = ContentType.json;
            req.response.write(json.encode({'error': 'audience must be "all" or "user"'}));
            await req.response.close();
            return;
          }
          if (audience == 'user' && !(data.containsKey('userId') && (data['userId'] as String).trim().isNotEmpty)) {
            req.response.statusCode = HttpStatus.badRequest;
            req.response.headers.contentType = ContentType.json;
            req.response.write(json.encode({'error': 'userId is required when audience is "user"'}));
            await req.response.close();
            return;
          }
          final id = DateTime.now().millisecondsSinceEpoch.toString();
          final entry = Map<String, dynamic>.from(data);
          entry['id'] = id;
          entry['createdAt'] = DateTime.now().toIso8601String();
          storageNotifications[id] = entry;
          req.response.statusCode = HttpStatus.created;
          req.response.headers.contentType = ContentType.json;
          req.response.write(json.encode(entry));
          await req.response.close();
          return;
        }

        // GET /admin/notifications -> list
        if (req.method == 'GET' && pathSegments.length == 2) {
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
          final list = storageNotifications.values.toList()
            ..sort((a, b) => (b['createdAt'] ?? '').toString().compareTo((a['createdAt'] ?? '').toString()));
          req.response.statusCode = HttpStatus.ok;
          req.response.headers.contentType = ContentType.json;
          req.response.write(json.encode(list));
          await req.response.close();
          return;
        }

        // GET /admin/notifications/:id
        if (req.method == 'GET' && pathSegments.length == 3) {
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
          final id = pathSegments[2];
          final existing = storageNotifications[id];
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
      }

      // PATCH /kahoots/:id -> partial update (moderation)
      if (req.method == 'PATCH' && pathSegments.length == 2 && pathSegments[0] == 'kahoots') {
        final id = pathSegments[1];
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
        // Accept shapes: {active:bool} or {blocked:bool} or {status:'active'|'blocked'}
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
        // merge other provided fields shallowly
        data.forEach((k, v) {
          if (k != 'status' && k != 'blocked' && k != 'active') existing[k] = v;
        });
        storage[id] = existing;
        // respond with normalized kahoot
        final resp = Map<String, dynamic>.from(existing);
        resp['status'] = (resp['active'] == true) ? 'active' : 'blocked';
        req.response.statusCode = HttpStatus.ok;
        req.response.headers.contentType = ContentType.json;
        req.response.write(json.encode(resp));
        await req.response.close();
        return;
      }

      // Admin users endpoints: /admin/users OR /users (alias)
      // Admin metrics endpoint: /admin/metrics OR /metrics
      if (pathSegments.isNotEmpty && (pathSegments[0] == 'admin' || pathSegments[0] == 'metrics')) {
        final metricsIndex = pathSegments[0] == 'admin' ? 1 : 0;
        if (pathSegments.length == metricsIndex + 1 && pathSegments[metricsIndex] == 'metrics' && req.method == 'GET') {
          // compute metrics from in-memory storages
          try {
            final kahootList = storage.values.toList();
            // parse createdAt when available, fallback to epoch
            kahootList.sort((a, b) {
              final da = DateTime.tryParse(a['createdAt']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
              final db = DateTime.tryParse(b['createdAt']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
              return db.compareTo(da);
            });
            final recentKahoots = kahootList.take(5).map((k) => {
                  'id': k['id'],
                  'title': k['title'] ?? k['name'] ?? 'Untitled',
                  'createdAt': k['createdAt']
                }).toList();

            final totalKahoots = storage.length;

            // users
            final usersList = storageUsers.values.map((u) => normalizeUser(Map<String, dynamic>.from(u))).toList();
            final totalUsers = usersList.length;
            final activeUsers = usersList.where((u) => (u['active'] ?? true) == true).length;
            final blockedUsers = totalUsers - activeUsers;
            final recentUsers = usersList.take(5).map((u) => {'id': u['id'], 'name': u['name'], 'createdAt': u['createdAt'], 'status': u['status'], 'role': u['role'] ?? u['userType'] ?? 'student'}).toList();

            // authors: unique authorId from kahoots if present
            final authorSet = <String, Map<String, dynamic>>{};
            for (final k in storage.values) {
              if (k.containsKey('author') && k['author'] is Map) {
                final a = k['author'] as Map<String, dynamic>;
                final aid = a['authorId']?.toString();
                if (aid != null) authorSet[aid] = {'authorId': aid, 'name': a['name'] ?? ''};
              }
            }
            final totalAuthors = authorSet.length;
            final recentAuthors = authorSet.values.take(5).toList();

            // compute topic counts for kahoots
            final topicCounts = <String, int>{};
            for (final k in kahootList) {
              final t = (k['topic'] ?? 'Sin tema').toString();
              topicCounts[t] = (topicCounts[t] ?? 0) + 1;
            }
            final topTopics = topicCounts.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            final topTopicsList = topTopics.take(5).map((e) => {'topic': e.key, 'count': e.value}).toList();

            // compute users breakdown by role
            final roleCounts = <String, int>{};
            for (final u in usersList) {
              final r = (u['role'] ?? 'student').toString();
              roleCounts[r] = (roleCounts[r] ?? 0) + 1;
            }
            final rolePercent = <String, double>{};
            roleCounts.forEach((k, v) { rolePercent[k] = totalUsers > 0 ? (v / totalUsers) * 100.0 : 0.0; });

            final resp = {
              'kahoots': {
                'total': totalKahoots,
                'recent': recentKahoots,
                'topics': {'counts': topicCounts, 'top': topTopicsList}
              },
              'users': {
                'total': totalUsers,
                'active': activeUsers,
                'blocked': blockedUsers,
                'recent': recentUsers,
                'byRole': {'counts': roleCounts, 'percent': rolePercent}
              },
              'authors': {'total': totalAuthors, 'recent': recentAuthors}
            };
            req.response.statusCode = HttpStatus.ok;
            req.response.headers.contentType = ContentType.json;
            req.response.write(json.encode(resp));
            await req.response.close();
            return;
          } catch (e) {
            req.response.statusCode = HttpStatus.internalServerError;
            req.response.headers.contentType = ContentType.json;
            req.response.write(json.encode({'error': e.toString()}));
            await req.response.close();
            return;
          }
        }
      }
      if (pathSegments.isNotEmpty && (pathSegments[0] == 'admin' || pathSegments[0] == 'users')) {
        final usersIndex = pathSegments[0] == 'admin' ? 1 : 0;
        // /admin/users or /users or /admin/users/:id or /users/:id
        if (pathSegments.length > usersIndex && pathSegments[usersIndex] == 'users') {
          // POST /admin/users -> create user
          if (req.method == 'POST' && pathSegments.length == usersIndex + 1) {
            final body = await utf8.decoder.bind(req).join();
            final data = (body.isNotEmpty) ? json.decode(body) as Map<String, dynamic> : <String, dynamic>{};
            // Validate incoming user payload: role (if provided) will be normalized to student|teacher; active (if provided) must be boolean
            if (data.containsKey('active') && data['active'] is! bool) {
              req.response.statusCode = HttpStatus.badRequest;
              req.response.headers.contentType = ContentType.json;
              req.response.write(json.encode({'error': 'Invalid field: active must be boolean'}));
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
              data['role'] = lst.isNotEmpty ? lst.first : 'student';
              data.remove('roles');
            }
            data['active'] = data['active'] ?? true;
            // Normalize incoming role (map legacy values into 'student'|'teacher')
            String mapRole(String? r) {
              final low = r?.toString().toLowerCase();
              if (low == null) return 'student';
              if (low == 'player' || low == 'student') return 'student';
              // treat educator/admin/moderator as teacher
              return 'teacher';
            }
            data['role'] = mapRole(data['role']?.toString());
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
            final statusQ = (params['status'] ?? '').trim();
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
              list = list.where((m) {
                final normalized = normalizeUser(Map<String, dynamic>.from(m));
                return (normalized['role'] ?? '') == roleQ;
              }).toList();
            }
            if (statusQ.isNotEmpty) {
              // status values expected: 'active' or 'blocked'
              list = list.where((m) {
                final normalized = normalizeUser(Map<String, dynamic>.from(m));
                return (normalized['status'] ?? '') == statusQ;
              }).toList();
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
              // role (if provided) will be normalized to student|teacher; active (if provided) must be boolean
              if (data.containsKey('active') && data['active'] is! bool) {
                req.response.statusCode = HttpStatus.badRequest;
                req.response.headers.contentType = ContentType.json;
                req.response.write(json.encode({'error': 'Invalid field: active must be boolean'}));
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
                data['role'] = lst.isNotEmpty ? lst.first : 'student';
                data.remove('roles');
              }
              // normalize role: map legacy values into canonical 'student'|'teacher'
              String mapRole(String? r) {
                final low = r?.toString().toLowerCase();
                if (low == null) return existing['role'] ?? 'student';
                if (low == 'player' || low == 'student') return 'student';
                return 'teacher';
              }
              if (data.containsKey('role')) {
                data['role'] = mapRole(data['role']?.toString());
              } else {
                data['role'] = existing['role'] ?? 'student';
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
