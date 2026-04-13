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
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ResetPasswordCubit>(),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetOtpSent) {
            context.router.push(
              ResetVerifyRoute(requestId: state.requestId, phone: _phoneController.text.trim()),
            );
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
                      "Восстановление",
                      style: AppStyle.style(24, fontWeight: FontWeight.w700, color: AppColors.black),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Введите номер телефона,\nчтобы получить код доступа",
                      textAlign: TextAlign.center,
                      style: AppStyle.style(15, color: AppColors.grey, height: 1.5),
                    ),
                    const SizedBox(height: 50),

                    // Метка над полем (опционально, для минимализма можно убрать)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Телефон",
                        style: AppStyle.style(13, color: AppColors.black, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 8),

                    AppTextField(
                      controller: _phoneController,
                      hintText: "+7 777 000 00 00",
                      keyboardType: TextInputType.phone,
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
                              text: "Отправить код",
                              onPressed: () {
                                if (_phoneController.text.isNotEmpty) {
                                  context.read<ResetPasswordCubit>().sendResetOtp(
                                    _phoneController.text.trim(),
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
