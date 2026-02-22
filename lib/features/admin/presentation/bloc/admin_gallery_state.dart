part of 'admin_gallery_bloc.dart';

enum AdminGalleryStatus { initial, loading, loaded, failure }

class AdminGalleryState extends Equatable {
  const AdminGalleryState({
    required this.status,
    this.images = const [],
    this.errorMessage,
  });

  const AdminGalleryState.initial()
      : status = AdminGalleryStatus.initial,
        images = const [],
        errorMessage = null;

  const AdminGalleryState.loading()
      : status = AdminGalleryStatus.loading,
        images = const [],
        errorMessage = null;

  const AdminGalleryState.loaded(List<GalleryImage> images)
      : status = AdminGalleryStatus.loaded,
        images = images,
        errorMessage = null;

  const AdminGalleryState.failure(String message)
      : status = AdminGalleryStatus.failure,
        images = const [],
        errorMessage = message;

  final AdminGalleryStatus status;
  final List<GalleryImage> images;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, images, errorMessage];
}
