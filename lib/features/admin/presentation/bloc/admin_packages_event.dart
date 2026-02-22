part of 'admin_packages_bloc.dart';

abstract sealed class AdminPackagesEvent extends Equatable {
  const AdminPackagesEvent();

  @override
  List<Object?> get props => [];
}

final class AdminPackagesLoadRequested extends AdminPackagesEvent {
  const AdminPackagesLoadRequested();
}

final class AdminPackagesDeleteRequested extends AdminPackagesEvent {
  const AdminPackagesDeleteRequested(this.packageId);
  final String packageId;

  @override
  List<Object?> get props => [packageId];
}
