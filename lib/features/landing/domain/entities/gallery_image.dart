import 'package:equatable/equatable.dart';

/// Domain entity for a gallery image.
class GalleryImage extends Equatable {
  const GalleryImage({
    required this.id,
    required this.url,
    this.category,
    this.caption,
  });

  final String id;
  final String url;
  final String? category;
  final String? caption;

  @override
  List<Object?> get props => [id, url, category, caption];
}
