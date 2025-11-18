/// Abstraction over token persistence. Implementations can persist securely or
/// keep tokens in memory for tests.
abstract class TokenStorage {
  /// Save a token under [key].
  Future<void> saveToken(String key, String token);

  /// Read a token saved under [key], or null if none.
  Future<String?> readToken(String key);

  /// Delete a token saved under [key].
  Future<void> deleteToken(String key);
}
