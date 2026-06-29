import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/resources/svg.dart';
import 'package:time_leak_flutter/core/router/app_router.gr.dart';
import 'package:time_leak_flutter/core/shared/responsive.dart';
import 'package:time_leak_flutter/feature/ads/data/model/ad_model.dart';
import 'package:time_leak_flutter/feature/ads/data/repository/ads_repository.dart';
import 'package:time_leak_flutter/feature/calendar_page/data/models/calendar_entry_model.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/cubit/calendar_cubit.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/action_panel.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/audio_player_widget.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/calendar_grid.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/media_item_card.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/reminder_dialog.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/snack_bar.dart';
import 'package:time_leak_flutter/feature/locale/cubit/locale_cubit.dart';
import 'package:time_leak_flutter/feature/pin/presentation/calendar_pin_gate.dart';
import 'package:time_leak_flutter/feature/user/cubit/user_cubit.dart';

@RoutePage()
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CalendarPinGate(
      child: BlocProvider(create: (context) => CalendarCubit(), child: const CalendarView()),
    );
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

  void _onBackPressed(BuildContext context) {
    final cubit = context.read<CalendarCubit>();
    if (cubit.state.clickedDate != null) {
      cubit.clearSelectedDate();
      return;
    }
    if (cubit.state.selectedDate.month > 1 || cubit.state.selectedDate.year > DateTime.now().year) {
      cubit.prevMonth();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _onBackPressed(context);
      },
      child: BlocListener<CalendarCubit, CalendarState>(
        listenWhen: (prev, curr) =>
            curr.entryPendingReminder != null && prev.entryPendingReminder != curr.entryPendingReminder,
        listener: (context, state) async {
          final entry = state.entryPendingReminder!;
          final cubit = context.read<CalendarCubit>();
          final l10n = context.l10n;
          cubit.clearPendingReminder();

          await ReminderDialog.show(
            context,
            entry: entry,
            afterAttach: true,
            onSaved: () {
              if (context.mounted) {
                TopSnackBar.show(
                  context,
                  message: l10n.calendar_status_reminderSaved,
                  duration: const Duration(seconds: 2),
                );
              }
            },
          );
        },
        child: BlocListener<CalendarCubit, CalendarState>(
          listenWhen: (prev, curr) => curr.message != null && prev.message != curr.message,
          listener: (context, state) {
            if (state.message != null) {
              TopSnackBar.show(context, message: state.message!, duration: const Duration(seconds: 2));
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor,
            drawer: const _CalendarDrawer(),
            body: SafeArea(
              bottom: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxContentWidth = AppResponsive.isTablet(context) ? 720.0 : constraints.maxWidth;
                  return Center(
                    child: SizedBox(
                      width: maxContentWidth,
                      height: constraints.maxHeight,
                      child: Column(
                        children: [
                          const CalendarHeaderSection(includeActionPanel: false),
                          const ActionPanel(embeddedInHeader: true),
                          SizedBox(height: context.heightByContext(12)),
                          Expanded(
                            child: BlocSelector<CalendarCubit, CalendarState, bool>(
                              selector: (state) => state.clickedDate != null,
                              builder: (context, hasDate) {
                                if (!hasDate) return const SizedBox.shrink();
                                return const SavedEntriesList();
                              },
                            ),
                          ),
                          const CalendarAdBlock(),
                          // SizedBox(
                          //   height: context.heightByContext(AppResponsive.isCompact(context) ? 12 : 16),
                          // ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Лёгкая анимация иконки меню перед открытием drawer (поворот + лёгкий scale).
class _AnimatedDrawerMenuButton extends StatefulWidget {
  const _AnimatedDrawerMenuButton();

  @override
  State<_AnimatedDrawerMenuButton> createState() => _AnimatedDrawerMenuButtonState();
}

class _AnimatedDrawerMenuButtonState extends State<_AnimatedDrawerMenuButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );
  late final Animation<double> _t = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_controller.isAnimating) return;
    await _controller.forward();
    if (!mounted) return;
    Scaffold.maybeOf(context)?.openDrawer();
    await _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
      onPressed: _handleTap,
      icon: AnimatedBuilder(
        animation: _t,
        builder: (context, child) {
          final v = _t.value;
          return Transform.rotate(
            angle: v * 0.42,
            child: Transform.scale(scale: 1.0 - v * 0.1, child: child),
          );
        },
        child: const Icon(Icons.menu_rounded, color: AppColors.black, size: 28),
      ),
    );
  }
}

/// Компактный wordmark TimeLeak: вся надпись по ширине ≈ буква L в старом SVG,
/// жирный Mulish, слегка приподнят (как WhatsApp в шапке).
class _BrandLogoMark extends StatelessWidget {
  const _BrandLogoMark({this.height = 28});

  final double height;

  /// В SVG month.svg (109×17) буква L заканчивается около x≈56.
  static const double _svgLPosition = 56;

  @override
  Widget build(BuildContext context) {
    final h = context.heightByContext(height);
    final maxW = h * (_svgLPosition / 17);
    final lift = context.heightByContext(height < 20 ? -1.5 : -3);

    return Transform.translate(
      offset: Offset(0, lift),
      child: SizedBox(
        width: maxW,
        height: h,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              'TimeLeak',
              maxLines: 1,
              style: AppStyle.brand(
                h,
                color: AppColors.brandColor1,
                fontWeight: FontWeight.w900,
                height: 1.0,
              ).copyWith(letterSpacing: -0.85),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Боковое меню ---
class _CalendarDrawer extends StatelessWidget {
  const _CalendarDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: AppResponsive.drawerWidth(context),
      backgroundColor: AppColors.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: AppColors.brandColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 4, 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [const _BrandLogoMark(height: 14)],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  leading: const Icon(Icons.info_outline_rounded, color: AppColors.brandColor1, size: 26),
                  title: Text(
                    context.l10n.drawer_about,
                    style: AppStyle.style(
                      context.widthByContext(16),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    context.router.push(const AboutRoute());
                  },
                ),
                SizedBox(height: context.heightByContext(4)),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.widthByContext(16),
                    context.heightByContext(12),
                    context.widthByContext(16),
                    context.heightByContext(6),
                  ),
                  child: Text(
                    context.l10n.drawer_language,
                    style: AppStyle.style(
                      context.widthByContext(13),
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.widthByContext(16)),
                  child: BlocBuilder<LocaleCubit, Locale>(
                    buildWhen: (prev, curr) => prev.languageCode != curr.languageCode,
                    builder: (context, locale) {
                      final current = AppLanguage.values.firstWhere(
                        (e) => e.code == locale.languageCode,
                        orElse: () => AppLanguage.english,
                      );
                      const radius = 14.0;
                      final borderRadius = BorderRadius.circular(radius);
                      final borderIdle = OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: BorderSide(color: AppColors.brandColor1.withValues(alpha: 0.38)),
                      );
                      final borderFocused = OutlineInputBorder(
                        borderRadius: borderRadius,
                        borderSide: const BorderSide(color: AppColors.brandColor1, width: 1.5),
                      );
                      return InputDecorator(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.brandColor,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: borderIdle,
                          enabledBorder: borderIdle,
                          focusedBorder: borderFocused,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<AppLanguage>(
                            value: current,
                            isExpanded: true,
                            borderRadius: borderRadius,
                            dropdownColor: AppColors.backgroundColor,
                            style: AppStyle.style(
                              context.widthByContext(15),
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.brandColor1,
                              size: context.widthByContext(22),
                            ),
                            items: [
                              for (final lang in AppLanguage.values)
                                DropdownMenuItem<AppLanguage>(
                                  value: lang,
                                  child: Text(
                                    lang.label,
                                    style: AppStyle.style(context.widthByContext(15), color: AppColors.black),
                                  ),
                                ),
                            ],
                            onChanged: (v) {
                              if (v != null) context.read<LocaleCubit>().changeLanguage(v);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- СЕКЦИЯ ХЕДЕРА ---
class CalendarHeaderSection extends StatelessWidget {
  const CalendarHeaderSection({super.key, this.includeActionPanel = false});

  /// Панель иконок выносится отдельно, чтобы оставаться видимой под календарём.
  final bool includeActionPanel;

  @override
  Widget build(BuildContext context) {
    final hPad = AppResponsive.horizontalPadding(context);
    final vPad = context.heightByContext(AppResponsive.isCompact(context) ? 18 : 26);

    return Container(
      clipBehavior: Clip.none,
      padding: EdgeInsets.fromLTRB(hPad, 15, hPad, vPad),
      decoration: const BoxDecoration(
        color: AppColors.brandColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(18), bottomRight: Radius.circular(18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [const _BrandLogoMark(), const Spacer(), const _AnimatedDrawerMenuButton()],
          ),
          // SizedBox(height: context.heightByContext(AppResponsive.isCompact(context) ? 12 : 18)),
          const YearListSelector(),
          // SizedBox(height: context.heightByContext(AppResponsive.isCompact(context) ? 8 : 12)),
          const MonthNavigationRow(),
          const RecordingStatusIndicator(),
          const CalendarGrid(),
          if (includeActionPanel) const ActionPanel(embeddedInHeader: true),
        ],
      ),
    );
  }
}

class YearListSelector extends StatefulWidget {
  const YearListSelector({super.key});

  @override
  State<YearListSelector> createState() => _YearListSelectorState();
}

class _YearListSelectorState extends State<YearListSelector> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollYears(int direction) {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset + direction * 120;
    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final startYear = DateTime.now().year;
    final years = List.generate(CalendarCubit.yearsAhead + 1, (i) => startYear + i);

    return BlocBuilder<CalendarCubit, CalendarState>(
      buildWhen: (prev, curr) =>
          prev.selectedDate.year != curr.selectedDate.year ||
          prev.yearsWithNotes != curr.yearsWithNotes ||
          prev.yearBadgeColors != curr.yearBadgeColors,
      builder: (context, state) {
        final selectedYear = state.selectedDate.year;
        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: AppColors.black),
              onPressed: () => _scrollYears(-1),
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: years.map((y) {
                    final isSelected = selectedYear == y;
                    final hasNotes = state.yearsWithNotes.contains(y);
                    final badgeColor = state.yearBadgeColors[y] ?? AppColors.red;
                    return GestureDetector(
                      onTap: () => context.read<CalendarCubit>().selectYear(y),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              right: context.widthByContext(8),
                              bottom: context.heightByContext(6),
                              top: context.heightByContext(6),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: context.widthByContext(12),
                              vertical: context.heightByContext(8),
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.brandColor2 : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.12),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text('$y', style: AppStyle.style(16, fontWeight: FontWeight.bold)),
                          ),
                          if (hasNotes)
                            Positioned(
                              top: context.heightByContext(2),
                              right: context.widthByContext(10),
                              child: Container(
                                width: context.widthByContext(8),
                                height: context.widthByContext(8),
                                decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
                              ),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: AppColors.black),
              onPressed: () => _scrollYears(1),
              visualDensity: VisualDensity.compact,
            ),
          ],
        );
      },
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
            Flexible(
              child: Text(
                monthName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.style(
                  AppResponsive.isCompact(context) ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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

  const _NavButtonWithBadge({required this.icon, required this.showBadge, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(icon: Icon(icon), onPressed: onPressed),
        if (showBadge)
          Positioned(
            top: 4,
            right: icon == Icons.chevron_left ? 4 : null,
            left: icon == Icons.chevron_right ? 4 : null,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: AppColors.red, shape: BoxShape.circle),
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
      buildWhen: (prev, curr) => prev.savedData != curr.savedData,
      builder: (context, state) {
        if (state.savedData.isEmpty) return const SizedBox.shrink();

        return ListView.separated(
          padding: EdgeInsets.only(
            left: AppResponsive.horizontalPadding(context),
            right: AppResponsive.horizontalPadding(context),
            // bottom: context.heightByContext(8),
          ),
          itemCount: state.savedData.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return EntryItemWidget(entry: state.savedData[index]);
          },
        );
      },
    );
  }
}

class EntryItemWidget extends StatelessWidget {
  final CalendarEntryModel entry;

  const EntryItemWidget({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (entry.type == 'audio')
          AudioPlayerWidget(filePath: entry.localPath)
        else
          MediaItemCard(file: File(entry.localPath), type: entry.type),
        EntryActionMenu(entry: entry),
      ],
    );
  }
}

class EntryActionMenu extends StatelessWidget {
  final CalendarEntryModel entry;
  const EntryActionMenu({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CalendarCubit>();
    final l10n = context.l10n;
    final compact = AppResponsive.isCompact(context);
    final iconSize = compact ? 18.0 : 22.0;
    final labelSize = compact ? 10.0 : 12.0;

    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: EdgeInsets.symmetric(vertical: compact ? 8 : 10),
      decoration: BoxDecoration(color: AppColors.brandColor, borderRadius: BorderRadius.circular(10)),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _buildItem(
                AppSvg.trash,
                l10n.calendar_action_delete,
                iconSize,
                labelSize,
                () => cubit.deleteEntry(entry),
              ),
            ),
            _divider(iconSize),
            Expanded(
              child: _buildItem(
                AppSvg.download,
                l10n.calendar_action_download,
                iconSize,
                labelSize,
                () => cubit.downloadEntry(entry),
              ),
            ),
            _divider(iconSize),
            Expanded(
              child: _buildItem(
                AppSvg.calendar,
                l10n.calendar_action_remind,
                iconSize,
                labelSize,
                () => ReminderDialog.show(
                  context,
                  entry: entry,
                  onSaved: () {
                    if (context.mounted) {
                      TopSnackBar.show(
                        context,
                        message: l10n.calendar_status_reminderSaved,
                        duration: const Duration(seconds: 2),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider(double iconSize) => Container(width: 1, color: AppColors.brandColor6);

  Widget _buildItem(String svg, String title, double iconSize, double labelSize, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(svg, height: iconSize),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyle.style(labelSize),
              ),
            ],
          ),
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
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.brandColor2,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                icon: const Icon(Icons.stop_circle_outlined, color: Colors.red),
                onPressed: () => context.read<CalendarCubit>().stopRecording(),
              ),
              Expanded(
                child: Text(
                  context.l10n.calendar_recordingStatus(duration),
                  style: AppStyle.style(15, fontWeight: FontWeight.w600, color: AppColors.black),
                ),
              ),
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

        final hPad = AppResponsive.horizontalPadding(context);
        final adHeight = (AppResponsive.screenWidth(context) * 0.42).clamp(120.0, 180.0);

        return Padding(
          padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 0),
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
                        height: adHeight,
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
