import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_leak_flutter/feature/user/data/model/user_mode.dart';
import 'package:time_leak_flutter/feature/user/data/repository/user_repository.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserModel user;
  UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

class UserCubit extends Cubit<UserState> {
  final UserRepository _repository;

  UserCubit(this._repository) : super(UserInitial());

  Future<void> fetchUser() async {
    emit(UserLoading());
    try {
      final user = await _repository.getMe();
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  void clearUser() => emit(UserInitial());
}
