import '../entities/package.dart';

/// Contract for fetching package data.
abstract class PackageRepository {
  /// Returns featured packages for the landing page. Throws on failure.
  Future<List<Package>> getFeaturedPackages();

  /// Returns all available packages. Throws on failure.
  Future<List<Package>> getAllPackages();
}
