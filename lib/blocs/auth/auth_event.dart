

abstract class AuthenticationEvent {}

class LoginUserEvent extends AuthenticationEvent {
  final String email;
  final String password;

  LoginUserEvent({
    required this.email,
    required this.password,
  });
}

class RegisterUserEvent extends AuthenticationEvent {
  final String email;
  final String password;
  final String username;

  RegisterUserEvent({
    required this.email,
    required this.password,
    required this.username,
  });
}

class SignOutEvent extends AuthenticationEvent {}
