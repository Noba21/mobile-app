import 'package:equatable/equatable.dart';

/// Domain entity for a user managed by the admin panel.
class AdminUser extends Equatable {
  const AdminUser({
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

  bool get isClient => role.toLowerCase() == 'client';
  bool get isPhotographer => role.toLowerCase() == 'photographer';

  @override
  List<Object?> get props =>
      [id, email, role, isActive, name, phone, profileImageUrl];
}
