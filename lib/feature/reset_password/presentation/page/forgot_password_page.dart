import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/shared/button.dart';
import 'package:time_leak_flutter/core/shared/responsive.dart';
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

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black, size: 20),
        onPressed: () => context.router.back(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final btnHeight = AppResponsive.buttonHeight(context);

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
            child: AuthPageLayout(
              appBar: _appBar(context),
              centerTitle: true,
              children: [
                AuthPageHeader(
                  center: true,
                  titleSize: 24,
                  title: "Восстановление",
                  subtitle: "Введите номер телефона, чтобы получить код доступа",
                ),
                SizedBox(height: AppResponsive.sectionSpacing(context, base: 50)),
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
              ],
              bottom: state is ResetLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.brandColor1, strokeWidth: 2),
                    )
                  : AppButton(
                      height: btnHeight,
                      text: "Отправить код",
                      onPressed: () {
                        if (_phoneController.text.isNotEmpty) {
                          context.read<ResetPasswordCubit>().sendResetOtp(_phoneController.text.trim());
                        }
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
