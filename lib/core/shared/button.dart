// Кастомная кнопка
import 'package:flutter/material.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double? height;

  const AppButton({super.key, required this.text, required this.onPressed, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? context.heightByContext(56),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(context.widthByContext(12))),
          elevation: 0,
        ),
        child: Text(
          text,
          style: AppStyle.style(context.widthByContext(18), fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }
}
