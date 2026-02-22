import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../services/auth_storage.dart';
import '../services/auth_storage_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

final GetIt getIt = GetIt.instance;

/// Call once at app startup to register all dependencies.
Future<void> initApp() async {
  getIt.registerLazySingleton<AuthStorage>(() => AuthStorageImpl());
  getIt.registerLazySingleton<Dio>(() => createDioClient(getIt<AuthStorage>()));
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dio: getIt<Dio>(), authStorage: getIt<AuthStorage>()),
  );
}

