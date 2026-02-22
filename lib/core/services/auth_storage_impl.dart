import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/app_constants.dart';
import '../errors/app_exceptions.dart';
import 'auth_storage.dart';

/// [AuthStorage] implementation using [FlutterSecureStorage].
class AuthStorageImpl implements AuthStorage {
  AuthStorageImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: AppConstants.keyAccessToken);
    } catch (_) {
      throw const StorageException('Failed to read access token.');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: AppConstants.keyRefreshToken);
    } catch (_) {
      throw const StorageException('Failed to read refresh token.');
    }
  }

  @override
  Future<String?> getRole() async {
    try {
      final stored = await _storage.read(key: AppConstants.keyUserRole);
      if (stored != null && stored.isNotEmpty) return stored;
      final token = await getAccessToken();
      if (token != null) return _parseRoleFromJwt(token);
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> setTokens({
    required String accessToken,
    String? refreshToken,
    String? role,
  }) async {
    try {
      await _storage.write(key: AppConstants.keyAccessToken, value: accessToken);
      if (refreshToken != null) {
        await _storage.write(key: AppConstants.keyRefreshToken, value: refreshToken);
      }
      final roleToStore = role ?? _parseRoleFromJwt(accessToken);
      if (roleToStore != null) {
        await _storage.write(key: AppConstants.keyUserRole, value: roleToStore);
      }
    } catch (_) {
      throw const StorageException('Failed to store tokens.');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _storage.deleteAll();
    } catch (_) {
      throw const StorageException('Failed to clear storage.');
    }
  }

  /// Parses role from JWT payload. Supports 'role', 'user_role', or 'user.role'.
  String? _parseRoleFromJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;
      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final map = jsonDecode(decoded) as Map<String, dynamic>?;
      if (map == null) return null;
      if (map['role'] != null) return map['role'] as String?;
      if (map['user_role'] != null) return map['user_role'] as String?;
      final user = map['user'] as Map<String, dynamic>?;
      if (user != null && user['role'] != null) return user['role'] as String?;
      return null;
    } catch (_) {
      return null;
    }
  }
}
