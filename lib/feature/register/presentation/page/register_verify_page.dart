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
class RegisterVerifyPage extends StatefulWidget {
  final String requestId;
  final String phone;

  const RegisterVerifyPage({super.key, required this.requestId, required this.phone});

  @override
  State<RegisterVerifyPage> createState() => _RegisterVerifyPageState();
}

class _RegisterVerifyPageState extends State<RegisterVerifyPage> {
  final TextEditingController _codeController = TextEditingController();
  late RegisterCubit _registerCubit;

  @override
  void initState() {
    super.initState();
    _registerCubit = sl<RegisterCubit>();
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      bloc: _registerCubit,
      listener: (context, state) {
        if (state is RegisterOtpVerified) {
          // Код верный! Переходим к установке пароля.
          // Передаем полученный verificationToken и номер телефона.
          context.router.push(RegisterPasswordRoute(verificationToken: state.token, phone: widget.phone));
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text("Подтверждение", style: AppStyle.style(32, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text(
                      "Мы отправили код на номер ${widget.phone}",
                      style: AppStyle.style(16, color: AppColors.grey2),
                    ),
                    const SizedBox(height: 40),

                    Text("Код из СМС", style: AppStyle.style(14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    AppTextField(
                      hintText: "0000",
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      enabled: state is! RegisterLoading,
                    ),

                    const SizedBox(height: 24),

                    // Кнопка повторной отправки (визуально)
                    Center(
                      child: TextButton(
                        onPressed: state is RegisterLoading
                            ? null
                            : () => _registerCubit.sendOtp(widget.phone),
                        child: Text(
                          "Отправить код повторно",
                          style: AppStyle.style(
                            14,
                            color: AppColors.brandColor1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const Spacer(),

                    state is RegisterLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.brandColor1))
                        : AppButton(
                            text: "Подтвердить",
                            onPressed: () {
                              if (_codeController.text.length >= 4) {
                                _registerCubit.verifyCode(widget.requestId, _codeController.text.trim());
                              } else {
                                TopSnackBar.show(context, message: "Введите полный код");
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
