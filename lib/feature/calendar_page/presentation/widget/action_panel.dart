import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/resources/svg.dart';
import 'package:time_leak_flutter/core/shared/panel_3d.dart';
import 'package:time_leak_flutter/core/shared/responsive.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/cubit/calendar_cubit.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/snack_bar.dart';

class ActionPanel extends StatelessWidget {
  const ActionPanel({super.key, this.embeddedInHeader = false});

  /// В шапке календаря — без боковых отступов (уже есть padding родителя).
  final bool embeddedInHeader;

  bool _ensureDaySelected(BuildContext context, CalendarCubit cubit) {
    if (cubit.state.clickedDate != null) return true;

    final today = DateTime.now();
    final month = cubit.state.selectedDate;
    if (today.year == month.year && today.month == month.month) {
      cubit.clickDate(today);
      return true;
    }

    TopSnackBar.show(context, message: context.l10n.calendar_selectDayFirst);
    return false;
  }

  Future<void> _openCameraOptions(BuildContext context, CalendarCubit cubit) async {
    if (!_ensureDaySelected(context, cubit)) return;

    final l10n = context.l10n;
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.widthByContext(20),
            context.heightByContext(16),
            context.widthByContext(20),
            context.heightByContext(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.calendar_cameraSheetTitle,
                style: AppStyle.style(
                  context.widthByContext(18),
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: context.heightByContext(16)),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined, color: AppColors.brandColor1),
                title: Text(
                  l10n.calendar_cameraPhoto,
                  style: AppStyle.style(context.widthByContext(16), fontWeight: FontWeight.w600),
                ),
                onTap: () => Navigator.pop(ctx, 'photo'),
              ),
              ListTile(
                leading: const Icon(Icons.videocam_outlined, color: AppColors.brandColor1),
                title: Text(
                  l10n.calendar_cameraVideo,
                  style: AppStyle.style(context.widthByContext(16), fontWeight: FontWeight.w600),
                ),
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
    final iconSize = context.widthByContext(AppResponsive.isCompact(context) ? 24 : 28);

    return Container(
      margin: embeddedInHeader
          ? EdgeInsets.only(top: context.heightByContext(2))
          : EdgeInsets.fromLTRB(hPad, context.heightByContext(6), hPad, context.heightByContext(8)),
      padding: EdgeInsets.symmetric(
        horizontal: context.widthByContext(AppResponsive.isCompact(context) ? 12 : 24),
        vertical: context.heightByContext(AppResponsive.isCompact(context) ? 12 : 16),
      ),
      decoration: Panel3D.board(surface: AppColors.brandColor, radius: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ActionIcon(asset: AppSvg.camera, size: iconSize, onTap: () => _openCameraOptions(context, cubit)),
          _buildVerticalDivider(iconSize),
          _ActionIcon(
            asset: AppSvg.micro,
            size: iconSize,
            onTap: () async {
              if (!_ensureDaySelected(context, cubit)) return;
              await cubit.startRecording();
            },
          ),
          _buildVerticalDivider(iconSize),
          _ActionIcon(
            asset: AppSvg.photos,
            size: iconSize,
            onTap: () async {
              if (!_ensureDaySelected(context, cubit)) return;
              await cubit.pickImageFromGallery();
            },
          ),
          _buildVerticalDivider(iconSize),
          _ActionIcon(
            asset: AppSvg.doc,
            size: iconSize,
            onTap: () async {
              if (!_ensureDaySelected(context, cubit)) return;
              await cubit.pickDocument();
            },
          ),
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
        padding: EdgeInsets.all(context.widthByContext(8)),
        decoration: Panel3D.board(surface: AppColors.brandColor2, radius: context.widthByContext(10)),
        child: SvgPicture.asset(asset, height: size, width: size),
      ),
    );
  }
}
