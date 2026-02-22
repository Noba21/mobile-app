import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/user_repository.dart';

part 'admin_users_event.dart';
part 'admin_users_state.dart';

class AdminUsersBloc extends Bloc<AdminUsersEvent, AdminUsersState> {
  AdminUsersBloc(this._userRepository) : super(const AdminUsersState.initial()) {
    on<AdminUsersLoadRequested>(_onLoadRequested);
    on<AdminUsersRoleFilterChanged>(_onRoleFilterChanged);
    on<AdminUsersActivateRequested>(_onActivateRequested);
    on<AdminUsersDeactivateRequested>(_onDeactivateRequested);
    on<AdminUsersDeleteRequested>(_onDeleteRequested);
  }

  final UserRepository _userRepository;

  Future<void> _onLoadRequested(
    AdminUsersLoadRequested event,
    Emitter<AdminUsersState> emit,
  ) async {
    emit(const AdminUsersState.loading());
    try {
      final role = _roleParam(state.roleFilter);
      final users = await _userRepository.listUsers(role: role);
      emit(AdminUsersState.loaded(users: users, roleFilter: state.roleFilter));
    } catch (e) {
      emit(AdminUsersState.failure(e.toString()));
    }
  }

  Future<void> _onRoleFilterChanged(
    AdminUsersRoleFilterChanged event,
    Emitter<AdminUsersState> emit,
  ) async {
    if (state.status != AdminUsersStatus.loaded) return;
    emit(AdminUsersState.loaded(users: state.users, roleFilter: event.roleFilter));
  }

  Future<void> _onActivateRequested(
    AdminUsersActivateRequested event,
    Emitter<AdminUsersState> emit,
  ) async {
    if (state.status != AdminUsersStatus.loaded) return;
    try {
      await _userRepository.activateUser(event.userId);
      add(const AdminUsersLoadRequested());
    } catch (_) {
      add(const AdminUsersLoadRequested());
    }
  }

  Future<void> _onDeactivateRequested(
    AdminUsersDeactivateRequested event,
    Emitter<AdminUsersState> emit,
  ) async {
    if (state.status != AdminUsersStatus.loaded) return;
    try {
      await _userRepository.deactivateUser(event.userId);
      add(const AdminUsersLoadRequested());
    } catch (_) {
      add(const AdminUsersLoadRequested());
    }
  }

  Future<void> _onDeleteRequested(
    AdminUsersDeleteRequested event,
    Emitter<AdminUsersState> emit,
  ) async {
    if (state.status != AdminUsersStatus.loaded) return;
    try {
      await _userRepository.deleteUser(event.userId);
      add(const AdminUsersLoadRequested());
    } catch (_) {
      add(const AdminUsersLoadRequested());
    }
  }

  String? _roleParam(String? roleFilter) {
    if (roleFilter == null || roleFilter.isEmpty || roleFilter == 'all') return null;
    return roleFilter.toLowerCase();
  }
}
