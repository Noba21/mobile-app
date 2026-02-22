import '../entities/admin_user.dart';

/// Contract for admin user management operations.
abstract class UserRepository {
  /// Returns all users, optionally filtered by role.
  /// [role] can be 'client' or 'photographer'; null = all.
  Future<List<AdminUser>> listUsers({String? role});

  /// Activates the given user account.
  Future<void> activateUser(String userId);

  /// Deactivates the given user account.
  Future<void> deactivateUser(String userId);

  /// Permanently deletes the given user.
  Future<void> deleteUser(String userId);
}
