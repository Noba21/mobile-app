part of 'admin_gallery_bloc.dart';

abstract sealed class AdminGalleryEvent extends Equatable {
  const AdminGalleryEvent();

  @override
  List<Object?> get props => [];
}

final class AdminGalleryLoadRequested extends AdminGalleryEvent {
  const AdminGalleryLoadRequested();
}

final class AdminGalleryDeleteRequested extends AdminGalleryEvent {
  const AdminGalleryDeleteRequested(this.imageId);
  final String imageId;

  @override
  List<Object?> get props => [imageId];
}
