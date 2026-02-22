import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/user_repository.dart';
import '../bloc/admin_users_bloc.dart';

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminUsersBloc(getIt<UserRepository>())..add(const AdminUsersLoadRequested()),
      child: const _AdminUsersContent(),
    );
  }
}

class _AdminUsersContent extends StatelessWidget {
  const _AdminUsersContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminUsersBloc, AdminUsersState>(
      listener: (context, state) {
        if (state.status == AdminUsersStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        final roleFilter = state.roleFilter;
        final filteredUsers = _filterByRole(state.users, roleFilter);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Row(
                children: [
                  Text(
                    'Filter by role:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(width: AppTheme.spacingMd),
                  SegmentedButton<String?>(
                    segments: const [
                      ButtonSegment(value: 'all', label: Text('All')),
                      ButtonSegment(value: 'client', label: Text('Client')),
                      ButtonSegment(value: 'photographer', label: Text('Photographer')),
                    ],
                    selected: {roleFilter ?? 'all'},
                    onSelectionChanged: (Set<String?> selected) {
                      final v = selected.first;
                      context.read<AdminUsersBloc>().add(
                            AdminUsersRoleFilterChanged(v == 'all' ? null : v),
                          );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.status == AdminUsersStatus.loading && state.users.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : filteredUsers.isEmpty
                      ? Center(
                          child: Text(
                            state.status == AdminUsersStatus.failure
                                ? 'Could not load users'
                                : 'No users found',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = filteredUsers[index];
                            return _UserListTile(
                              user: user,
                              onActivate: () => context.read<AdminUsersBloc>().add(
                                    AdminUsersActivateRequested(user.id),
                                  ),
                              onDeactivate: () => context.read<AdminUsersBloc>().add(
                                    AdminUsersDeactivateRequested(user.id),
                                  ),
                              onDelete: () => context.read<AdminUsersBloc>().add(
                                    AdminUsersDeleteRequested(user.id),
                                  ),
                            );
                          },
                        ),
            ),
          ],
        );
      },
    );
  }

  List<AdminUser> _filterByRole(List<AdminUser> users, String? roleFilter) {
    if (roleFilter == null || roleFilter.isEmpty || roleFilter == 'all') {
      return users;
    }
    final r = roleFilter.toLowerCase();
    return users.where((u) => u.role.toLowerCase() == r).toList();
  }
}

class _UserListTile extends StatelessWidget {
  const _UserListTile({
    required this.user,
    required this.onActivate,
    required this.onDeactivate,
    required this.onDelete,
  });

  final AdminUser user;
  final VoidCallback onActivate;
  final VoidCallback onDeactivate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final name = user.name ?? user.email.split('@').first;
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingSm),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(name.isNotEmpty ? name[0].toUpperCase() : '?'),
        ),
        title: Text(name),
        subtitle: Text('${user.email} · ${user.role}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user.isActive)
              IconButton(
                icon: const Icon(Icons.toggle_on, color: Colors.green),
                onPressed: onDeactivate,
                tooltip: 'Deactivate',
              )
            else
              IconButton(
                icon: const Icon(Icons.toggle_off),
                onPressed: onActivate,
                tooltip: 'Activate',
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete user?'),
                    content: Text('Are you sure you want to delete ${user.name ?? user.email}?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          onDelete();
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
