import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../services/auth_storage.dart';
import '../services/auth_storage_impl.dart';

final GetIt getIt = GetIt.instance;

/// Call once at app startup to register all dependencies.
Future<void> initApp() async {
  getIt.registerLazySingleton<AuthStorage>(() => AuthStorageImpl());
  getIt.registerLazySingleton<Dio>(() => createDioClient(getIt<AuthStorage>()));
}

