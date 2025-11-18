import 'token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureTokenStorage implements TokenStorage {
  final FlutterSecureStorage _secure;

  SecureTokenStorage({FlutterSecureStorage? secure}) : _secure = secure ?? const FlutterSecureStorage();

  @override
  Future<String?> readToken(String key) => _secure.read(key: key);

  @override
  Future<void> saveToken(String key, String token) => _secure.write(key: key, value: token);

  @override
  Future<void> deleteToken(String key) => _secure.delete(key: key);
}
