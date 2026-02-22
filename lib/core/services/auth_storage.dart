/// Contract for secure token storage. Implement with [flutter_secure_storage].
abstract class AuthStorage {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<String?> getRole();
  Future<void> setTokens({required String accessToken, String? refreshToken, String? role});
  Future<void> clear();
}
