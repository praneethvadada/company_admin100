import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/entities/admin.dart';
import '../../core/utils/shared_preferences_util.dart'; // Import the shared preferences util

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Admin admin;

  LoginSuccess(this.admin);
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}

class LoginBloc extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(LoginInitial());

  Future<void> login(String username, String password) async {
    try {
      print('--- Starting Login Process ---');
      emit(LoginLoading());
      Admin admin = await loginUseCase.login(username, password);

      print('Login successful, admin: ${admin.username}');

      // Save the token to shared preferences
      await SharedPreferencesUtil.saveToken(admin.token);
      print('Token saved: ${admin.token}');

      emit(LoginSuccess(admin));
    } catch (e) {
      print('Login failed with error: $e');
      emit(LoginFailure(e.toString()));
    }
  }
}
