import 'package:flutter/material.dart';

/// Объёмная «доска» для панелей календаря (даты, иконки действий).
abstract final class Panel3D {
  static BoxDecoration board({
    Color surface = const Color(0xFFF5E6D3),
    Color highlight = Colors.white,
    Color shadow = const Color(0x33000000),
    double radius = 10,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [highlight.withValues(alpha: 0.55), surface, surface.withValues(alpha: 0.92)],
      ),
      border: Border.all(color: highlight.withValues(alpha: 0.7), width: 1),
      boxShadow: [
        BoxShadow(color: shadow, blurRadius: 6, offset: const Offset(0, 3)),
        BoxShadow(color: highlight.withValues(alpha: 0.35), blurRadius: 0, offset: const Offset(0, -1)),
      ],
    );
  }
}
