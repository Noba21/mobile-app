import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../landing/domain/entities/package.dart';
import '../../domain/repositories/admin_package_repository.dart';
import '../bloc/admin_packages_bloc.dart';

class AdminPackagesPage extends StatelessWidget {
  const AdminPackagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminPackagesBloc(getIt<AdminPackageRepository>())
        ..add(const AdminPackagesLoadRequested()),
      child: const _AdminPackagesContent(),
    );
  }
}

class _AdminPackagesContent extends StatelessWidget {
  const _AdminPackagesContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminPackagesBloc, AdminPackagesState>(
      listener: (context, state) {
        if (state.status == AdminPackagesStatus.failure && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state.status == AdminPackagesStatus.loading && state.packages.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : state.packages.isEmpty
                  ? Center(
                      child: Text(
                        state.status == AdminPackagesStatus.failure
                            ? 'Could not load packages'
                            : 'No packages yet',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppTheme.spacingMd),
                      itemCount: state.packages.length,
                      itemBuilder: (context, index) {
                        final package = state.packages[index];
                        return _PackageCard(
                          package: package,
                          onEdit: () => context.push(
                            '${AppConstants.routeAdminPackages}/edit/${package.id}',
                            extra: package,
                          ),
                          onDelete: () => _confirmDelete(context, package),
                        );
                      },
                    ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push('${AppConstants.routeAdminPackages}/new'),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Package package) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete package?'),
        content: Text('Delete "${package.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AdminPackagesBloc>().add(
                    AdminPackagesDeleteRequested(package.id),
                  );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  const _PackageCard({
    required this.package,
    required this.onEdit,
    required this.onDelete,
  });

  final Package package;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: ListTile(
        title: Text(package.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 4),
            Text(
              package.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '\$${package.price.toStringAsFixed(0)} · ${package.duration}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
