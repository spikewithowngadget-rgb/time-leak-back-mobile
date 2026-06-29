import 'package:flutter/material.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';

// Кастомное текстовое пол
class AppTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? enabled;

  const AppTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.textInputAction,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(context.widthByContext(12));
    final border = OutlineInputBorder(
      borderRadius: radius,
      borderSide: const BorderSide(color: AppColors.grey1),
    );

    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      enabled: enabled,
      style: AppStyle.style(context.widthByContext(16), color: AppColors.black),
      cursorColor: AppColors.brandColor1,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppStyle.style(context.widthByContext(16), color: AppColors.grey),
        filled: true,
        fillColor: (enabled ?? true) ? Colors.white : AppColors.grey1.withValues(alpha: 0.5),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.widthByContext(16),
          vertical: context.heightByContext(18),
        ),
        enabledBorder: border,
        disabledBorder: border,
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.brandColor1, width: 2),
        ),
      ),
    );
  }
}
