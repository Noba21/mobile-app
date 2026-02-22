/// App-wide constants: API base URL, route paths, and shared strings.
class AppConstants {
  AppConstants._();

  // API
  static const String apiBaseUrl = 'https://api.photographystudio.example.com/v1';
  static const String apiTimeoutSeconds = '30';

  // Storage keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserRole = 'user_role';
  static const String keyUserId = 'user_id';

  // Route paths
  static const String routeLanding = '/';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';

  // Admin
  static const String routeAdminDashboard = '/admin';
  static const String routeAdminUsers = '/admin/users';
  static const String routeAdminPackages = '/admin/packages';
  static const String routeAdminGallery = '/admin/gallery';
  static const String routeAdminProfile = '/admin/profile';
  static const String routeAdminAssignments = '/admin/assignments';
  static const String routeAdminNotifications = '/admin/notifications';
  static const String routeAdminAnalysis = '/admin/analysis';

  // Client
  static const String routeClientDashboard = '/client';
  static const String routeClientPackages = '/client/packages';
  static const String routeClientBookings = '/client/bookings';
  static const String routeClientProfile = '/client/profile';
  static const String routeClientNotifications = '/client/notifications';

  // Photographer
  static const String routePhotographerDashboard = '/photographer';
  static const String routePhotographerAssignments = '/photographer/assignments';
  static const String routePhotographerProfile = '/photographer/profile';
  static const String routePhotographerTaskStatus = '/photographer/task-status';

  // App strings
  static const String appName = 'Photography Studio';
}
