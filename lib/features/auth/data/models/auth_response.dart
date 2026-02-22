import '../../domain/entities/user.dart';

/// DTO for login/register API response (token + user).
class AuthResponse {
  const AuthResponse({
    required this.accessToken,
    required this.user,
    this.refreshToken,
  });

  final String accessToken;
  final String? refreshToken;
  final User user;

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>?;
    if (userJson == null) {
      throw FormatException('Auth response must contain "user"');
    }
    final accessToken = json['access_token'] as String? ?? json['accessToken'] as String?;
    if (accessToken == null || accessToken.isEmpty) {
      throw FormatException('Auth response must contain "access_token"');
    }
    return AuthResponse(
      accessToken: accessToken,
      refreshToken: json['refresh_token'] as String? ?? json['refreshToken'] as String?,
      user: _userFromJson(userJson),
    );
  }

  static User _userFromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? json['user_role'] as String? ?? 'client',
      name: json['name'] as String? ?? json['full_name'] as String? ?? json['fullName'] as String?,
      phone: json['phone'] as String?,
      profileImageUrl: json['profile_image_url'] as String? ?? json['profileImageUrl'] as String? ?? json['avatar'] as String?,
    );
  }
}
