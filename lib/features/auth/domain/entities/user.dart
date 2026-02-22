import 'package:equatable/equatable.dart';

/// Domain entity for an authenticated user.
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.role,
    this.name,
    this.phone,
    this.profileImageUrl,
  });

  final String id;
  final String email;
  final String role;
  final String? name;
  final String? phone;
  final String? profileImageUrl;

  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isClient => role.toLowerCase() == 'client';
  bool get isPhotographer => role.toLowerCase() == 'photographer';

  @override
  List<Object?> get props => [id, email, role, name, phone, profileImageUrl];
}
