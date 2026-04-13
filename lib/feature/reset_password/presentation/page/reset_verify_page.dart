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
class ResetVerifyPage extends StatefulWidget {
  final String requestId;
  final String phone;

  const ResetVerifyPage({super.key, required this.requestId, required this.phone});

  @override
  State<ResetVerifyPage> createState() => _ResetVerifyPageState();
}

class _ResetVerifyPageState extends State<ResetVerifyPage> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ResetPasswordCubit>(),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetOtpVerified) {
            context.router.push(CreateNewPasswordRoute(token: state.token, phone: widget.phone));
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
                  icon: const Icon(Icons.close, color: AppColors.black, size: 20),
                  onPressed: () => context.router.replaceAll([const LoginRoute()]),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Центрируем контент
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      "Код подтверждения",
                      style: AppStyle.style(24, fontWeight: FontWeight.w700, color: AppColors.black),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Мы отправили его на номер\n${widget.phone}",
                      textAlign: TextAlign.center,
                      style: AppStyle.style(15, color: AppColors.grey, height: 1.5),
                    ),
                    const SizedBox(height: 50),

                    // Поле ввода
                    AppTextField(
                      controller: _codeController,
                      hintText: "••••",
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      enabled: state is! ResetLoading,
                    ),

                    const SizedBox(height: 32),

                    // Кнопка повтора без фона и эффектов
                    GestureDetector(
                      onTap: state is ResetLoading
                          ? null
                          : () => context.read<ResetPasswordCubit>().sendResetOtp(widget.phone),
                      child: Text(
                        "Отправить еще раз",
                        style: AppStyle.style(14, color: AppColors.brandColor1, fontWeight: FontWeight.w600),
                      ),
                    ),

                    const Spacer(),

                    state is ResetLoading
                        ? const Center(
                            child: CircularProgressIndicator(color: AppColors.brandColor1, strokeWidth: 2),
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              text: "Продолжить",
                              onPressed: () {
                                if (_codeController.text.length >= 4) {
                                  context.read<ResetPasswordCubit>().verifyResetCode(
                                    widget.requestId,
                                    _codeController.text.trim(),
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
