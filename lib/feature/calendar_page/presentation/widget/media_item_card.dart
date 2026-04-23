import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/resources/svg.dart';

class MediaItemCard extends StatelessWidget {
  final File file;
  final String type;
  final VoidCallback onMoreTap;
  final bool isMenuOpen; // Добавляем состояние

  const MediaItemCard({
    super.key,
    required this.file,
    required this.type,
    required this.onMoreTap,
    this.isMenuOpen = false, // По умолчанию закрыто
  });

  @override
  Widget build(BuildContext context) {
    final String nameOnly = p.basenameWithoutExtension(file.path);
    final String extension = p.extension(file.path).replaceFirst('.', '');

    return FutureBuilder<String>(
      future: _getFileSize(file),
      builder: (context, snapshot) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppColors.brandColor, borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(type == 'image' ? AppSvg.photo : AppSvg.document, width: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      nameOnly,
                      style: AppStyle.style(16, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  Text(".$extension ", style: AppStyle.style(16, fontWeight: FontWeight.w600)),
                  Text(
                    snapshot.data ?? "",
                    style: AppStyle.style(16, color: AppColors.grey, fontWeight: FontWeight.w600),
                  ),
                  // Кнопка с динамической иконкой
                  IconButton(
                    onPressed: onMoreTap,
                    icon: Icon(isMenuOpen ? Icons.close : Icons.more_vert, color: AppColors.black),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              if (type == 'image') ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    file,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: AppColors.grey.withValues(alpha: 0.2),
                        alignment: Alignment.center,
                        child: Icon(Icons.broken_image_outlined, size: 48, color: AppColors.grey2),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<String> _getFileSize(File file) async {
    try {
      if (await file.exists()) {
        int bytes = await file.length();
        if (bytes <= 0) return "0 B";
        const suffixes = ["B", "KB", "MB", "GB"];
        var i = (log(bytes) / log(1024)).floor();
        return '${(bytes / pow(1024, i)).toStringAsFixed(1)} ${suffixes[i]}';
      }
    } catch (e) {
      return "";
    }
    return "";
  }
}
