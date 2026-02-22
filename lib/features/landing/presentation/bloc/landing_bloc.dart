import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/gallery_image.dart';
import '../../domain/entities/package.dart';
import '../../domain/repositories/gallery_repository.dart';
import '../../domain/repositories/package_repository.dart';

part 'landing_event.dart';
part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  LandingBloc({
    required PackageRepository packageRepository,
    required GalleryRepository galleryRepository,
  })  : _packageRepository = packageRepository,
        _galleryRepository = galleryRepository,
        super(const LandingState.initial()) {
    on<LandingLoadRequested>(_onLoadRequested);
  }

  final PackageRepository _packageRepository;
  final GalleryRepository _galleryRepository;

  Future<void> _onLoadRequested(LandingLoadRequested event, Emitter<LandingState> emit) async {
    emit(const LandingState.loading());
    try {
      final results = await Future.wait([
        _packageRepository.getFeaturedPackages(),
        _galleryRepository.getFeaturedImages(),
      ]);
      emit(LandingState.loaded(
        packages: results[0] as List<Package>,
        images: results[1] as List<GalleryImage>,
      ));
    } catch (_) {
      emit(const LandingState.loaded(packages: [], images: []));
    }
  }
}
