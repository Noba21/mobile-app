import 'package:dio/dio.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../../landing/domain/entities/package.dart';
import '../../../landing/data/models/package_model.dart';
import '../../domain/repositories/admin_package_repository.dart';

class AdminPackageRepositoryImpl implements AdminPackageRepository {
  AdminPackageRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<Package>> getPackages() async {
    try {
      final response = await _dio.get<dynamic>('/admin/packages');
      final data = response.data;
      if (data == null) return [];
      final items = data is List ? data : (data['data'] ?? data['packages'] ?? data);
      if (items is! List) return [];
      return _parsePackages(items);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<Package> createPackage({
    required String title,
    required String description,
    required double price,
    required String duration,
    List<String> includedServices = const [],
    List<String> sampleImageUrls = const [],
    String? category,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/admin/packages',
        data: _packageToJson(
          title: title,
          description: description,
          price: price,
          duration: duration,
          includedServices: includedServices,
          sampleImageUrls: sampleImageUrls,
          category: category,
        ),
      );
      return _parsePackage(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<Package> updatePackage({
    required String id,
    required String title,
    required String description,
    required double price,
    required String duration,
    List<String> includedServices = const [],
    List<String> sampleImageUrls = const [],
    String? category,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/admin/packages/$id',
        data: _packageToJson(
          title: title,
          description: description,
          price: price,
          duration: duration,
          includedServices: includedServices,
          sampleImageUrls: sampleImageUrls,
          category: category,
        ),
      );
      return _parsePackage(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> deletePackage(String id) async {
    try {
      await _dio.delete('/admin/packages/$id');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Map<String, dynamic> _packageToJson({
    required String title,
    required String description,
    required double price,
    required String duration,
    required List<String> includedServices,
    required List<String> sampleImageUrls,
    String? category,
  }) {
    return {
      'title': title,
      'description': description,
      'price': price,
      'duration': duration,
      'included_services': includedServices,
      'sample_images': sampleImageUrls,
      if (category != null) 'category': category,
    };
  }

  List<Package> _parsePackages(dynamic data) {
    if (data == null) return [];
    if (data is! List) return [];
    return data
        .where((e) => e is Map)
        .map((e) => PackageModel.fromJson(Map<String, dynamic>.from(e as Map)).toEntity())
        .toList();
  }

  Package _parsePackage(Map<String, dynamic>? data) {
    if (data == null) throw const ApiException('Invalid response.');
    return PackageModel.fromJson(data).toEntity();
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
    return ApiException(e.message ?? 'Package operation failed.');
  }
}
