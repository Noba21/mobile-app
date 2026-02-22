part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, authenticated, failure }

final class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.user,
    this.errorMessage,
  });

  const AuthState.initial()
      : status = AuthStatus.initial,
        user = null,
        errorMessage = null;

  const AuthState.loading()
      : status = AuthStatus.loading,
        user = null,
        errorMessage = null;

  const AuthState.authenticated(User user)
      : status = AuthStatus.authenticated,
        user = user,
        errorMessage = null;

  const AuthState.failure(String message)
      : status = AuthStatus.failure,
        user = null,
        errorMessage = message;

  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

  @override
  List<Object?> get props => [status, user, errorMessage];
}
