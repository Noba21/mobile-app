import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../landing/domain/entities/package.dart';
import '../../domain/repositories/admin_package_repository.dart';

part 'admin_packages_event.dart';
part 'admin_packages_state.dart';

class AdminPackagesBloc extends Bloc<AdminPackagesEvent, AdminPackagesState> {
  AdminPackagesBloc(this._repository) : super(const AdminPackagesState.initial()) {
    on<AdminPackagesLoadRequested>(_onLoadRequested);
    on<AdminPackagesDeleteRequested>(_onDeleteRequested);
  }

  final AdminPackageRepository _repository;

  Future<void> _onLoadRequested(
    AdminPackagesLoadRequested event,
    Emitter<AdminPackagesState> emit,
  ) async {
    emit(const AdminPackagesState.loading());
    try {
      final packages = await _repository.getPackages();
      emit(AdminPackagesState.loaded(packages));
    } catch (e) {
      emit(AdminPackagesState.failure(e.toString()));
    }
  }

  Future<void> _onDeleteRequested(
    AdminPackagesDeleteRequested event,
    Emitter<AdminPackagesState> emit,
  ) async {
    if (state.status != AdminPackagesStatus.loaded) return;
    try {
      await _repository.deletePackage(event.packageId);
      add(const AdminPackagesLoadRequested());
    } catch (_) {
      add(const AdminPackagesLoadRequested());
    }
  }
}
