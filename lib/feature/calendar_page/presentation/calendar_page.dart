import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/feature/ads/data/model/ad_model.dart';
import 'package:time_leak_flutter/feature/ads/data/repository/ads_repository.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/resources/svg.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/models/calendar_entry_model.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/repository/synced_notes_repository.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/cubit/calendar_cubit.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/action_panel.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/audio_player_widget.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/calendar_grid.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/media_item_card.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/reminder_dialog.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/snack_bar.dart';
import 'package:time_leak_flutter/feature/user/cubit/user_cubit.dart';

@RoutePage()
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => CalendarCubit(), child: const CalendarView());
  }
}

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  @override
  void initState() {
    super.initState();
    sl<UserCubit>().fetchUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CalendarCubit>().syncFromBackend();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarCubit, CalendarState>(
      listenWhen: (prev, curr) => curr.message != null && prev.message != curr.message,
      listener: (context, state) {
        TopSnackBar.show(context, message: state.message!, duration: const Duration(seconds: 2));
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CalendarHeaderSection(),
                const RecordingStatusIndicator(),
                // Контент ниже показывается только при выбранной дате
                BlocSelector<CalendarCubit, CalendarState, bool>(
                  selector: (state) => state.clickedDate != null,
                  builder: (context, hasDate) {
                    if (!hasDate) return const SizedBox.shrink();
                    return const Column(children: [ActionPanel(), SavedEntriesList()]);
                  },
                ),
                const CalendarAdBlock(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- СЕКЦИЯ ХЕДЕРА ---
class CalendarHeaderSection extends StatelessWidget {
  const CalendarHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
      decoration: const BoxDecoration(
        color: AppColors.brandColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(AppSvg.brand),
          const SizedBox(height: 34),
          const YearListSelector(),
          const SizedBox(height: 23),
          const MonthNavigationRow(),
          const CalendarGrid(),
        ],
      ),
    );
  }
}

class YearListSelector extends StatelessWidget {
  const YearListSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final years = List.generate(5, (i) => DateTime.now().year + i);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: BlocSelector<CalendarCubit, CalendarState, int>(
        selector: (state) => state.selectedDate.year,
        builder: (context, selectedYear) {
          return Row(
            children: years.map((y) {
              final isSelected = selectedYear == y;
              return GestureDetector(
                onTap: () => context.read<CalendarCubit>().selectYear(y),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.brandColor2 : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('$y', style: AppStyle.style(16, fontWeight: FontWeight.bold)),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class MonthNavigationRow extends StatelessWidget {
  const MonthNavigationRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      buildWhen: (prev, curr) =>
          prev.selectedDate != curr.selectedDate ||
          prev.hasNotesInPrevMonth != curr.hasNotesInPrevMonth ||
          prev.hasNotesInNextMonth != curr.hasNotesInNextMonth,
      builder: (context, state) {
        final locale = Localizations.localeOf(context).languageCode;
        String monthName = DateFormat.MMMM(locale).format(state.selectedDate);
        monthName = monthName[0].toUpperCase() + monthName.substring(1);

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavButtonWithBadge(
              icon: Icons.chevron_left,
              showBadge: state.hasNotesInPrevMonth,
              onPressed: () => context.read<CalendarCubit>().prevMonth(),
            ),
            Text(monthName, style: AppStyle.style(18, fontWeight: FontWeight.bold)),
            _NavButtonWithBadge(
              icon: Icons.chevron_right,
              showBadge: state.hasNotesInNextMonth,
              onPressed: () => context.read<CalendarCubit>().nextMonth(),
            ),
          ],
        );
      },
    );
  }
}

class _NavButtonWithBadge extends StatelessWidget {
  final IconData icon;
  final bool showBadge;
  final VoidCallback onPressed;

  const _NavButtonWithBadge({
    required this.icon,
    required this.showBadge,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
        ),
        if (showBadge)
          Positioned(
            top: 4,
            right: icon == Icons.chevron_left ? 4 : null,
            left: icon == Icons.chevron_right ? 4 : null,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

// --- СПИСОК ЗАПИСЕЙ ---
class SavedEntriesList extends StatelessWidget {
  const SavedEntriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      buildWhen: (prev, curr) =>
          prev.savedData != curr.savedData || prev.activeEntryPath != curr.activeEntryPath,
      builder: (context, state) {
        if (state.savedData.isEmpty) return const SizedBox.shrink();

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.savedData.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final entry = state.savedData[index];
            final isMenuOpen = state.activeEntryPath == entry.localPath;

            return EntryItemWidget(entry: entry, isMenuOpen: isMenuOpen);
          },
        );
      },
    );
  }
}

class EntryItemWidget extends StatelessWidget {
  final CalendarEntryModel entry;
  final bool isMenuOpen;

  const EntryItemWidget({super.key, required this.entry, required this.isMenuOpen});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CalendarCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EntryTitleRow(
          entry: entry,
          onSave: (title) => cubit.updateEntryTitle(entry, title),
        ),
        const SizedBox(height: 6),
        if (entry.type == 'audio')
          AudioPlayerWidget(
            filePath: entry.localPath,
            isMenuOpen: isMenuOpen,
            onMoreTap: () => cubit.toggleEntryMenu(entry.localPath),
          )
        else
          MediaItemCard(
            file: File(entry.localPath),
            type: entry.type,
            isMenuOpen: isMenuOpen,
            onMoreTap: () => cubit.toggleEntryMenu(entry.localPath),
          ),
        if (isMenuOpen) EntryActionMenu(entry: entry),
      ],
    );
  }
}

