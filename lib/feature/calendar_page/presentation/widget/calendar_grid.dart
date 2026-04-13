import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';

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

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: calendarDays.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            // Немного уменьшим spacing, так как мы добавим его внутрь GestureDetector
            mainAxisSpacing: 5,
            crossAxisSpacing: 0,
          ),
          itemBuilder: (context, index) {
            final day = calendarDays[index];
            final bool isCurrentMonth = day.month == state.selectedDate.month;
            final bool isSelectedDay =
                state.clickedDate != null &&
                day.year == state.clickedDate!.year &&
                day.month == state.clickedDate!.month &&
                day.day == state.clickedDate!.day;

            // Считаем количество записей для этой конкретной даты
            // Мы ищем в общем списке markedDates (если ты передаешь даты с повторениями)
            // Или лучше использовать state.allEntries, если он есть в стейте
            final int entryCount = state.markedDates
                .where((d) => d.year == day.year && d.month == day.month && d.day == day.day)
                .length;

            final bool hasEntries = entryCount > 0;

            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.read<CalendarCubit>().clickDate(day),
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none, // Позволяет бейджу выходить за границы
                  children: [
                    // Основная цифра даты
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeOutBack,
                      style: AppStyle.style(
                        isSelectedDay ? 34 : 18,
                        fontWeight: isSelectedDay
                            ? FontWeight.w800
                            : (isCurrentMonth ? FontWeight.w600 : FontWeight.w400),
                        color: isSelectedDay
                            ? AppColors.black
                            : (isCurrentMonth ? AppColors.black : AppColors.black.withOpacity(0.4)),
                      ),
                      child: Text('${day.day}'),
                    ),

                    if (hasEntries)
                      Positioned(
                        top: isSelectedDay ? -2 : -5, // Корректируем позицию под размер цифры
                        right: isSelectedDay ? -12 : -13,
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 2),
                          constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          child: Center(
                            child: Text(
                              '$entryCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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

  List<DateTime> _generateCalendarDays(DateTime focusedDate) {
    final firstDayOfMonth = DateTime(focusedDate.year, focusedDate.month, 1);
    final difference = firstDayOfMonth.weekday - 1;
    final startDate = firstDayOfMonth.subtract(Duration(days: difference));
    return List.generate(42, (index) => startDate.add(Duration(days: index)));
  }
}
