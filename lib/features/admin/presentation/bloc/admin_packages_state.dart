part of 'admin_packages_bloc.dart';

enum AdminPackagesStatus { initial, loading, loaded, failure }

class AdminPackagesState extends Equatable {
  const AdminPackagesState({
    required this.status,
    this.packages = const [],
    this.errorMessage,
  });

  const AdminPackagesState.initial()
      : status = AdminPackagesStatus.initial,
        packages = const [],
        errorMessage = null;

  const AdminPackagesState.loading()
      : status = AdminPackagesStatus.loading,
        packages = const [],
        errorMessage = null;

  const AdminPackagesState.loaded(List<Package> packages)
      : status = AdminPackagesStatus.loaded,
        packages = packages,
        errorMessage = null;

  const AdminPackagesState.failure(String message)
      : status = AdminPackagesStatus.failure,
        packages = const [],
        errorMessage = message;

  final AdminPackagesStatus status;
  final List<Package> packages;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, packages, errorMessage];
}
