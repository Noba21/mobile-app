import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../di/injection.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';

/// Role-based route names for redirect logic.
enum AppRole { admin, client, photographer }

/// Builds [GoRouter] with public and role-based routes and redirect guard.
GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppConstants.routeLanding,
    redirect: (BuildContext context, GoRouterState state) async {
      final authStorage = getIt.isRegistered<AuthStorage>() ? getIt<AuthStorage>() : null;
      final token = authStorage != null ? await authStorage.getAccessToken() : null;
      final roleStr = authStorage != null ? await authStorage.getRole() : null;
      final location = state.uri.path;

      final isPublic = _isPublicRoute(location);
      if (isPublic) {
        if (token != null && roleStr != null) {
          return _dashboardForRole(roleStr);
        }
        return null;
      }

      if (token == null || token.isEmpty) {
        return AppConstants.routeLogin;
      }

      final role = _parseRole(roleStr);
      if (role == null) return AppConstants.routeLogin;

      if (_isAdminRoute(location) && role != AppRole.admin) return _dashboardForRole(roleStr!);
      if (_isClientRoute(location) && role != AppRole.client) return _dashboardForRole(roleStr!);
      if (_isPhotographerRoute(location) && role != AppRole.photographer) {
        return _dashboardForRole(roleStr!);
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppConstants.routeLanding,
        name: 'landing',
        builder: (_, __) => const _PlaceholderPage(label: 'Landing'),
      ),
      GoRoute(
        path: AppConstants.routeLogin,
        name: 'login',
        builder: (_, __) => BlocProvider(
          create: (_) => AuthBloc(getIt<AuthRepository>()),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: AppConstants.routeRegister,
        name: 'register',
        builder: (_, __) => const _PlaceholderPage(label: 'Register'),
      ),
      GoRoute(
        path: AppConstants.routeAdminDashboard,
        name: 'admin',
        builder: (_, __) => const _PlaceholderPage(label: 'Admin Dashboard'),
        routes: [
          GoRoute(path: 'users', builder: (_, __) => const _PlaceholderPage(label: 'Admin Users')),
          GoRoute(path: 'packages', builder: (_, __) => const _PlaceholderPage(label: 'Admin Packages')),
          GoRoute(path: 'gallery', builder: (_, __) => const _PlaceholderPage(label: 'Admin Gallery')),
          GoRoute(path: 'profile', builder: (_, __) => const _PlaceholderPage(label: 'Admin Profile')),
          GoRoute(path: 'assignments', builder: (_, __) => const _PlaceholderPage(label: 'Admin Assignments')),
          GoRoute(path: 'notifications', builder: (_, __) => const _PlaceholderPage(label: 'Admin Notifications')),
          GoRoute(path: 'analysis', builder: (_, __) => const _PlaceholderPage(label: 'Admin Analysis')),
        ],
      ),
      GoRoute(
        path: AppConstants.routeClientDashboard,
        name: 'client',
        builder: (_, __) => const _PlaceholderPage(label: 'Client Dashboard'),
        routes: [
          GoRoute(path: 'packages', builder: (_, __) => const _PlaceholderPage(label: 'Client Packages')),
          GoRoute(path: 'bookings', builder: (_, __) => const _PlaceholderPage(label: 'Client Bookings')),
          GoRoute(path: 'profile', builder: (_, __) => const _PlaceholderPage(label: 'Client Profile')),
          GoRoute(path: 'notifications', builder: (_, __) => const _PlaceholderPage(label: 'Client Notifications')),
        ],
      ),
      GoRoute(
        path: AppConstants.routePhotographerDashboard,
        name: 'photographer',
        builder: (_, __) => const _PlaceholderPage(label: 'Photographer Dashboard'),
        routes: [
          GoRoute(path: 'assignments', builder: (_, __) => const _PlaceholderPage(label: 'Photographer Assignments')),
          GoRoute(path: 'profile', builder: (_, __) => const _PlaceholderPage(label: 'Photographer Profile')),
          GoRoute(path: 'task-status', builder: (_, __) => const _PlaceholderPage(label: 'Task Status')),
        ],
      ),
    ],
  );
}

bool _isPublicRoute(String path) {
  return path == AppConstants.routeLanding ||
      path == AppConstants.routeLogin ||
      path == AppConstants.routeRegister;
}

bool _isAdminRoute(String path) => path.startsWith(AppConstants.routeAdminDashboard);

bool _isClientRoute(String path) => path.startsWith(AppConstants.routeClientDashboard);

bool _isPhotographerRoute(String path) => path.startsWith(AppConstants.routePhotographerDashboard);

AppRole? _parseRole(String? roleStr) {
  if (roleStr == null) return null;
  switch (roleStr.toLowerCase()) {
    case 'admin':
      return AppRole.admin;
    case 'client':
      return AppRole.client;
    case 'photographer':
      return AppRole.photographer;
    default:
      return null;
  }
}

String _dashboardForRole(String roleStr) {
  switch (roleStr.toLowerCase()) {
    case 'admin':
      return AppConstants.routeAdminDashboard;
    case 'client':
      return AppConstants.routeClientDashboard;
    case 'photographer':
      return AppConstants.routePhotographerDashboard;
    default:
      return AppConstants.routeLanding;
  }
}

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(child: Text(label)),
    );
  }
}
