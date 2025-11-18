import 'token_storage.dart';

class InMemoryTokenStorage implements TokenStorage {
  final Map<String, String> _store = {};

  @override
  Future<String?> readToken(String key) async => _store[key];

  @override
  Future<void> saveToken(String key, String token) async {
    _store[key] = token;
  }

  @override
  Future<void> deleteToken(String key) async {
    _store.remove(key);
  }
}
