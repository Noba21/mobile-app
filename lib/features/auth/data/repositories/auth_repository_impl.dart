import 'package:dio/dio.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/services/auth_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required Dio dio,
    required AuthStorage authStorage,
  })  : _dio = dio,
        _authStorage = authStorage;

  final Dio _dio;
  final AuthStorage _authStorage;

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return _handleAuthResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'full_name': fullName,
          'email': email,
          'password': password,
          'phone': phone,
        },
      );
      return _handleAuthResponse(response);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _authStorage.clear();
    } catch (_) {
      // Best-effort clear; do not rethrow
    }
  }

  Future<User> _handleAuthResponse(Response<Map<String, dynamic>> response) async {
    final data = response.data;
    if (data == null) {
      throw const AuthException('Invalid response from server.');
    }
    final authResponse = AuthResponse.fromJson(data);
    await _authStorage.setTokens(
      accessToken: authResponse.accessToken,
      refreshToken: authResponse.refreshToken,
      role: authResponse.user.role,
    );
    return authResponse.user;
  }

  AppException _mapDioException(DioException e) {
    final error = e.error;
    if (error is AppException) return error;
    final statusCode = e.response?.statusCode;
    if (statusCode != null) {
      final body = e.response?.data;
      String? message;
      if (body is Map<String, dynamic> && body['message'] != null) {
        message = body['message'] is String ? body['message'] as String : body['message'].toString();
      }
      return ApiException(
        message ?? ApiException.fromStatusCode(statusCode).message,
        statusCode: statusCode,
      );
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }
    return AuthException(e.message ?? 'Login failed.');
  }
}
