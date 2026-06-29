import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/shared/button.dart';
import 'package:time_leak_flutter/core/shared/responsive.dart' show AuthPageHeader, AuthPageLayout;
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

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: AppColors.black, size: context.widthByContext(20)),
        onPressed: () => context.router.back(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (context) => sl<ResetPasswordCubit>(),
      child: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetSuccess) {
            TopSnackBar.show(context, message: l10n.reset_success);
            context.router.replaceAll([const LoginRoute()]);
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
                  title: l10n.reset_newPasswordTitle,
                  subtitle: l10n.reset_newPasswordSubtitle,
                ),
                SizedBox(height: context.heightByContext(50)),
                AppTextField(
                  controller: _passController,
                  hintText: l10n.reset_passwordHint,
                  isPassword: true,
                  enabled: state is! ResetLoading,
                ),
                SizedBox(height: context.heightByContext(16)),
                AppTextField(
                  controller: _confirmController,
                  hintText: l10n.reset_confirmPasswordHint,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  enabled: state is! ResetLoading,
                ),
              ],
              bottom: state is ResetLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.brandColor1, strokeWidth: 2),
                    )
                  : AppButton(
                      text: l10n.reset_updatePassword,
                      onPressed: () {
                        final pass = _passController.text.trim();
                        final confirm = _confirmController.text.trim();

                        if (pass.isEmpty || confirm.isEmpty) {
                          TopSnackBar.show(context, message: l10n.reset_errorFillAllFields);
                        } else if (pass != confirm) {
                          TopSnackBar.show(context, message: l10n.reset_errorPasswordsMismatch);
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
          );
        },
      ),
    );
  }
}
