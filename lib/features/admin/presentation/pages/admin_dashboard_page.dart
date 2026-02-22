import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
              context.go(AppConstants.routeLanding);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.admin_panel_settings, size: 48, color: Colors.white),
                  const SizedBox(height: AppTheme.spacingSm),
                  Text(
                    'Admin Panel',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            _NavItem(
              icon: Icons.people,
              label: 'Users',
              path: AppConstants.routeAdminUsers,
              onTap: () {
                Navigator.pop(context);
                context.go(AppConstants.routeAdminUsers);
              },
            ),
            _NavItem(
              icon: Icons.inventory_2,
              label: 'Packages',
              path: AppConstants.routeAdminPackages,
              onTap: () {
                Navigator.pop(context);
                context.go(AppConstants.routeAdminPackages);
              },
            ),
            _NavItem(
              icon: Icons.photo_library,
              label: 'Gallery',
              path: AppConstants.routeAdminGallery,
              onTap: () {
                Navigator.pop(context);
                context.go(AppConstants.routeAdminGallery);
              },
            ),
            _NavItem(
              icon: Icons.person,
              label: 'Profile',
              path: AppConstants.routeAdminProfile,
              onTap: () {
                Navigator.pop(context);
                context.go(AppConstants.routeAdminProfile);
              },
            ),
            _NavItem(
              icon: Icons.assignment_ind,
              label: 'Assignments',
              path: AppConstants.routeAdminAssignments,
              onTap: () {
                Navigator.pop(context);
                context.go(AppConstants.routeAdminAssignments);
              },
            ),
            _NavItem(
              icon: Icons.notifications,
              label: 'Notifications',
              path: AppConstants.routeAdminNotifications,
              onTap: () {
                Navigator.pop(context);
                context.go(AppConstants.routeAdminNotifications);
              },
            ),
            _NavItem(
              icon: Icons.analytics,
              label: 'Analysis',
              path: AppConstants.routeAdminAnalysis,
              onTap: () {
                Navigator.pop(context);
                context.go(AppConstants.routeAdminAnalysis);
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String path;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = GoRouterState.of(context).uri.path == path;
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: isSelected,
      onTap: onTap,
    );
  }
}
