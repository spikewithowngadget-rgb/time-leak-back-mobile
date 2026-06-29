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
                  SizedBox(height: context.heightByContext(8)),
                  _LogoBlock(orange: _orange),
                  SizedBox(height: context.heightByContext(8)),
                  _LanguageRow(
                    current: currentLang,
                    onSelect: (lang) => context.read<LocaleCubit>().changeLanguage(lang),
                  ),
                  SizedBox(height: context.heightByContext(16)),
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
                  SizedBox(height: context.heightByContext(12)),
                  _PagePills(page: _page, orange: _orange),
                  SizedBox(height: context.heightByContext(12)),
                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: context.widthByContext(22)),
                      child: _OnboardingCopy(pageIndex: _page),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.widthByContext(20),
                      context.heightByContext(8),
                      context.widthByContext(20),
                      context.heightByContext(12),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: context.heightByContext(52),
                          child: ElevatedButton(
                            onPressed: _onPrimary,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _orange,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(context.widthByContext(14)),
                              ),
                            ),
                            child: Text(
                              l10n.onboarding_next,
                              style: AppStyle.style(
                                context.widthByContext(17),
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: context.heightByContext(12)),
                        SizedBox(
                          width: double.infinity,
                          height: context.heightByContext(52),
                          child: TextButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(context.widthByContext(14)),
                              ),
                            ),
                            onPressed: _finishOnboarding,
                            child: Text(
                              l10n.onboarding_skip,
                              style: AppStyle.style(
                                context.widthByContext(15),
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
    final size = context.widthByContext(88);
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: orange,
          borderRadius: BorderRadius.circular(context.widthByContext(22)),
          boxShadow: [
            BoxShadow(
              color: orange.withValues(alpha: 0.35),
              blurRadius: context.widthByContext(18),
              offset: Offset(0, context.heightByContext(8)),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(context.widthByContext(14)),
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
      height: context.heightByContext(36),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: context.widthByContext(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < langs.length; i++) ...[
              if (i > 0) Text(' · ', style: AppStyle.style(context.widthByContext(15), color: AppColors.grey1)),
              TextButton(
                onPressed: () => onSelect(langs[i]),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.widthByContext(6),
                    vertical: context.heightByContext(4),
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  langs[i].chipCode,
                  style: AppStyle.style(
                    context.widthByContext(15),
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
      padding: EdgeInsets.symmetric(horizontal: context.widthByContext(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(context.widthByContext(24)),
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
        _pill(context, active: page == 0, orange: orange),
        SizedBox(width: context.widthByContext(10)),
        _pill(context, active: page == 1, orange: orange),
      ],
    );
  }

  Widget _pill(BuildContext context, {required bool active, required Color orange}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: active ? context.widthByContext(36) : context.widthByContext(28),
      height: context.heightByContext(5),
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
    final titleStyle = AppStyle.style(context.widthByContext(22), fontWeight: FontWeight.w700, color: AppColors.black);
    final bodyStyle = AppStyle.style(context.widthByContext(15), height: 1.45, color: AppColors.black);
    final conclusionStyle = AppStyle.style(
      context.widthByContext(16),
      fontWeight: FontWeight.w800,
      color: AppColors.black,
      height: 1.35,
    );

    if (pageIndex == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.onboarding_title, style: titleStyle),
          SizedBox(height: context.heightByContext(12)),
          Text(l10n.onboarding_page1_bullets, style: bodyStyle),
          SizedBox(height: context.heightByContext(14)),
          Text(l10n.onboarding_page1_question, style: bodyStyle),
          SizedBox(height: context.heightByContext(12)),
          Text(l10n.onboarding_page1_conclusion, style: conclusionStyle),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.onboarding_title, style: titleStyle),
        SizedBox(height: context.heightByContext(12)),
        Text(l10n.onboarding_page2_bullet, style: bodyStyle),
        SizedBox(height: context.heightByContext(16)),
        Text(l10n.onboarding_page2_conclusion, style: conclusionStyle),
      ],
    );
  }
}
