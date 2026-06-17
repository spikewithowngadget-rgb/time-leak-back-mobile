import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/shared/panel_3d.dart';
import 'package:time_leak_flutter/core/shared/responsive.dart';

import '../cubit/calendar_cubit.dart';

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      buildWhen: (previous, current) =>
          previous.selectedDate != current.selectedDate ||
          previous.clickedDate != current.clickedDate ||
          previous.markedDates != current.markedDates,
      builder: (context, state) {
        final calendarDays = _generateCalendarDays(state.selectedDate);
        final cellWidth = AppResponsive.screenWidth(context) / 7;
        final badgeMinSize = (cellWidth * 0.34).clamp(12.0, 16.0);
        final badgeOffset = (cellWidth * 0.28).clamp(10.0, 14.0);
        final rowHeight = (cellWidth * 1.05).clamp(40.0, 52.0);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: calendarDays.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: AppResponsive.isCompact(context) ? 4 : 6,
            crossAxisSpacing: 4,
            mainAxisExtent: rowHeight,
          ),
          itemBuilder: (context, index) {
            final day = calendarDays[index];
            final bool isCurrentMonth = day.month == state.selectedDate.month;
            final bool isSelectedDay =
                state.clickedDate != null &&
                day.year == state.clickedDate!.year &&
                day.month == state.clickedDate!.month &&
                day.day == state.clickedDate!.day;

            final int entryCount = state.markedDates
                .where((d) => d.year == day.year && d.month == day.month && d.day == day.day)
                .length;

            final bool hasEntries = entryCount > 0;
            final dayFontSize = AppResponsive.calendarDayFontSize(context, selected: isSelectedDay);
            final badgeFontSize = AppResponsive.calendarBadgeFontSize(context);
            final dayLabel = '${day.day}';

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.read<CalendarCubit>().clickDate(day),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: DecoratedBox(
                  decoration: isCurrentMonth
                      ? Panel3D.board(
                          surface: isSelectedDay ? AppColors.brandColor2 : AppColors.brandColor,
                          radius: 8,
                        )
                      : const BoxDecoration(),
                  child: Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              dayLabel,
                              maxLines: 1,
                              style: AppStyle.style(
                                dayFontSize,
                                fontWeight: isSelectedDay
                                    ? FontWeight.w800
                                    : (isCurrentMonth ? FontWeight.w600 : FontWeight.w400),
                                color: isSelectedDay
                                    ? AppColors.black
                                    : (isCurrentMonth
                                        ? AppColors.black
                                        : AppColors.black.withValues(alpha: 0.35)),
                              ),
                            ),
                          ),
                        ),
                        if (hasEntries)
                          Positioned(
                            top: isSelectedDay ? -2 : -4,
                            right: isSelectedDay ? -badgeOffset : -(badgeOffset + 1),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: entryCount > 9 ? 3 : 0,
                                vertical: 1,
                              ),
                              constraints: BoxConstraints(minWidth: badgeMinSize, minHeight: badgeMinSize),
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              child: Center(
                                child: Text(
                                  '$entryCount',
                                  style: AppStyle.style(
                                    badgeFontSize,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
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
