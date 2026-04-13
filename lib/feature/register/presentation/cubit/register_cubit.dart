import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_leak_flutter/feature/login/data/repository/auth_repository.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

// Состояние после отправки СМС (ждем код)
class RegisterOtpSent extends RegisterState {
  final String requestId;
  RegisterOtpSent(this.requestId);
}

// Состояние после верного кода (ждем пароль)
class RegisterOtpVerified extends RegisterState {
  final String token;
  RegisterOtpVerified(this.token);
}

class RegisterSuccess extends RegisterState {}

class RegisterError extends RegisterState {
  final String message;
  RegisterError(this.message);
}

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _repository;

  RegisterCubit(this._repository) : super(RegisterInitial());

  // Шаг 1: Запрос ОТП
  Future<void> sendOtp(String phone) async {
    emit(RegisterLoading());
    try {
      final res = await _repository.requestOtp(phone);
      emit(RegisterOtpSent(res.requestId));
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }

  // Шаг 2: Проверка кода
  Future<void> verifyCode(String requestId, String code) async {
    emit(RegisterLoading());
    try {
      final res = await _repository.verifyOtp(requestId, code);
      emit(RegisterOtpVerified(res.verificationToken));
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }

  // Шаг 3: Финальная регистрация
  Future<void> completeRegistration({
    required String phone,
    required String password,
    required String confirmPassword,
    required String token,
  }) async {
    emit(RegisterLoading());
    try {
      await _repository.register(
        phone: phone,
        password: password,
        confirmPassword: confirmPassword,
        verificationToken: token,
      );
      emit(RegisterSuccess());
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}
