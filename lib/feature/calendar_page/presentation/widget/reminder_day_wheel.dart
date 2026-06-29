import 'package:flutter/material.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';

const int reminderMinDays = 1;
const int reminderMaxDays = 100;

/// Горизонтальное «рулевое колесо» для выбора числа дней (1–100).
class ReminderDayWheel extends StatefulWidget {
  const ReminderDayWheel({
    super.key,
    required this.selectedDays,
    required this.onChanged,
  });

  final int selectedDays;
  final ValueChanged<int> onChanged;

  @override
  State<ReminderDayWheel> createState() => ReminderDayWheelState();
}

class ReminderDayWheelState extends State<ReminderDayWheel> {
  static const double _itemWidth = 80;
  static const double _wheelHeight = 88;
  static const double _highlightWidth = 88;

  late final ScrollController _controller;
  late int _selectedDays;
  bool _snapping = false;
  bool _scrollingFromExternal = false;

  @override
  void initState() {
    super.initState();
    _selectedDays = widget.selectedDays.clamp(reminderMinDays, reminderMaxDays);
    _controller = ScrollController(initialScrollOffset: (_selectedDays - reminderMinDays) * _itemWidth);
    _controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(ReminderDayWheel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDays == widget.selectedDays || _snapping) return;

    final clamped = widget.selectedDays.clamp(reminderMinDays, reminderMaxDays);
    if (clamped != _selectedDays) {
      _selectedDays = clamped;
      _scrollToDays(clamped, animate: true);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients || _snapping || _scrollingFromExternal) return;
    final index = (_controller.offset / _itemWidth).round().clamp(0, reminderMaxDays - reminderMinDays);
    final days = index + reminderMinDays;
    if (days != _selectedDays) {
      setState(() => _selectedDays = days);
      widget.onChanged(days);
    } else {
      setState(() {});
    }
  }

  Future<void> _scrollToDays(int days, {bool animate = false}) async {
    if (!_controller.hasClients) return;
    final index = days.clamp(reminderMinDays, reminderMaxDays) - reminderMinDays;
    final target = index * _itemWidth;
    _scrollingFromExternal = true;
    if (animate) {
      await _controller.animateTo(
        target,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
    } else {
      _controller.jumpTo(target);
    }
    _scrollingFromExternal = false;
  }

  Future<void> _snapToNearest() async {
    if (!_controller.hasClients || _snapping) return;
    final index = (_controller.offset / _itemWidth).round().clamp(0, reminderMaxDays - reminderMinDays);
    _snapping = true;
    await _controller.animateTo(
      index * _itemWidth,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
    _snapping = false;
    if (!mounted) return;
    final days = index + reminderMinDays;
    if (days != _selectedDays) {
      setState(() => _selectedDays = days);
      widget.onChanged(days);
    }
  }

  double _itemCenterXContent(int index, double sidePadding) {
    return sidePadding + index * _itemWidth + _itemWidth / 2;
  }

  double _viewportCenterContent(double viewportWidth) {
    if (!_controller.hasClients) {
      final index = _selectedDays - reminderMinDays;
      final sidePadding = (viewportWidth - _itemWidth) / 2;
      return _itemCenterXContent(index, sidePadding);
    }
    return _controller.offset + viewportWidth / 2;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth;
        final sidePadding = (viewportWidth - _itemWidth) / 2;
        final centerXContent = _viewportCenterContent(viewportWidth);

        return SizedBox(
          height: _wheelHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              NotificationListener<ScrollEndNotification>(
                onNotification: (_) {
                  _snapToNearest();
                  return false;
                },
                child: ListView.builder(
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: sidePadding),
                  itemCount: reminderMaxDays - reminderMinDays + 1,
                  itemBuilder: (context, index) {
                    final days = index + reminderMinDays;
                    final itemCenter = _itemCenterXContent(index, sidePadding);
                    final distance = (itemCenter - centerXContent).abs() / _itemWidth;
                    final opacity = (1.0 - distance * 0.38).clamp(0.18, 1.0);
                    final scale = (1.0 - distance * 0.18).clamp(0.72, 1.0);
                    final isCenter = distance < 0.45;
                    final fontSize = isCenter ? 34.0 : 22.0;

                    return SizedBox(
                      width: _itemWidth,
                      child: Center(
                        child: Opacity(
                          opacity: opacity,
                          child: Transform.scale(
                            scale: scale,
                            child: SizedBox(
                              width: _itemWidth - 4,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '$days',
                                  maxLines: 1,
                                  softWrap: false,
                                  style: AppStyle.style(
                                    fontSize,
                                    fontWeight: isCenter ? FontWeight.w800 : FontWeight.w500,
                                    color: AppColors.black,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              IgnorePointer(
                child: Row(
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.backgroundColor,
                              AppColors.backgroundColor.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: _highlightWidth),
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.backgroundColor.withValues(alpha: 0),
                              AppColors.backgroundColor,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IgnorePointer(
                child: Container(
                  width: _highlightWidth,
                  height: _wheelHeight - 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.brandColor1.withValues(alpha: 0.35)),
                    color: AppColors.brandColor.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
