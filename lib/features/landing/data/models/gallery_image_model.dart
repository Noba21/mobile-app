import '../../domain/entities/gallery_image.dart';

/// DTO for gallery image API response.
class GalleryImageModel {
  const GalleryImageModel({
    required this.id,
    required this.url,
    this.category,
    this.caption,
  });

  final String id;
  final String url;
  final String? category;
  final String? caption;

  factory GalleryImageModel.fromJson(Map<String, dynamic> json) {
    return GalleryImageModel(
      id: json['id']?.toString() ?? '',
      url: json['url'] as String? ?? json['image_url'] as String? ?? '',
      category: json['category'] as String?,
      caption: json['caption'] as String? ?? json['description'] as String?,
    );
  }

  GalleryImage toEntity() => GalleryImage(
        id: id,
        url: url,
        category: category,
        caption: caption,
      );
}
