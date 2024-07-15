import 'package:bloc/bloc.dart';
import 'package:examen_4/cubits/auth_state.dart';
import 'package:examen_4/services/firebase_auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuthService _firebaseAuthService;

  AuthCubit(this._firebaseAuthService) : super(InitialAuthState());

  Future<void> registerUser(
      String email, String password, String username) async {
    emit(LoadingAuthState());
    try {
      bool usernameExists =
          await _firebaseAuthService.checkUsernameExists(username);
      if (usernameExists) {
        emit(ErrorAuthState('Username already exists'));
      } else {
        await _firebaseAuthService.registerUser(email, password, username);
        emit(AuthenticatedState());
      }
    } catch (e) {
      emit(ErrorAuthState(e.toString()));
    }
  }

  Future<void> loginUser(String email, String password) async {
    emit(LoadingAuthState());
    try {
      await _firebaseAuthService.loginUser(email, password);
      emit(AuthenticatedState());
    } catch (e) {
      emit(ErrorAuthState(e.toString()));
    }
  }

  Future<void> resetPasswordUser(String email) async {
    emit(LoadingAuthState());
    try {
      await _firebaseAuthService.resetPasswordUser(email);
      emit(UnAuthenticatedState());
    } catch (e) {
      emit(ErrorAuthState(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(LoadingAuthState());
    try {
      await _firebaseAuthService.signOut();
      emit(UnAuthenticatedState());
    } catch (e) {
      emit(ErrorAuthState(e.toString()));
    }
  }
}
