import 'package:dio/dio.dart';

import '../constants/app_constants.dart';
import '../errors/app_exceptions.dart';
import '../services/auth_storage.dart';

/// Creates a configured [Dio] instance with JWT interceptor and error handling.
Dio createDioClient(AuthStorage authStorage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: Duration(seconds: int.parse(AppConstants.apiTimeoutSeconds)),
      receiveTimeout: Duration(seconds: int.parse(AppConstants.apiTimeoutSeconds)),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    _AuthInterceptor(authStorage),
    _ErrorInterceptor(),
  ]);

  return dio;
}

/// Attaches JWT to [Authorization] header when token is available.
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._authStorage);

  final AuthStorage _authStorage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _authStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Maps Dio errors to [AppException].
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appException = _mapToAppException(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: appException,
        type: err.type,
      ),
    );
  }

  AppException _mapToAppException(DioException err) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return const NetworkException('Request timed out.');
    }
    if (err.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }

    final statusCode = err.response?.statusCode;
    if (statusCode != null) {
      final body = err.response?.data;
      String? message;
      if (body is Map<String, dynamic> && body['message'] != null) {
        message = body['message'] is String ? body['message'] as String : body['message'].toString();
      }
      return ApiException(
        message ?? ApiException.fromStatusCode(statusCode).message,
        statusCode: statusCode,
      );
    }

    return ApiException(err.message ?? 'Request failed.');
  }
}