/// Строка с заголовком заметки и кнопкой редактирования.
class EntryTitleRow extends StatefulWidget {
  final CalendarEntryModel entry;
  final ValueChanged<String> onSave;

  const EntryTitleRow({super.key, required this.entry, required this.onSave});

  @override
  State<EntryTitleRow> createState() => _EntryTitleRowState();
}

class _EntryTitleRowState extends State<EntryTitleRow> {
  bool _editing = false;
  late TextEditingController _controller;
  late String _displayTitle;

  @override
  void initState() {
    super.initState();
    _displayTitle = widget.entry.title?.trim().isNotEmpty == true
        ? widget.entry.title!
        : SyncedNotesRepository.defaultTitleFor(widget.entry.date);
    _controller = TextEditingController(text: _displayTitle);
  }

  @override
  void didUpdateWidget(EntryTitleRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.entry.id != widget.entry.id || oldWidget.entry.title != widget.entry.title) {
      _displayTitle = widget.entry.title?.trim().isNotEmpty == true
          ? widget.entry.title!
          : SyncedNotesRepository.defaultTitleFor(widget.entry.date);
      _controller.text = _displayTitle;
      if (_editing) setState(() => _editing = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startEdit() {
    setState(() {
      _editing = true;
      _controller.text = _displayTitle;
      _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
    });
  }

  void _submit() {
    final text = _controller.text.trim();
    setState(() => _editing = false);
    if (text != _displayTitle) widget.onSave(text);
  }

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.brandColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                autofocus: true,
                style: AppStyle.style(16, fontWeight: FontWeight.w600, color: AppColors.black),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 4),
                ),
                onSubmitted: (_) => _submit(),
              ),
            ),
            IconButton(
              onPressed: _submit,
              icon: const Icon(Icons.check_circle, color: AppColors.green),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _displayTitle,
              style: AppStyle.style(16, fontWeight: FontWeight.w600, color: AppColors.black),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: _startEdit,
            icon: Icon(Icons.edit_outlined, size: 20, color: AppColors.black.withOpacity(0.6)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}

class EntryActionMenu extends StatelessWidget {
  final CalendarEntryModel entry;
  const EntryActionMenu({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CalendarCubit>();
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: AppColors.brandColor, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(AppSvg.repeat, 'На Повторе', () {}),
          _divider(),
          _buildItem(AppSvg.trash, 'Удалить', () => cubit.deleteEntry(entry)),
          _divider(),
          _buildItem(AppSvg.download, 'Скачать', () => cubit.downloadEntry(entry)),
          _divider(),
          _buildItem(AppSvg.calendar, 'Напомнить', () => ReminderDialog.show(
                context,
                entry: entry,
                onSaved: () {
                  if (context.mounted) {
                    TopSnackBar.show(context, message: 'Напоминание сохранено', duration: const Duration(seconds: 2));
                  }
                },
              )),
        ],
      ),
    );
  }

  Widget _divider() => Container(height: 44, width: 1, color: AppColors.brandColor6);

  Widget _buildItem(String svg, String title, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        SvgPicture.asset(svg, height: 22),
        Text(title, style: AppStyle.style(12)),
      ],
    ),
  );
}

// --- ИНДИКАТОР ЗАПИСИ ---
class RecordingStatusIndicator extends StatelessWidget {
  const RecordingStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CalendarCubit, CalendarState, (bool, String)>(
      selector: (state) => (state.isRecording, state.recordDuration),
      builder: (context, data) {
        final (isRecording, duration) = data;
        if (!isRecording) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.brandColor, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.stop_circle_outlined, color: Colors.red),
                onPressed: () => context.read<CalendarCubit>().stopRecording(),
              ),
              Text("Запись: $duration"),
            ],
          ),
        );
      },
    );
  }
}

// --- БЛОК РЕКЛАМЫ (снизу после заметок) ---
class CalendarAdBlock extends StatelessWidget {
  const CalendarAdBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AdModel?>(
      future: sl<AdsRepository>().getNextAd(),
      builder: (context, snapshot) {
        final ad = snapshot.data;
        if (ad == null || !ad.isActive || ad.imageUrl.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Material(
              color: AppColors.backgroundColor,
              child: InkWell(
                onTap: () {
                  if (ad.targetUrl.isNotEmpty) {
                    // При необходимости можно добавить url_launcher
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (ad.imageUrl.isNotEmpty)
                      Image.network(
                        ad.imageUrl,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox(height: 120),
                      ),
                    if (ad.title.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          ad.title,
                          style: AppStyle.style(14, color: AppColors.black, fontWeight: FontWeight.w600),
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
  }
}
