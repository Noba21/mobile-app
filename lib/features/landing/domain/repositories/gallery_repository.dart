import '../entities/gallery_image.dart';

/// Contract for fetching gallery data.
abstract class GalleryRepository {
  /// Returns featured gallery images for the landing page. Throws on failure.
  Future<List<GalleryImage>> getFeaturedImages();

  /// Returns gallery images, optionally filtered by category. Throws on failure.
  Future<List<GalleryImage>> getImages({String? category});
}
