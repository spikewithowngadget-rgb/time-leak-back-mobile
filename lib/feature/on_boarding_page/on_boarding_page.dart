import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/png.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/storage/onboarding_prefs.dart';
import 'package:time_leak_flutter/feature/locale/cubit/locale_cubit.dart';

/// Макет: мятный фон, логотип, строка языков (как Ru · Eng, но все языки + скролл), карусель, кнопки.
@RoutePage()
class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  static const _mintBg = Color(0xFFF3FAF2);
  static const _orange = Color(0xFFEDB058);

  final PageController _pageController = PageController();
  int _page = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finishOnboarding() async {
    await OnboardingPrefs.setCompleted();
    if (!mounted) return;
    context.router.replaceAll([const LoginRoute()]);
  }

  void _onPrimary() {
    if (_page < 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 320), curve: Curves.easeOutCubic);
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Явно даём тот же LocaleCubit, что и в main; BlocBuilder — надёжнее context.watch с auto_route.
    return BlocProvider.value(
      value: sl<LocaleCubit>(),
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          final l10n = context.l10n;
          final currentLang = AppLanguage.values.firstWhere(
            (e) => e.code == locale.languageCode,
            orElse: () => AppLanguage.english,
          );

          return Scaffold(
            backgroundColor: _mintBg,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  const _LogoBlock(orange: _orange),
                  const SizedBox(height: 8),
                  _LanguageRow(
                    current: currentLang,
                    onSelect: (lang) => context.read<LocaleCubit>().changeLanguage(lang),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    flex: 5,
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (i) => setState(() => _page = i),
                      children: [
                        _OnbImageCard(asset: AppPng.onb1, orange: _orange),
                        _OnbImageCard(asset: AppPng.onb2, orange: _orange),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _PagePills(page: _page, orange: _orange),
                  const SizedBox(height: 12),
                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: _OnboardingCopy(pageIndex: _page),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _onPrimary,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _orange,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text(
                              l10n.onboarding_next,
                              style: AppStyle.style(17, fontWeight: FontWeight.w700, color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: TextButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _finishOnboarding,
                            child: Text(
                              l10n.onboarding_skip,
                              style: AppStyle.style(
                                15,
                                color: AppColors.brandColor1,
                                fontWeight: FontWeight.w600,
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
        },
      ),
    );
  }
}

class _LogoBlock extends StatelessWidget {
  const _LogoBlock({required this.orange});

  final Color orange;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          color: orange,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(color: orange.withValues(alpha: 0.35), blurRadius: 18, offset: const Offset(0, 8)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Image.asset(AppPng.brandLogo, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

/// Как раньше (Ru · Eng): простой текст, выбранный — чёрный, остальные — серые; все языки в горизонтальном скролле.
class _LanguageRow extends StatelessWidget {
  const _LanguageRow({required this.current, required this.onSelect});

  final AppLanguage current;
  final ValueChanged<AppLanguage> onSelect;

  @override
  Widget build(BuildContext context) {
    final langs = AppLanguage.values;

    return SizedBox(
      height: 36,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < langs.length; i++) ...[
              if (i > 0) Text(' · ', style: AppStyle.style(15, color: AppColors.grey1)),
              TextButton(
                onPressed: () => onSelect(langs[i]),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  langs[i].chipCode,
                  style: AppStyle.style(
                    15,
                    fontWeight: FontWeight.w600,
                    color: current == langs[i] ? AppColors.black : AppColors.grey,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OnbImageCard extends StatelessWidget {
  const _OnbImageCard({required this.asset, required this.orange});

  final String asset;
  final Color orange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: AspectRatio(
          aspectRatio: 1.15,
          child: Image.asset(
            asset,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => ColoredBox(color: orange.withValues(alpha: 0.3)),
          ),
        ),
      ),
    );
  }
}

class _PagePills extends StatelessWidget {
  const _PagePills({required this.page, required this.orange});

  final int page;
  final Color orange;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _pill(active: page == 0, orange: orange),
        const SizedBox(width: 10),
        _pill(active: page == 1, orange: orange),
      ],
    );
  }

  Widget _pill({required bool active, required Color orange}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: active ? 36 : 28,
      height: 5,
      decoration: BoxDecoration(
        color: active ? orange : AppColors.grey1.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}

class _OnboardingCopy extends StatelessWidget {
  const _OnboardingCopy({required this.pageIndex});

  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    if (pageIndex == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboarding_title,
            style: AppStyle.style(22, fontWeight: FontWeight.w700, color: AppColors.black),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.onboarding_page1_bullets,
            style: AppStyle.style(15, height: 1.45, color: AppColors.black),
          ),
          const SizedBox(height: 14),
          Text(l10n.onboarding_page1_question, style: AppStyle.style(15, color: AppColors.black)),
          const SizedBox(height: 12),
          Text(
            l10n.onboarding_page1_conclusion,
            style: AppStyle.style(16, fontWeight: FontWeight.w800, color: AppColors.black, height: 1.35),
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.onboarding_title,
          style: AppStyle.style(22, fontWeight: FontWeight.w700, color: AppColors.black),
        ),
        const SizedBox(height: 12),
        Text(l10n.onboarding_page2_bullet, style: AppStyle.style(15, height: 1.45, color: AppColors.black)),
        const SizedBox(height: 16),
        Text(
          l10n.onboarding_page2_conclusion,
          style: AppStyle.style(16, fontWeight: FontWeight.w800, color: AppColors.black, height: 1.35),
        ),
      ],
    );
  }
}
