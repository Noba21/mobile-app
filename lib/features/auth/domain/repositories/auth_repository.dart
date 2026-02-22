import '../entities/user.dart';

/// Contract for authentication operations.
abstract class AuthRepository {
  /// Returns [User] and persists tokens. Throws on failure.
  Future<User> login(String email, String password);

  /// Registers a client. Returns [User] and persists tokens. Throws on failure.
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  });

  /// Clears stored tokens. Does not throw.
  Future<void> logout();
}
