import '../../../landing/domain/entities/gallery_image.dart';

/// Contract for admin gallery CRUD operations.
abstract class AdminGalleryRepository {
  /// Returns all gallery images. Throws on failure.
  Future<List<GalleryImage>> getImages();

  /// Adds a new gallery image. Returns the created [GalleryImage]. Throws on failure.
  Future<GalleryImage> addImage({
    required String url,
    String? category,
    String? caption,
  });

  /// Updates an existing gallery image. Returns the updated [GalleryImage]. Throws on failure.
  Future<GalleryImage> updateImage({
    required String id,
    required String url,
    String? category,
    String? caption,
  });

  /// Deletes a gallery image. Throws on failure.
  Future<void> deleteImage(String id);
}
