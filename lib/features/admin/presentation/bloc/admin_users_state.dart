part of 'admin_users_bloc.dart';

enum AdminUsersStatus { initial, loading, loaded, failure }

class AdminUsersState extends Equatable {
  const AdminUsersState({
    required this.status,
    this.users = const [],
    this.roleFilter,
    this.errorMessage,
  });

  const AdminUsersState.initial()
      : status = AdminUsersStatus.initial,
        users = const [],
        roleFilter = null,
        errorMessage = null;

  const AdminUsersState.loading()
      : status = AdminUsersStatus.loading,
        users = const [],
        roleFilter = null,
        errorMessage = null;

  const AdminUsersState.loaded({
    required List<AdminUser> users,
    String? roleFilter,
  })  : status = AdminUsersStatus.loaded,
        users = users,
        roleFilter = roleFilter,
        errorMessage = null;

  const AdminUsersState.failure(String message)
      : status = AdminUsersStatus.failure,
        users = const [],
        roleFilter = null,
        errorMessage = message;

  final AdminUsersStatus status;
  final List<AdminUser> users;
  final String? roleFilter;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, users, roleFilter, errorMessage];
}
