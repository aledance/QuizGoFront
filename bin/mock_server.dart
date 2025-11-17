import 'dart:convert';
import 'dart:io';

/// Simple in-memory mock server for /kahoots endpoints.
/// Run with: dart run bin/mock_server.dart

void main(List<String> args) async {
  final port = int.tryParse(Platform.environment['MOCK_SERVER_PORT'] ?? '') ?? 3000;
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  print('Mock server listening on http://localhost:$port');

  final storage = <String, Map<String, dynamic>>{};

  server.listen((HttpRequest req) async {
    try {
      // Add CORS headers for convenience
      req.response.headers.add('Access-Control-Allow-Origin', '*');
      req.response.headers.add('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
      req.response.headers.add('Access-Control-Allow-Headers', 'Content-Type');

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
