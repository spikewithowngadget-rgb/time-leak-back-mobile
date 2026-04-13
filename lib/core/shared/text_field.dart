import 'package:flutter/material.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';

// Кастомное текстовое пол
class AppTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? enabled; // 1. Добавляем поле

  const AppTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.enabled, // 2. Добавляем в конструктор
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enabled: enabled, // 3. Передаем в TextField
      style: AppStyle.style(16, color: AppColors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppStyle.style(16, color: AppColors.grey),
        filled: true,
        // Опционально: можно менять цвет фона, если поле заблокировано
        fillColor: (enabled ?? true) ? Colors.white : AppColors.grey1.withOpacity(0.5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey1),
        ),
        disabledBorder: OutlineInputBorder(
          // Добавим стиль для заблокированного состояния
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brandColor1, width: 2),
        ),
      ),
    );
  }
}
