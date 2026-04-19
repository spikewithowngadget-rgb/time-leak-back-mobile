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
              padding: const EdgeInsets.fromLTRB(4, 4, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _deleteBusy ? null : () => context.router.maybePop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.black, size: 22),
                  ),
                  Expanded(
                    child: Text(
                      context.l10n.about_title,
                      style: AppStyle.style(20, fontWeight: FontWeight.w800, color: AppColors.black),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Material(
                      color: AppColors.brandColor,
                      borderRadius: BorderRadius.circular(18),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Center(
                          child: SvgPicture.asset(
                            AppSvg.brand,
                            height: 36,
                            fit: BoxFit.contain,
                            colorFilter: const ColorFilter.mode(AppColors.brandColor1, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FutureBuilder<PackageInfo>(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        final version = snapshot.hasData
                            ? '${snapshot.data!.version} (${snapshot.data!.buildNumber})'
                            : '—';
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppColors.brandColor.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.brandColor1.withValues(alpha: 0.35)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.tag_rounded,
                                size: 22,
                                color: AppColors.brandColor1.withValues(alpha: 0.9),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  context.l10n.about_versionLabel,
                                  style: AppStyle.style(
                                    15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grey2,
                                  ),
                                ),
                              ),
                              Text(
                                version,
                                style: AppStyle.style(
                                  15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 22),
                    Text(
                      context.l10n.about_description,
                      style: AppStyle.style(16, height: 1.45, color: AppColors.grey2),
                    ),
                    const SizedBox(height: 36),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: _deleteBusy ? null : _confirmAndDeactivate,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.red,
                          side: const BorderSide(color: AppColors.red, width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          disabledForegroundColor: AppColors.red.withValues(alpha: 0.45),
                          disabledBackgroundColor: AppColors.backgroundColor,
                        ),
                        child: _deleteBusy
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.red.withValues(alpha: 0.85),
                                ),
                              )
                            : Text(
                                context.l10n.about_deleteAccount,
                                style: AppStyle.style(16, fontWeight: FontWeight.w700, color: AppColors.red),
                              ),
                      ),
                    ),
                  ],
                ),
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
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 18,
            right: 18,
            top: 20,
            bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
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
                      style: AppStyle.style(22, fontWeight: FontWeight.w700, color: AppColors.black),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.close, color: AppColors.grey2),
                    style: IconButton.styleFrom(backgroundColor: Colors.transparent),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.brandColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 22, color: AppColors.brandColor1),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.about_deleteDialogBody,
                        style: AppStyle.style(14, height: 1.45, color: AppColors.grey2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.black,
                      side: BorderSide(color: AppColors.brandColor1.withValues(alpha: 0.45)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      l10n.about_deleteDialogCancel,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: AppStyle.style(15, fontWeight: FontWeight.w600, color: AppColors.black),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: Text(
                      l10n.about_deleteDialogConfirm,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: AppStyle.style(15, fontWeight: FontWeight.w700, color: Colors.white),
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
