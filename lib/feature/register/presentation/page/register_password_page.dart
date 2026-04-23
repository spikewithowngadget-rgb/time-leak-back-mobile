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
import 'package:time_leak_flutter/feature/register/presentation/cubit/register_cubit.dart';

@RoutePage()
class RegisterPasswordPage extends StatefulWidget {
  final String phone;
  final String verificationToken;

  const RegisterPasswordPage({super.key, required this.phone, required this.verificationToken});

  @override
  State<RegisterPasswordPage> createState() => _RegisterPasswordPageState();
}

class _RegisterPasswordPageState extends State<RegisterPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  late RegisterCubit _registerCubit;

  @override
  void initState() {
    super.initState();
    _registerCubit = sl<RegisterCubit>();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      bloc: _registerCubit,
      listener: (context, state) {
        if (state is RegisterSuccess) {
          // Регистрация завершена! Перекидываем на логин или сразу в приложение
          TopSnackBar.show(context, message: "Регистрация прошла успешно!");

          // Очищаем стек и уходим на страницу логина
          context.router.replaceAll([const LoginRoute()]);
        } else if (state is RegisterError) {
          TopSnackBar.show(context, message: state.message);
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () => context.router.back(),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text("Придумайте пароль", style: AppStyle.style(32, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text(
                      "Пароль должен быть надежным и содержать не менее 8 символов",
                      style: AppStyle.style(16, color: AppColors.grey2),
                    ),
                    const SizedBox(height: 40),

                    Text("Пароль", style: AppStyle.style(14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    AppTextField(
                      hintText: "••••••••",
                      controller: _passwordController,
                      isPassword: true,
                      enabled: state is! RegisterLoading,
                    ),

                    const SizedBox(height: 20),

                    Text("Подтвердите пароль", style: AppStyle.style(14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    AppTextField(
                      hintText: "••••••••",
                      controller: _confirmPasswordController,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      enabled: state is! RegisterLoading,
                    ),

                    const SizedBox(height: 40),

                    state is RegisterLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.brandColor1))
                        : AppButton(
                            text: "Завершить регистрацию",
                            onPressed: () {
                              final pass = _passwordController.text.trim();
                              final confirm = _confirmPasswordController.text.trim();

                              if (pass.isEmpty || confirm.isEmpty) {
                                TopSnackBar.show(context, message: "Заполните все поля");
                              } else if (pass != confirm) {
                                TopSnackBar.show(context, message: "Пароли не совпадают");
                              } else if (pass.length < 8) {
                                TopSnackBar.show(context, message: "Пароль слишком короткий");
                              } else {
                                // Вызываем финальный метод регистрации
                                _registerCubit.completeRegistration(
                                  phone: widget.phone,
                                  password: pass,
                                  confirmPassword: confirm,
                                  token: widget.verificationToken,
                                );
                              }
                            },
                          ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
