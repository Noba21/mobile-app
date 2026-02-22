import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../services/auth_storage.dart';
import '../services/auth_storage_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/landing/data/repositories/gallery_repository_impl.dart';
import '../../features/landing/data/repositories/package_repository_impl.dart';
import '../../features/admin/data/repositories/admin_gallery_repository_impl.dart';
import '../../features/admin/data/repositories/admin_package_repository_impl.dart';
import '../../features/admin/data/repositories/user_repository_impl.dart';
import '../../features/admin/domain/repositories/admin_gallery_repository.dart';
import '../../features/admin/domain/repositories/admin_package_repository.dart';
import '../../features/admin/domain/repositories/user_repository.dart';
import '../../features/landing/domain/repositories/gallery_repository.dart';
import '../../features/landing/domain/repositories/package_repository.dart';

final GetIt getIt = GetIt.instance;

/// Call once at app startup to register all dependencies.
Future<void> initApp() async {
  getIt.registerLazySingleton<AuthStorage>(() => AuthStorageImpl());
  getIt.registerLazySingleton<Dio>(() => createDioClient(getIt<AuthStorage>()));
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dio: getIt<Dio>(), authStorage: getIt<AuthStorage>()),
  );
  getIt.registerLazySingleton<PackageRepository>(() => PackageRepositoryImpl(dio: getIt<Dio>()));
  getIt.registerLazySingleton<GalleryRepository>(() => GalleryRepositoryImpl(dio: getIt<Dio>()));
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(dio: getIt<Dio>()));
  getIt.registerLazySingleton<AdminPackageRepository>(
    () => AdminPackageRepositoryImpl(dio: getIt<Dio>()),
  );
  getIt.registerLazySingleton<AdminGalleryRepository>(
    () => AdminGalleryRepositoryImpl(dio: getIt<Dio>()),
  );
}

