import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/shared/button.dart';
import 'package:time_leak_flutter/core/shared/text_field.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/snack_bar.dart';
import 'package:time_leak_flutter/feature/login/presentation/cubit/login_cubit.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Меняем email на phone, так как API ждет номер телефона
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginCubit _loginCubit;
  @override
  void initState() {
    super.initState();
    _loginCubit = GetIt.I<LoginCubit>();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      bloc: _loginCubit,
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.router.replaceAll([const CalendarRoute()]);
        } else if (state is LoginError) {
          TopSnackBar.show(context, message: state.message);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Welcome Back",
                        style: AppStyle.style(32, fontWeight: FontWeight.w800, color: AppColors.black),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Войдите в свой аккаунт Timeleak",
                        style: AppStyle.style(16, color: AppColors.grey2),
                      ),
                      const SizedBox(height: 40),

                      // Метка Phone
                      Text("Телефон", style: AppStyle.style(14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      AppTextField(
                        hintText: "+7 701 555 66 77",
                        controller: _phoneController,
                        keyboardType: TextInputType.phone, // Тип клавиатуры для телефона
                        textInputAction: TextInputAction.next,
                        enabled: state is! LoginLoading,
                      ),

                      const SizedBox(height: 20),

                      Text("Пароль", style: AppStyle.style(14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      AppTextField(
                        hintText: "••••••••",
                        controller: _passwordController,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        enabled: state is! LoginLoading,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            // 1. Убираем цвет подсветки при наведении и нажатии
                            overlayColor: Colors.transparent,
                            // 2. Убираем сам эффект "всплеска" (расходящегося круга)
                            splashFactory: NoSplash.splashFactory,
                            // 3. Убираем лишние отступы, чтобы кнопка была компактной
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: state is LoginLoading
                              ? null
                              : () => context.router.push(const ForgotPasswordRoute()),
                          child: Text(
                            "Забыли пароль?",
                            style: AppStyle.style(
                              14,
                              color: AppColors.brandColor1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      // const SizedBox(height: 32),
                      state is LoginLoading
                          ? const Center(child: CircularProgressIndicator(color: AppColors.brandColor1))
                          : AppButton(
                              text: "Войти",
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                // Вызываем метод кубита с правильными именованными параметрами
                                _loginCubit.login(
                                  phone: _phoneController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                              },
                            ),

                      const SizedBox(height: 24),

                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            // 1. Убираем цвет подсветки при наведении и нажатии
                            overlayColor: Colors.transparent,
                            // 2. Убираем сам эффект "всплеска" (расходящегося круга)
                            splashFactory: NoSplash.splashFactory,
                            // 3. Убираем лишние отступы, чтобы кнопка была компактной
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: state is LoginLoading
                              ? null
                              : () {
                                  context.router.push(const RegisterPhoneRoute());
                                },
                          child: RichText(
                            text: TextSpan(
                              text: "Нет аккаунта? ",
                              style: AppStyle.style(14, color: AppColors.grey2),
                              children: [
                                TextSpan(
                                  text: "Зарегистрироваться",
                                  style: AppStyle.style(
                                    14,
                                    color: AppColors.brandColor1,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
