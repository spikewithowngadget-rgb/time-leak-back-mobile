import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/shared/button.dart';
import 'package:time_leak_flutter/core/shared/text_field.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/snack_bar.dart';
import 'package:time_leak_flutter/feature/reset_password/presentation/cubit/reset_password_cubit.dart';

@RoutePage()
class CreateNewPasswordPage extends StatefulWidget {
  final String token;
  final String phone;

  const CreateNewPasswordPage({super.key, required this.token, required this.phone});

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ResetPasswordCubit>(),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetSuccess) {
            TopSnackBar.show(context, message: "Пароль успешно изменен!");
            context.router.replaceAll([const LoginRoute()]);
          } else if (state is ResetError) {
            TopSnackBar.show(context, message: state.message);
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: AppColors.backgroundColor,
              appBar: AppBar(
                backgroundColor: AppColors.backgroundColor,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black, size: 20),
                  onPressed: () => context.router.back(),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      "Новый пароль",
                      style: AppStyle.style(24, fontWeight: FontWeight.w700, color: AppColors.black),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Создайте новый пароль для доступа\nк вашему аккаунту",
                      textAlign: TextAlign.center,
                      style: AppStyle.style(15, color: AppColors.grey, height: 1.5),
                    ),
                    const SizedBox(height: 50),

                    // Поля ввода паролей
                    AppTextField(
                      controller: _passController,
                      hintText: "Пароль",
                      isPassword: true,
                      enabled: state is! ResetLoading,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _confirmController,
                      hintText: "Повторите пароль",
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      enabled: state is! ResetLoading,
                    ),

                    const Spacer(),

                    state is ResetLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: AppColors.brandColor1, strokeWidth: 2),
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              text: "Обновить пароль",
                              onPressed: () {
                                final pass = _passController.text.trim();
                                final confirm = _confirmController.text.trim();

                                if (pass.isEmpty || confirm.isEmpty) {
                                  TopSnackBar.show(context, message: "Заполните все поля");
                                } else if (pass != confirm) {
                                  TopSnackBar.show(context, message: "Пароли не совпадают");
                                } else {
                                  context.read<ResetPasswordCubit>().confirmNewPassword(
                                    phone: widget.phone,
                                    newPassword: pass,
                                    confirmPassword: confirm,
                                    token: widget.token,
                                  );
                                }
                              },
                            ),
                          ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
