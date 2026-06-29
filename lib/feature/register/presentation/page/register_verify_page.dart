import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/shared/button.dart';
import 'package:time_leak_flutter/core/shared/responsive.dart' show AuthPageHeader, AuthPageLayout;
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
    final linkStyle = AppStyle.style(context.widthByContext(14), color: AppColors.brandColor1, fontWeight: FontWeight.w600);

    return BlocConsumer<RegisterCubit, RegisterState>(
      bloc: _registerCubit,
      listener: (context, state) {
        if (state is RegisterOtpVerified) {
          context.router.push(RegisterPasswordRoute(verificationToken: state.token, phone: widget.phone));
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
                title: l10n.register_verifyTitle,
                subtitle: l10n.register_verifySubtitle(widget.phone),
              ),
              SizedBox(height: context.heightByContext(40)),
              Text(l10n.register_smsCodeLabel, style: labelStyle),
              SizedBox(height: context.heightByContext(8)),
              AppTextField(
                hintText: "0000",
                controller: _codeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                enabled: state is! RegisterLoading,
              ),
              SizedBox(height: context.heightByContext(16)),
              Center(
                child: TextButton(
                  onPressed: state is RegisterLoading ? null : () => _registerCubit.sendOtp(widget.phone),
                  child: Text(l10n.register_resendCode, style: linkStyle),
                ),
              ),
            ],
            bottom: state is RegisterLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.brandColor1))
                : AppButton(
                    text: l10n.register_confirm,
                    onPressed: () {
                      if (_codeController.text.length >= 4) {
                        _registerCubit.verifyCode(widget.requestId, _codeController.text.trim());
                      } else {
                        TopSnackBar.show(context, message: l10n.register_errorEnterFullCode);
                      }
                    },
                  ),
          ),
        );
      },
    );
  }
}
