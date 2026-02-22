import '../../domain/entities/admin_user.dart';

/// DTO for admin user API response.
class AdminUserModel {
  const AdminUserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
    this.name,
    this.phone,
    this.profileImageUrl,
  });

  final String id;
  final String email;
  final String role;
  final bool isActive;
  final String? name;
  final String? phone;
  final String? profileImageUrl;

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? json['user_role'] as String? ?? 'client',
      isActive: json['is_active'] as bool? ?? json['isActive'] as bool? ?? true,
      name: json['name'] as String? ?? json['full_name'] as String? ?? json['fullName'] as String?,
      phone: json['phone'] as String?,
      profileImageUrl: json['profile_image_url'] as String? ??
          json['profileImageUrl'] as String? ??
          json['avatar'] as String?,
    );
  }

  AdminUser toEntity() => AdminUser(
        id: id,
        email: email,
        role: role,
        isActive: isActive,
        name: name,
        phone: phone,
        profileImageUrl: profileImageUrl,
      );
}
