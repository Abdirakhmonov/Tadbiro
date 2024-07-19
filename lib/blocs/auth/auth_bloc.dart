import 'package:bloc/bloc.dart';

import '../../services/firebase_auth_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserAuthService authService;

  AuthenticationBloc(this.authService) : super(AuthenticationInitialState()) {
    on<LoginUserEvent>(_logInUser);
    on<RegisterUserEvent>(_registerUser);
    on<SignOutEvent>(_signOutUser);
  }

  void _logInUser(
    LoginUserEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoadingState());
    try {
      final user = await authService.logInUser(event.email, event.password);
      if (user != null) {
        emit(AuthenticationSuccessState(user));
      } else {
        emit(AuthenticationFailureState('Login failed'));
      }
    } catch (e) {
      emit(AuthenticationFailureState(e.toString()));
    }
  }

  void _registerUser(
    RegisterUserEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(AuthenticationLoadingState());
    try {
      final user = await authService.registerUser(
          event.email, event.password, event.username);
      if (user != null) {
        emit(AuthenticationSuccessState(user));
      } else {
        emit(AuthenticationFailureState('Registration failed'));
      }
    } catch (e) {
      emit(AuthenticationFailureState(e.toString()));
    }
  }

  void _signOutUser(
      SignOutEvent event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoadingState());
    try {
      await authService.signOut();
      emit(AuthenticationInitialState());
    } catch (e) {
      emit(AuthenticationFailureState(e.toString()));
    }
  }
}
