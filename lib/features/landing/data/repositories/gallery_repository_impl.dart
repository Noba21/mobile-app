import 'package:dio/dio.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../domain/entities/gallery_image.dart';
import '../../domain/repositories/gallery_repository.dart';
import '../models/gallery_image_model.dart';

class GalleryRepositoryImpl implements GalleryRepository {
  GalleryRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<GalleryImage>> getFeaturedImages() async {
    try {
      final response = await _dio.get<List<dynamic>>('/gallery/featured');
      return _parseImages(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<List<GalleryImage>> getImages({String? category}) async {
    try {
      final queryParams = category != null ? {'category': category} : null;
      final response = await _dio.get<dynamic>('/gallery', queryParameters: queryParams);
      final data = response.data;
      if (data == null) return [];
      final items = data is List ? data : (data['data'] ?? data['images'] ?? data);
      if (items is List) return _parseImages(items);
      return [];
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  List<GalleryImage> _parseImages(dynamic data) {
    if (data == null) return [];
    if (data is! List) return [];
    final list = data;
    return list
        .where((e) => e is Map)
        .map((e) => GalleryImageModel.fromJson(Map<String, dynamic>.from(e as Map)).toEntity())
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
    return ApiException(e.message ?? 'Failed to load gallery.');
  }
}
