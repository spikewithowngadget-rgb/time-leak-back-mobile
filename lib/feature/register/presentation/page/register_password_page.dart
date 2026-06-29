import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/security/pin_session.dart';
import 'package:time_leak_flutter/core/shared/button.dart';
import 'package:time_leak_flutter/core/shared/responsive.dart' show AuthPageHeader, AuthPageLayout;
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

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.black),
        onPressed: () => context.router.back(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labelStyle = AppStyle.style(context.widthByContext(14), fontWeight: FontWeight.w600);

    return BlocConsumer<RegisterCubit, RegisterState>(
      bloc: _registerCubit,
      listener: (context, state) {
        if (state is RegisterSuccess) {
          PinSession.reset();
          TopSnackBar.show(context, message: l10n.register_success);
          context.router.replaceAll([const CalendarRoute()]);
        } else if (state is RegisterError) {
          TopSnackBar.show(context, message: state.message);
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: AuthPageLayout(
            appBar: _appBar(context),
            children: [
              AuthPageHeader(
                title: l10n.register_passwordTitle,
                subtitle: l10n.register_passwordSubtitle,
              ),
              SizedBox(height: context.heightByContext(40)),
              Text(l10n.login_passwordLabel, style: labelStyle),
              SizedBox(height: context.heightByContext(8)),
              AppTextField(
                hintText: "••••••••",
                controller: _passwordController,
                isPassword: true,
                enabled: state is! RegisterLoading,
              ),
              SizedBox(height: context.heightByContext(20)),
              Text(l10n.register_confirmPasswordLabel, style: labelStyle),
              SizedBox(height: context.heightByContext(8)),
              AppTextField(
                hintText: "••••••••",
                controller: _confirmPasswordController,
                isPassword: true,
                textInputAction: TextInputAction.done,
                enabled: state is! RegisterLoading,
              ),
            ],
            bottom: state is RegisterLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.brandColor1))
                : AppButton(
                    text: l10n.register_complete,
                    onPressed: () {
                      final pass = _passwordController.text.trim();
                      final confirm = _confirmPasswordController.text.trim();

                      if (pass.isEmpty || confirm.isEmpty) {
                        TopSnackBar.show(context, message: l10n.register_errorFillAllFields);
                      } else if (pass != confirm) {
                        TopSnackBar.show(context, message: l10n.register_errorPasswordsMismatch);
                      } else if (pass.length < 8) {
                        TopSnackBar.show(context, message: l10n.register_errorPasswordTooShort);
                      } else {
                        _registerCubit.completeRegistration(
                          phone: widget.phone,
                          password: pass,
                          confirmPassword: confirm,
                          token: widget.verificationToken,
                        );
                      }
                    },
                  ),
          ),
        );
      },
    );
  }
}
