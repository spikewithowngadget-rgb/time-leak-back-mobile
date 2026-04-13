import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String filePath;
  final VoidCallback onMoreTap;
  final bool isMenuOpen; // Добавляем флаг состояния меню

  const AudioPlayerWidget({
    super.key,
    required this.filePath,
    required this.onMoreTap,
    this.isMenuOpen = false, // По умолчанию закрыто
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _player;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  late final List<double> _waveform;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    final random = Random();
    _waveform = List.generate(45, (i) {
      double multiplier = (i < 5 || i > 40)
          ? 0.3
          : (i < 10 || i > 35)
          ? 0.6
          : 1.0;
      return (random.nextDouble() * 0.7 + 0.3) * multiplier;
    });

    _player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _isPlaying = s == PlayerState.playing);
    });

    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });

    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _playPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play(DeviceFileSource(widget.filePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = _duration.inMilliseconds > 0
        ? _position.inMilliseconds / _duration.inMilliseconds
        : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(color: AppColors.brandColor, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
              color: AppColors.brandColor2,
              size: 26,
            ),
            onPressed: _playPause,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) {
                    final double rel = details.localPosition.dx / constraints.maxWidth;
                    final seekMs = (_duration.inMilliseconds * rel).toInt();
                    _player.seek(Duration(milliseconds: seekMs));
                  },
                  child: SizedBox(
                    height: 40,
                    child: CustomPaint(
                      painter: WaveformPainter(
                        progress: progress,
                        activeColor: AppColors.black,
                        inactiveColor: AppColors.black.withOpacity(0.2),
                        waveform: _waveform,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Text(_formatDuration(_duration - _position), style: AppStyle.style(16, color: AppColors.black)),
          // Меняем иконку в зависимости от переданного состояния
          IconButton(
            icon: Icon(widget.isMenuOpen ? Icons.close : Icons.more_vert, color: AppColors.black),
            onPressed: widget.onMoreTap,
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    if (d.isNegative) return "00:00";
    String two(int n) => n.toString().padLeft(2, "0");
    return "${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}";
  }
}

class WaveformPainter extends CustomPainter {
  final double progress;
  final Color activeColor;
  final Color inactiveColor;
  final List<double> waveform;

  WaveformPainter({
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
    required this.waveform,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final double spacing = size.width / (waveform.length - 1);

    for (int i = 0; i < waveform.length; i++) {
      paint.color = (i / waveform.length) <= progress ? activeColor : inactiveColor;
      final double h = waveform[i] * size.height;
      canvas.drawLine(
        Offset(i * spacing, (size.height - h) / 2),
        Offset(i * spacing, (size.height + h) / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter old) => old.progress != progress;
}
