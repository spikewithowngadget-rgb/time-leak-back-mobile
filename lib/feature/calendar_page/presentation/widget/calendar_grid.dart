import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/shared/panel_3d.dart';
import 'package:time_leak_flutter/core/shared/responsive.dart';

import '../../data/models/calendar_entry_model.dart';
import '../cubit/calendar_cubit.dart';
import 'calendar_day_badge.dart';

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({super.key});

  static const _crossAxisSpacing = 4.0;
  static const _cellPadding = 2.0;
  static const _badgeOutsetRatio = 0.55;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      buildWhen: (previous, current) =>
          previous.selectedDate != current.selectedDate ||
          previous.clickedDate != current.clickedDate ||
          previous.monthEntries != current.monthEntries,
      builder: (context, state) {
        final calendarDays = _generateCalendarDays(state.selectedDate);
        final mainAxisSpacing = context.heightByContext(AppResponsive.isCompact(context) ? 4 : 6);

        return LayoutBuilder(
          builder: (context, constraints) {
            final gridWidth = constraints.maxWidth;
            final cellWidth = (gridWidth - _crossAxisSpacing * 6) / 7;
            final rowHeight = (cellWidth * 1.05).clamp(40.0, 52.0);
            final badgeMinSize = (cellWidth * 0.48).clamp(18.0, 24.0);
            final badgeFontSize = AppResponsive.calendarBadgeFontSize(context);
            final rows = (calendarDays.length / 7).ceil();
            final gridHeight = rows * rowHeight + (rows > 1 ? (rows - 1) * mainAxisSpacing : 0);
            final badgeOverflow = badgeMinSize * _badgeOutsetRatio;

            return Padding(
              padding: EdgeInsets.only(top: badgeOverflow),
              child: SizedBox(
                height: gridHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: calendarDays.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: mainAxisSpacing,
                      crossAxisSpacing: _crossAxisSpacing,
                      mainAxisExtent: rowHeight,
                    ),
                    itemBuilder: (context, index) {
                      final day = calendarDays[index];
                      return _CalendarDayCell(
                        day: day,
                        selectedMonth: state.selectedDate.month,
                        clickedDate: state.clickedDate,
                        onTap: () => context.read<CalendarCubit>().clickDate(day),
                      );
                    },
                  ),
                  for (var index = 0; index < calendarDays.length; index++)
                    ..._buildBadgeOverlays(
                      index: index,
                      day: calendarDays[index],
                      monthEntries: state.monthEntries,
                      cellWidth: cellWidth,
                      rowHeight: rowHeight,
                      mainAxisSpacing: mainAxisSpacing,
                      badgeMinSize: badgeMinSize,
                      badgeFontSize: badgeFontSize,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static bool _isPastDay(DateTime day) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final cellDay = DateTime(day.year, day.month, day.day);
    return cellDay.isBefore(today);
  }

  List<Widget> _buildBadgeOverlays({
    required int index,
    required DateTime day,
    required List<CalendarEntryModel> monthEntries,
    required double cellWidth,
    required double rowHeight,
    required double mainAxisSpacing,
    required double badgeMinSize,
    required double badgeFontSize,
  }) {
    if (_isPastDay(day)) return const [];

    final dayEntries = monthEntries
        .where((e) => e.date.year == day.year && e.date.month == day.month && e.date.day == day.day)
        .toList();
    if (dayEntries.isEmpty) return const [];

    final col = index % 7;
    final row = index ~/ 7;
    final cellLeft = col * (cellWidth + _crossAxisSpacing);
    final cellTop = row * (rowHeight + mainAxisSpacing);

    final badgeOutset = badgeMinSize * _badgeOutsetRatio;

    return [
      Positioned(
        left: cellLeft + cellWidth - badgeMinSize + badgeOutset,
        top: cellTop - badgeOutset,
        child: _CalendarDayBadge(
          entryCount: dayEntries.length,
          color: calendarDayBadgeColor(dayEntries, day: day),
          minSize: badgeMinSize,
          fontSize: badgeFontSize,
        ),
      ),
    ];
  }

  /// Только недели текущего месяца (без лишних строк соседних месяцев).
  List<DateTime> _generateCalendarDays(DateTime focusedDate) {
    final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
    final daysInMonth = DateTime(focusedDate.year, focusedDate.month + 1, 0).day;
    final startOffset = firstDayOfMonth.weekday - 1;
    final totalCells = startOffset + daysInMonth;
    final weeks = (totalCells / 7).ceil();
    final startDate = firstDayOfMonth.subtract(Duration(days: startOffset));
    return List.generate(weeks * 7, (index) => startDate.add(Duration(days: index)));
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.day,
    required this.selectedMonth,
    required this.clickedDate,
    required this.onTap,
  });

  final DateTime day;
  final int selectedMonth;
  final DateTime? clickedDate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isCurrentMonth = day.month == selectedMonth;
    final isSelectedDay =
        clickedDate != null &&
        day.year == clickedDate!.year &&
        day.month == clickedDate!.month &&
        day.day == clickedDate!.day;
    final dayFontSize = AppResponsive.calendarDayFontSize(context, selected: isSelectedDay);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(CalendarGrid._cellPadding),
        child: DecoratedBox(
          decoration: isCurrentMonth
              ? Panel3D.board(
                  surface: isSelectedDay ? AppColors.brandColor2 : AppColors.brandColor,
                  radius: 8,
                )
              : const BoxDecoration(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${day.day}',
                  maxLines: 1,
                  style: AppStyle.style(
                    dayFontSize,
                    fontWeight: isSelectedDay
                        ? FontWeight.w800
                        : (isCurrentMonth ? FontWeight.w600 : FontWeight.w400),
                    color: isSelectedDay
                        ? AppColors.black
                        : (isCurrentMonth ? AppColors.black : AppColors.black.withValues(alpha: 0.35)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarDayBadge extends StatelessWidget {
  const _CalendarDayBadge({
    required this.entryCount,
    required this.color,
    required this.minSize,
    required this.fontSize,
  });

  final int entryCount;
  final Color color;
  final double minSize;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      color: color,
      shape: const CircleBorder(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: entryCount > 9 ? 4 : 0, vertical: 2),
        constraints: BoxConstraints(minWidth: minSize, minHeight: minSize),
        alignment: Alignment.center,
        child: Text(
          '$entryCount',
          style: AppStyle.style(fontSize, color: Colors.white, fontWeight: FontWeight.bold, height: 1),
        ),
      ),
    );
  }
}
