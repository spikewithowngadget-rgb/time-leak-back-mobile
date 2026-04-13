import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_leak_flutter/feature/login/data/repository/auth_repository.dart';

abstract class ResetPasswordState {}

class ResetInitial extends ResetPasswordState {}

class ResetLoading extends ResetPasswordState {}

class ResetOtpSent extends ResetPasswordState {
  final String requestId;
  ResetOtpSent(this.requestId);
}

class ResetOtpVerified extends ResetPasswordState {
  final String token;
  ResetOtpVerified(this.token);
}

class ResetSuccess extends ResetPasswordState {}

class ResetError extends ResetPasswordState {
  final String message;
  ResetError(this.message);
}

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepository _repository;

  ResetPasswordCubit(this._repository) : super(ResetInitial());

  // Шаг 1: Запрос кода
  Future<void> sendResetOtp(String phone) async {
    emit(ResetLoading());
    try {
      final res = await _repository.requestPasswordResetOtp(phone);
      emit(ResetOtpSent(res.requestId));
    } catch (e) {
      emit(ResetError(e.toString()));
    }
  }

  // Шаг 2: Проверка кода
  Future<void> verifyResetCode(String requestId, String code) async {
    emit(ResetLoading());
    try {
      final res = await _repository.verifyPasswordResetOtp(requestId, code);
      emit(ResetOtpVerified(res.verificationToken));
    } catch (e) {
      emit(ResetError(e.toString()));
    }
  }

  // Шаг 3: Установка нового пароля
  Future<void> confirmNewPassword({
    required String phone,
    required String newPassword,
    required String confirmPassword,
    required String token,
  }) async {
    emit(ResetLoading());
    try {
      await _repository.confirmPasswordReset(
        phone: phone,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        verificationToken: token,
      );
      emit(ResetSuccess());
    } catch (e) {
      emit(ResetError(e.toString()));
    }
  }
}
