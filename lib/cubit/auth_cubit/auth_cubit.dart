import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/auth_services.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(AuthInitial());

  /// Sign Up method
  void signUp({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await authService.signUp(email: email, password: password); // ✅ استخدم signUp
      emit(AuthSuccess("Account created successfully"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// Login method
  void login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await authService.login(email: email, password: password);
      emit(AuthSuccess("Logged in successfully"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}