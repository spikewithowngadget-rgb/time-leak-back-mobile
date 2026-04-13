import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_leak_flutter/feature/login/data/repository/auth_repository.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginInitial());

  Future<void> login({required String phone, required String password}) async {
    // 1. Состояние загрузки
    emit(LoginLoading());

    try {
      // 2. Вызов репозитория (токены сохранятся в Drift внутри репозитория)
      await _authRepository.login(phone: phone, password: password);

      // 3. Успешный вход
      emit(LoginSuccess());
    } catch (e) {
      // 4. Ошибка (выводим сообщение)
      emit(LoginError(e.toString()));
    }
  }

  // Сброс состояния, если пользователь начал вводить данные заново
  void reset() => emit(LoginInitial());
}
