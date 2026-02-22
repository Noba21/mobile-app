import 'package:dio/dio.dart';

import '../../../../core/errors/app_exceptions.dart';
import '../../../landing/domain/entities/gallery_image.dart';
import '../../../landing/data/models/gallery_image_model.dart';
import '../../domain/repositories/admin_gallery_repository.dart';

class AdminGalleryRepositoryImpl implements AdminGalleryRepository {
  AdminGalleryRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<GalleryImage>> getImages() async {
    try {
      final response = await _dio.get<dynamic>('/admin/gallery');
      final data = response.data;
      if (data == null) return [];
      final items = data is List ? data : (data['data'] ?? data['images'] ?? data);
      if (items is! List) return [];
      return _parseImages(items);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<GalleryImage> addImage({
    required String url,
    String? category,
    String? caption,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/admin/gallery',
        data: _toJson(url: url, category: category, caption: caption),
      );
      return _parseImage(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<GalleryImage> updateImage({
    required String id,
    required String url,
    String? category,
    String? caption,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '/admin/gallery/$id',
        data: _toJson(url: url, category: category, caption: caption),
      );
      return _parseImage(response.data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  @override
  Future<void> deleteImage(String id) async {
    try {
      await _dio.delete('/admin/gallery/$id');
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Map<String, dynamic> _toJson({
    required String url,
    String? category,
    String? caption,
  }) {
    return {
      'url': url,
      if (category != null) 'category': category,
      if (caption != null) 'caption': caption,
    };
  }

  List<GalleryImage> _parseImages(dynamic data) {
    if (data == null) return [];
    if (data is! List) return [];
    return data
        .where((e) => e is Map)
        .map((e) => GalleryImageModel.fromJson(Map<String, dynamic>.from(e as Map)).toEntity())
        .toList();
  }

  GalleryImage _parseImage(Map<String, dynamic>? data) {
    if (data == null) throw const ApiException('Invalid response.');
    return GalleryImageModel.fromJson(data).toEntity();
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
    return ApiException(e.message ?? 'Gallery operation failed.');
  }
}
