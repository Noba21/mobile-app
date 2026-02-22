part of 'admin_users_bloc.dart';

abstract sealed class AdminUsersEvent extends Equatable {
  const AdminUsersEvent();

  @override
  List<Object?> get props => [];
}

final class AdminUsersLoadRequested extends AdminUsersEvent {
  const AdminUsersLoadRequested();
}

final class AdminUsersRoleFilterChanged extends AdminUsersEvent {
  const AdminUsersRoleFilterChanged(this.roleFilter);
  final String? roleFilter;

  @override
  List<Object?> get props => [roleFilter];
}

final class AdminUsersActivateRequested extends AdminUsersEvent {
  const AdminUsersActivateRequested(this.userId);
  final String userId;

  @override
  List<Object?> get props => [userId];
}

final class AdminUsersDeactivateRequested extends AdminUsersEvent {
  const AdminUsersDeactivateRequested(this.userId);
  final String userId;

  @override
  List<Object?> get props => [userId];
}

final class AdminUsersDeleteRequested extends AdminUsersEvent {
  const AdminUsersDeleteRequested(this.userId);
  final String userId;

  @override
  List<Object?> get props => [userId];
}
