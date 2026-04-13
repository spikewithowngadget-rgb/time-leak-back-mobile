import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';

class TopSnackBar {
  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    Duration animationDuration = const Duration(milliseconds: 260),
  }) {
    // убрать предыдущий, если был
    _timer?.cancel();
    _entry?.remove();
    _entry = null;

    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _TopSnackBarView(
        message: message,
        duration: duration,
        animationDuration: animationDuration,
        onDismissed: () {
          _timer?.cancel();
          entry.remove();
          if (_entry == entry) _entry = null;
        },
      ),
    );

    _entry = entry;
    overlay.insert(entry);
  }
}

class _TopSnackBarView extends StatefulWidget {
  const _TopSnackBarView({
    required this.message,
    required this.duration,
    required this.animationDuration,
    required this.onDismissed,
  });

  final String message;
  final Duration duration;
  final Duration animationDuration;
  final VoidCallback onDismissed;

  @override
  State<_TopSnackBarView> createState() => _TopSnackBarViewState();
}

class _TopSnackBarViewState extends State<_TopSnackBarView> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();

    // старт анимации после первого кадра
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _visible = true);
    });

    // автозакрытие
    Future.delayed(widget.duration, () async {
      if (!mounted) return;
      setState(() => _visible = false);
      await Future.delayed(widget.animationDuration);
      if (mounted) widget.onDismissed();
    });
  }

  @override
  Widget build(BuildContext context) {
    // можно свайпом вверх закрывать
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        top: true,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
            child: Dismissible(
              key: const ValueKey('top_snackbar'),
              direction: DismissDirection.up,
              onDismissed: (_) => widget.onDismissed(),
              child: AnimatedSlide(
                duration: widget.animationDuration,
                curve: Curves.easeOutCubic,
                offset: _visible ? Offset.zero : const Offset(0, -1),
                child: AnimatedOpacity(
                  duration: widget.animationDuration,
                  curve: Curves.easeOutCubic,
                  opacity: _visible ? 1 : 0,
                  child: _SnackContent(message: widget.message),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SnackContent extends StatelessWidget {
  const _SnackContent({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(12),
      color: AppColors.brandColor2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                message,
                style: AppStyle.style(14, color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
