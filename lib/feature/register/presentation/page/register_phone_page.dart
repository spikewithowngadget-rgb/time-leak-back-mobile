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
class RegisterPhonePage extends StatefulWidget {
  const RegisterPhonePage({super.key});

  @override
  State<RegisterPhonePage> createState() => _RegisterPhonePageState();
}

class _RegisterPhonePageState extends State<RegisterPhonePage> {
  final TextEditingController _phoneController = TextEditingController();
  late RegisterCubit _registerCubit;

  @override
  void initState() {
    super.initState();
    _registerCubit = sl<RegisterCubit>();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      bloc: _registerCubit,
      listener: (context, state) {
        if (state is RegisterOtpSent) {
          // Когда OTP отправлен, переходим на страницу ввода кода
          // Передаем requestId и phone дальше
          context.router.navigate(
            RegisterVerifyRoute(requestId: state.requestId, phone: _phoneController.text.trim()),
          );
        } else if (state is RegisterError) {
          TopSnackBar.show(context, message: state.message);
        }
      },
      builder: (context, state) {
        return Scaffold(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text("Регистрация", style: AppStyle.style(32, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Text(
                    "Введите ваш номер телефона для получения кода подтверждения",
                    style: AppStyle.style(16, color: AppColors.grey2),
                  ),
                  const SizedBox(height: 40),

                  Text("Номер телефона", style: AppStyle.style(14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  AppTextField(
                    hintText: "+7 701 555 66 77",
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    enabled: state is! RegisterLoading,
                  ),

                  const Spacer(),

                  state is RegisterLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.brandColor1))
                      : AppButton(
                          text: "Получить код",
                          onPressed: () {
                            if (_phoneController.text.isNotEmpty) {
                              _registerCubit.sendOtp(_phoneController.text.trim());
                            } else {
                              TopSnackBar.show(context, message: "Введите номер телефона");
                            }
                          },
                        ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
