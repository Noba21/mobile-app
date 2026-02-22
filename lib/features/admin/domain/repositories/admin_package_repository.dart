import '../../../landing/domain/entities/package.dart';

/// Contract for admin package CRUD operations.
abstract class AdminPackageRepository {
  /// Returns all packages. Throws on failure.
  Future<List<Package>> getPackages();

  /// Creates a new package. Returns the created [Package]. Throws on failure.
  Future<Package> createPackage({
    required String title,
    required String description,
    required double price,
    required String duration,
    List<String> includedServices = const [],
    List<String> sampleImageUrls = const [],
    String? category,
  });

  /// Updates an existing package. Returns the updated [Package]. Throws on failure.
  Future<Package> updatePackage({
    required String id,
    required String title,
    required String description,
    required double price,
    required String duration,
    List<String> includedServices = const [],
    List<String> sampleImageUrls = const [],
    String? category,
  });

  /// Deletes a package. Throws on failure.
  Future<void> deletePackage(String id);
}
