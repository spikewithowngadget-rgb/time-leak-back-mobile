import 'package:flutter/widgets.dart';
import 'package:time_leak_flutter/l10n/app_localizations.dart';

extension L10nExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  static const designWidth = 390.0;
  static const designHeight = 844.0;

  // ==========================================
  // Размеры экрана
  // ==========================================
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  // ==========================================
  // Пропорциональное масштабирование
  // ==========================================

  /// Масштаб по высоте макета: `heightByContext(80)` ≈ 80px при высоте экрана 1000.
  double heightByContext(double designHeightPx) => screenHeight * (designHeightPx / designHeight);

  /// Масштаб по ширине макета: `widthByContext(16)` ≈ 16px при ширине экрана 402.
  double widthByContext(double designWidthPx) => screenWidth * (designWidthPx / designWidth);

  // ==========================================
  // Адаптивность под клавиатуру и системные бары
  // ==========================================

  /// Высота системных вырезов сверху (челка, статус-бар)
  double get topPadding => MediaQuery.paddingOf(this).top;

  /// Высота системного бара снизу (полоска навигации) без учета клавиатуры
  double get bottomPadding => MediaQuery.paddingOf(this).bottom;

  /// Высота, которую занимает клавиатура в данный момент
  double get bottomInset => MediaQuery.viewInsetsOf(this).bottom;

  /// Открыта ли клавиатура прямо сейчас
  bool get isKeyboardOpen => bottomInset > 0;

  /// Полный безопасный отступ снизу.
  /// Если клавиатура открыта — вернет её высоту.
  /// Если закрыта — вернет высоту системной навигационной полоски.
  double get safeBottomPadding => isKeyboardOpen ? bottomInset : bottomPadding;
}
