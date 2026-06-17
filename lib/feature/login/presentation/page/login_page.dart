import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/security/pin_session.dart';
import 'package:time_leak_flutter/core/storage/app_database.dart';
import 'package:time_leak_flutter/core/shared/button.dart';
import 'package:time_leak_flutter/core/shared/responsive.dart' show AuthPageHeader, AuthPageLayout;
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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginCubit _loginCubit;

  @override
  void initState() {
    super.initState();
    _loginCubit = GetIt.I<LoginCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirectIfAlreadySignedIn());
  }

  Future<void> _redirectIfAlreadySignedIn() async {
    final tokens = await sl<AppDatabase>().getTokens();
    if (!mounted || tokens == null) return;
    context.router.replaceAll([const CalendarRoute()]);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppStyle.style(context.widthByContext(14), fontWeight: FontWeight.w600);
    final linkStyle = AppStyle.style(context.widthByContext(14), color: AppColors.brandColor1, fontWeight: FontWeight.w600);
    final hintStyle = AppStyle.style(context.widthByContext(14), color: AppColors.grey2);
    final registerLinkStyle = AppStyle.style(context.widthByContext(14), color: AppColors.brandColor1, fontWeight: FontWeight.w700);

    return BlocConsumer<LoginCubit, LoginState>(
      bloc: _loginCubit,
      listener: (context, state) {
        if (state is LoginSuccess) {
          PinSession.reset();
          context.router.replaceAll([const CalendarRoute()]);
        } else if (state is LoginError) {
          TopSnackBar.show(context, message: state.message);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AuthPageLayout(
            children: [
              AuthPageHeader(
                title: context.l10n.login_welcomeBack,
                subtitle: context.l10n.login_subtitle,
              ),
              SizedBox(height: context.heightByContext(40)),
              Text(context.l10n.login_phoneLabel, style: labelStyle),
              SizedBox(height: context.heightByContext(8)),
              AppTextField(
                hintText: "+7 701 555 66 77",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                enabled: state is! LoginLoading,
              ),
              SizedBox(height: context.heightByContext(20)),
              Text(context.l10n.login_passwordLabel, style: labelStyle),
              SizedBox(height: context.heightByContext(8)),
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
                    overlayColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: state is LoginLoading
                      ? null
                      : () => context.router.push(const ForgotPasswordRoute()),
                  child: Text(context.l10n.login_forgotPassword, style: linkStyle),
                ),
              ),
              SizedBox(height: context.heightByContext(28)),
              state is LoginLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.brandColor1))
                  : AppButton(
                      height: context.heightByContext(56),
                      text: context.l10n.login_signIn,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _loginCubit.login(
                          phone: _phoneController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                      },
                    ),
              SizedBox(height: context.heightByContext(24)),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    overlayColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.widthByContext(8),
                      vertical: context.heightByContext(4),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: state is LoginLoading
                      ? null
                      : () => context.router.push(const RegisterPhoneRoute()),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Нет аккаунта? ",
                      style: hintStyle,
                      children: [
                        TextSpan(text: "Зарегистрироваться", style: registerLinkStyle),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
