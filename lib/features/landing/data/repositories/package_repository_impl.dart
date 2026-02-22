import 'package:dio/dio.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../domain/entities/package.dart';
import '../../domain/repositories/package_repository.dart';
import '../models/package_model.dart';

class PackageRepositoryImpl implements PackageRepository {
  PackageRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<Package>> getFeaturedPackages() async {
    try {
      final response = await _dio.get<List<dynamic>>('/packages/featured');
      return _parsePackages(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<List<Package>> getAllPackages() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/packages');
      final data = response.data;
      if (data == null) return [];
      final items = data['data'] ?? data['packages'] ?? data;
      if (items is List) return _parsePackages(items);
      return [];
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  List<Package> _parsePackages(dynamic data) {
    if (data == null) return [];
    if (data is! List) return [];
    final list = data;
    return list
        .where((e) => e is Map)
        .map((e) => PackageModel.fromJson(Map<String, dynamic>.from(e as Map)).toEntity())
        .toList();
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
    return ApiException(e.message ?? 'Failed to load packages.');
  }
}
