import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/svg.dart';

import '../cubit/calendar_cubit.dart';

class ActionPanel extends StatelessWidget {
  const ActionPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CalendarCubit>();

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
      // Уменьшаем горизонтальный padding родителя, так как мы добавили его внутрь иконок
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.brandColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ActionIcon(asset: AppSvg.camera, onTap: () => cubit.pickImageFromCamera()),
          _buildVerticalDivider(),
          _ActionIcon(asset: AppSvg.micro, onTap: () => cubit.startRecording()),
          _buildVerticalDivider(),
          _ActionIcon(asset: AppSvg.photos, onTap: () => cubit.pickImageFromGallery()),
          _buildVerticalDivider(),
          _ActionIcon(asset: AppSvg.doc, onTap: () => cubit.pickDocument()),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, height: 34, color: AppColors.brandColor6);
  }
}

class _ActionIcon extends StatelessWidget {
  final String asset;
  final VoidCallback onTap;

  const _ActionIcon({required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        // Добавляем невидимую область вокруг иконки
        // padding: const EdgeInsets.all(12),
        // Сама иконка остается 32x32
        child: SvgPicture.asset(asset, height: 28, width: 28),
      ),
    );
  }
}
