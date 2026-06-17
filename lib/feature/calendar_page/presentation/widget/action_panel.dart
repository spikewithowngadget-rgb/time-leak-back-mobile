import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/resources/svg.dart';
import 'package:time_leak_flutter/core/shared/panel_3d.dart';
import 'package:time_leak_flutter/core/shared/responsive.dart';

import '../cubit/calendar_cubit.dart';

class ActionPanel extends StatelessWidget {
  const ActionPanel({super.key});

  Future<void> _openCameraOptions(BuildContext context, CalendarCubit cubit) async {
    final l10n = context.l10n;
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.calendar_cameraSheetTitle,
                style: AppStyle.style(18, fontWeight: FontWeight.w700, color: AppColors.black),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined, color: AppColors.brandColor1),
                title: Text(l10n.calendar_cameraPhoto, style: AppStyle.style(16, fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(ctx, 'photo'),
              ),
              ListTile(
                leading: const Icon(Icons.videocam_outlined, color: AppColors.brandColor1),
                title: Text(l10n.calendar_cameraVideo, style: AppStyle.style(16, fontWeight: FontWeight.w600)),
                onTap: () => Navigator.pop(ctx, 'video'),
              ),
            ],
          ),
        ),
      ),
    );
    if (!context.mounted || choice == null) return;
    if (choice == 'video') {
      await cubit.pickVideoFromCamera();
    } else {
      await cubit.pickImageFromCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CalendarCubit>();

    final hPad = AppResponsive.horizontalPadding(context);
    final iconSize = AppResponsive.isCompact(context) ? 24.0 : 28.0;

    return Container(
      margin: EdgeInsets.fromLTRB(hPad, 16, hPad, 16),
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.isCompact(context) ? 12 : 24,
        vertical: AppResponsive.isCompact(context) ? 12 : 16,
      ),
      decoration: Panel3D.board(surface: AppColors.brandColor, radius: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ActionIcon(
            asset: AppSvg.camera,
            size: iconSize,
            onTap: () => _openCameraOptions(context, cubit),
          ),
          _buildVerticalDivider(iconSize),
          _ActionIcon(asset: AppSvg.micro, size: iconSize, onTap: () => cubit.startRecording()),
          _buildVerticalDivider(iconSize),
          _ActionIcon(asset: AppSvg.photos, size: iconSize, onTap: () => cubit.pickImageFromGallery()),
          _buildVerticalDivider(iconSize),
          _ActionIcon(asset: AppSvg.doc, size: iconSize, onTap: () => cubit.pickDocument()),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider(double iconSize) {
    return Container(width: 1, height: iconSize + 6, color: AppColors.brandColor6);
  }
}

class _ActionIcon extends StatelessWidget {
  final String asset;
  final double size;
  final VoidCallback onTap;

  const _ActionIcon({required this.asset, required this.size, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: Panel3D.board(surface: AppColors.brandColor2, radius: 10),
        child: SvgPicture.asset(asset, height: size, width: size),
      ),
    );
  }
}
