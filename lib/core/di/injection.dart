import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

/// Call once at app startup to register all dependencies.
Future<void> initApp() async {
  // Auth storage will be registered when implementing Phase 1 (secure storage).
  // For now, use stub so router can call getIt.isRegistered<AuthStorage>().
  if (!getIt.isRegistered<AuthStorage>()) {
    getIt.registerLazySingleton<AuthStorage>(() => _StubAuthStorage());
  }
}

/// Contract for secure token storage. Implement with [flutter_secure_storage].
abstract class AuthStorage {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<String?> getRole();
  Future<void> setTokens({required String accessToken, String? refreshToken, String? role});
  Future<void> clear();
}

/// Stub until real [AuthStorage] is implemented with [flutter_secure_storage].
class _StubAuthStorage implements AuthStorage {
  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<String?> getRefreshToken() async => null;

  @override
  Future<String?> getRole() async => null;

  @override
  Future<void> setTokens({
    required String accessToken,
    String? refreshToken,
    String? role,
  }) async {}

  @override
  Future<void> clear() async {}
}
