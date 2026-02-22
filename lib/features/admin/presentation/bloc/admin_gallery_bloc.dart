import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../landing/domain/entities/gallery_image.dart';
import '../../domain/repositories/admin_gallery_repository.dart';

part 'admin_gallery_event.dart';
part 'admin_gallery_state.dart';

class AdminGalleryBloc extends Bloc<AdminGalleryEvent, AdminGalleryState> {
  AdminGalleryBloc(this._repository) : super(const AdminGalleryState.initial()) {
    on<AdminGalleryLoadRequested>(_onLoadRequested);
    on<AdminGalleryDeleteRequested>(_onDeleteRequested);
  }

  final AdminGalleryRepository _repository;

  Future<void> _onLoadRequested(
    AdminGalleryLoadRequested event,
    Emitter<AdminGalleryState> emit,
  ) async {
    emit(const AdminGalleryState.loading());
    try {
      final images = await _repository.getImages();
      emit(AdminGalleryState.loaded(images));
    } catch (e) {
      emit(AdminGalleryState.failure(e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    AdminGalleryDeleteRequested event,
    Emitter<AdminGalleryState> emit,
  ) async {
    if (state.status != AdminGalleryStatus.loaded) return;
    try {
      await _repository.deleteImage(event.imageId);
      add(const AdminGalleryLoadRequested());
    } catch (_) {
      add(const AdminGalleryLoadRequested());
    }
  }
}
