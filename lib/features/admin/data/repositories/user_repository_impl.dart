import 'package:dio/dio.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/admin_user_model.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<AdminUser>> listUsers({String? role}) async {
    try {
      final queryParams = role != null ? {'role': role} : null;
      final response = await _dio.get<dynamic>(
        '/admin/users',
        queryParameters: queryParams,
      );
      final data = response.data;
      if (data == null) return [];
      final items = data is List ? data : (data['data'] ?? data['users'] ?? data);
      if (items is! List) return [];
      return items
          .where((e) => e is Map)
          .map((e) => AdminUserModel.fromJson(Map<String, dynamic>.from(e as Map)).toEntity())
          .toList();
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> activateUser(String userId) async {
    try {
      await _dio.patch('/admin/users/$userId/activate');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> deactivateUser(String userId) async {
    try {
      await _dio.patch('/admin/users/$userId/deactivate');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _dio.delete('/admin/users/$userId');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
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
    return ApiException(e.message ?? 'User operation failed.');
  }
}
