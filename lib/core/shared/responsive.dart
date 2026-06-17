import 'package:flutter/material.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';

/// Утилиты адаптивной вёрстки для телефонов и планшетов.
abstract final class AppResponsive {
  static const double formMaxWidth = 440;
  static const double compactWidth = 360;
  static const double tabletWidth = 600;

  static double screenWidth(BuildContext context) => MediaQuery.sizeOf(context).width;

  static double screenHeight(BuildContext context) => MediaQuery.sizeOf(context).height;

  static bool isCompact(BuildContext context) => screenWidth(context) < compactWidth;

  static bool isTablet(BuildContext context) => screenWidth(context) >= tabletWidth;

  static double horizontalPadding(BuildContext context) {
    final w = screenWidth(context);
    if (w >= tabletWidth) return 32;
    if (w < compactWidth) return 16;
    return 24;
  }

  static double titleFontSize(BuildContext context, {double base = 32}) {
    if (isCompact(context)) return base * 0.82;
    if (isTablet(context)) return base * 1.05;
    return base;
  }

  static double subtitleFontSize(BuildContext context, {double base = 16}) {
    if (isCompact(context)) return base * 0.94;
    return base;
  }

  static double sectionSpacing(BuildContext context, {double base = 40}) {
    if (isCompact(context)) return base * 0.7;
    return base;
  }

  static double buttonHeight(BuildContext context) {
    if (isCompact(context)) return 50;
    return 56;
  }

  static double calendarDayFontSize(BuildContext context, {required bool selected}) {
    final cellWidth = screenWidth(context) / 7;
    if (selected) return (cellWidth * 0.48).clamp(18.0, 24.0);
    return (cellWidth * 0.38).clamp(14.0, 18.0);
  }

  static double calendarBadgeFontSize(BuildContext context) {
    final cellWidth = screenWidth(context) / 7;
    return (cellWidth * 0.2).clamp(8.0, 10.0);
  }

  static double drawerWidth(BuildContext context) {
    return (screenWidth(context) * 0.85).clamp(280.0, 320.0);
  }
}

/// Центрированная форма с прокруткой, max-width и учётом клавиатуры.
class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({
    super.key,
    this.appBar,
    required this.children,
    this.bottom,
    this.centerTitle = false,
    this.backgroundColor = AppColors.backgroundColor,
  });

  final PreferredSizeWidget? appBar;
  final List<Widget> children;
  final Widget? bottom;
  final bool centerTitle;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final hPad = context.widthByContext(24);
    final topPad = context.heightByContext(12);
    final bottomPad = context.heightByContext(20) + context.bottomInset;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: appBar,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(hPad, topPad, hPad, bottomPad),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: AppResponsive.formMaxWidth,
                    minHeight: constraints.maxHeight - context.heightByContext(24),
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.stretch,
                      children: [
                        ...children,
                        if (bottom != null) ...[
                          const Spacer(),
                          bottom!,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Заголовок экрана авторизации.
class AuthPageHeader extends StatelessWidget {
  const AuthPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.center = false,
    this.titleSize = 32,
  });

  final String title;
  final String? subtitle;
  final bool center;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    final align = center ? TextAlign.center : TextAlign.start;
    return Column(
      crossAxisAlignment: center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: align,
          style: AppStyle.style(
            context.widthByContext(titleSize),
            fontWeight: FontWeight.w800,
            color: AppColors.black,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: context.heightByContext(8)),
          Text(
            subtitle!,
            textAlign: align,
            style: AppStyle.style(
              context.widthByContext(16),
              color: AppColors.grey2,
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}
