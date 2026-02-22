part of 'landing_bloc.dart';

enum LandingStatus { initial, loading, loaded }

final class LandingState extends Equatable {
  const LandingState({
    required this.status,
    this.packages = const [],
    this.images = const [],
  });

  const LandingState.initial()
      : status = LandingStatus.initial,
        packages = const [],
        images = const [];

  const LandingState.loading()
      : status = LandingStatus.loading,
        packages = const [],
        images = const [];

  const LandingState.loaded({required List<Package> packages, required List<GalleryImage> images})
      : status = LandingStatus.loaded,
        packages = packages,
        images = images;

  final LandingStatus status;
  final List<Package> packages;
  final List<GalleryImage> images;

  @override
  List<Object?> get props => [status, packages, images];
}
