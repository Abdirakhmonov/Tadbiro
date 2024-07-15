sealed class AuthState {}

class InitialAuthState extends AuthState {}

class LoadingAuthState extends AuthState {}

class AuthenticatedState extends AuthState {}

class UnAuthenticatedState extends AuthState {}

class ErrorAuthState extends AuthState {
  String message;

  ErrorAuthState(this.message);
}
