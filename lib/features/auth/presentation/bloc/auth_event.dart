part of 'auth_bloc.dart';

abstract sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

final class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phone,
  });

  final String fullName;
  final String email;
  final String password;
  final String phone;

  @override
  List<Object?> get props => [fullName, email, password, phone];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
