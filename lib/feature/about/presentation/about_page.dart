import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/resources/svg.dart';
import 'package:time_leak_flutter/core/router/app_router.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/shared/button.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/snack_bar.dart';
import 'package:time_leak_flutter/feature/login/data/repository/auth_repository.dart';
import 'package:time_leak_flutter/feature/user/cubit/user_cubit.dart';
import 'package:time_leak_flutter/feature/user/data/repository/user_repository.dart';
import 'package:time_leak_flutter/l10n/app_localizations.dart';

@RoutePage()
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool _deleteBusy = false;
  bool _logoutBusy = false;

  Future<void> _confirmAndLogout() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.widthByContext(16)),
        ),
        title: Text(
          l10n.drawer_logoutConfirmTitle,
          style: AppStyle.style(context.widthByContext(18), fontWeight: FontWeight.w700),
        ),
        content: Text(
          l10n.drawer_logoutConfirmBody,
          style: AppStyle.style(context.widthByContext(15), height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.drawer_logoutConfirmCancel, style: AppStyle.style(context.widthByContext(15))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              l10n.drawer_logoutConfirmYes,
              style: AppStyle.style(context.widthByContext(15), fontWeight: FontWeight.w700, color: AppColors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _logoutBusy = true);
    try {
      await sl<AuthRepository>().logout();
      sl<UserCubit>().clearUser();
      sl<AppRouter>().replaceAll([const LoginRoute()]);
    } finally {
      if (mounted) {
        setState(() => _logoutBusy = false);
      }
    }
  }

  Future<void> _confirmAndDeactivate() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => _DeactivateAccountDialog(l10n: l10n),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _deleteBusy = true);
    try {
      final cubit = sl<UserCubit>();
      if (cubit.state is! UserLoaded) {
        await cubit.fetchUser();
      }
      if (!mounted) return;
      final state = cubit.state;
      if (state is! UserLoaded) {
        TopSnackBar.show(context, message: l10n.about_deleteErrorNoProfile);
        return;
      }
      await sl<UserRepository>().deactivateUser(state.user.userId);
      if (!mounted) return;
      await sl<AuthRepository>().logout();
      cubit.clearUser();
      sl<AppRouter>().replaceAll([const LoginRoute()]);
    } on DeactivateUserException catch (e) {
      if (!mounted) return;
      final message = e.isForbidden
          ? l10n.about_deleteErrorForbidden
          : (e.serverMessage?.isNotEmpty == true ? e.serverMessage! : e.toString());
      TopSnackBar.show(context, message: message);
    } catch (e) {
      if (mounted) {
        TopSnackBar.show(context, message: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _deleteBusy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(context.widthByContext(4), context.heightByContext(4), context.widthByContext(8), 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: (_deleteBusy || _logoutBusy) ? null : () => context.router.maybePop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.black,
                      size: context.widthByContext(22),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      context.l10n.about_title,
                      style: AppStyle.style(context.widthByContext(20), fontWeight: FontWeight.w800, color: AppColors.black),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  context.widthByContext(20),
                  context.heightByContext(8),
                  context.widthByContext(20),
                  context.heightByContext(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Material(
                      color: AppColors.brandColor,
                      borderRadius: BorderRadius.circular(context.widthByContext(18)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: context.heightByContext(28)),
                        child: Center(
                          child: SvgPicture.asset(
                            AppSvg.brand,
                            height: context.heightByContext(36),
                            fit: BoxFit.contain,
                            colorFilter: const ColorFilter.mode(AppColors.brandColor1, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.heightByContext(24)),
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        final version = snapshot.hasData
                            ? '${snapshot.data!.version} (${snapshot.data!.buildNumber})'
                            : '—';
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.widthByContext(18),
                            vertical: context.heightByContext(16),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.brandColor.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(context.widthByContext(14)),
                            border: Border.all(color: AppColors.brandColor1.withValues(alpha: 0.35)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.tag_rounded,
                                size: context.widthByContext(22),
                                color: AppColors.brandColor1.withValues(alpha: 0.9),
                              ),
                              SizedBox(width: context.widthByContext(12)),
                              Expanded(
                                child: Text(
                                  context.l10n.about_versionLabel,
                                  style: AppStyle.style(
                                    context.widthByContext(15),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grey2,
                                  ),
                                ),
                              ),
                              Text(
                                version,
                                style: AppStyle.style(
                                  context.widthByContext(15),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: context.heightByContext(22)),
                    Text(
                      context.l10n.about_description,
                      style: AppStyle.style(context.widthByContext(16), height: 1.45, color: AppColors.grey2),
                    ),
                    SizedBox(height: context.heightByContext(16)),
                    Text(
                      context.l10n.about_reference,
                      style: AppStyle.style(context.widthByContext(15), fontWeight: FontWeight.w600, color: AppColors.black),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.widthByContext(20),
                context.heightByContext(8),
                context.widthByContext(20),
                context.heightByContext(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppButton(
                    text: context.l10n.drawer_logout,
                    onPressed: () {
                      if (_deleteBusy || _logoutBusy) return;
                      _confirmAndLogout();
                    },
                  ),
                  SizedBox(height: context.heightByContext(12)),
                  SizedBox(
                    width: double.infinity,
                    height: context.heightByContext(52),
                    child: OutlinedButton(
                      onPressed: (_deleteBusy || _logoutBusy) ? null : _confirmAndDeactivate,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.red,
                        side: const BorderSide(color: AppColors.red, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.widthByContext(12)),
                        ),
                        disabledForegroundColor: AppColors.red.withValues(alpha: 0.45),
                        disabledBackgroundColor: AppColors.backgroundColor,
                      ),
                      child: _deleteBusy
                          ? SizedBox(
                              width: context.widthByContext(24),
                              height: context.widthByContext(24),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: AppColors.red.withValues(alpha: 0.85),
                              ),
                            )
                          : Text(
                              context.l10n.about_deleteAccount,
                              style: AppStyle.style(
                                context.widthByContext(16),
                                fontWeight: FontWeight.w700,
                                color: AppColors.red,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Попап в том же визуальном языке, что и [ReminderDialog]: белый фон, скругление 20, персиковый блок.
class _DeactivateAccountDialog extends StatelessWidget {
  const _DeactivateAccountDialog({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.backgroundColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: context.widthByContext(40),
        vertical: context.heightByContext(24),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.widthByContext(20))),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.widthByContext(300)),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: context.widthByContext(18),
            right: context.widthByContext(18),
            top: context.heightByContext(20),
            bottom: context.heightByContext(20) + context.bottomInset,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      l10n.about_deleteDialogTitle,
                      style: AppStyle.style(context.widthByContext(22), fontWeight: FontWeight.w700, color: AppColors.black),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.close, color: AppColors.grey2),
                    style: IconButton.styleFrom(backgroundColor: Colors.transparent),
                  ),
                ],
              ),
              SizedBox(height: context.heightByContext(8)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthByContext(14),
                  vertical: context.heightByContext(12),
                ),
                decoration: BoxDecoration(
                  color: AppColors.brandColor,
                  borderRadius: BorderRadius.circular(context.widthByContext(12)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, size: context.widthByContext(22), color: AppColors.brandColor1),
                    SizedBox(width: context.widthByContext(10)),
                    Expanded(
                      child: Text(
                        l10n.about_deleteDialogBody,
                        style: AppStyle.style(context.widthByContext(14), height: 1.45, color: AppColors.grey2),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.heightByContext(24)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.black,
                      side: BorderSide(color: AppColors.brandColor1.withValues(alpha: 0.45)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.widthByContext(12)),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthByContext(12),
                        vertical: context.heightByContext(14),
                      ),
                      minimumSize: Size(double.infinity, context.heightByContext(48)),
                    ),
                    child: Text(
                      l10n.about_deleteDialogCancel,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: AppStyle.style(context.widthByContext(15), fontWeight: FontWeight.w600, color: AppColors.black),
                    ),
                  ),
                  SizedBox(height: context.heightByContext(10)),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.widthByContext(12)),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthByContext(12),
                        vertical: context.heightByContext(14),
                      ),
                      minimumSize: Size(double.infinity, context.heightByContext(48)),
                    ),
                    child: Text(
                      l10n.about_deleteDialogConfirm,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: AppStyle.style(context.widthByContext(15), fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
