import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/snack_bar.dart';
import 'package:video_player/video_player.dart';

const _textExtensions = {
  'txt',
  'md',
  'json',
  'xml',
  'csv',
  'log',
  'ini',
  'yaml',
  'yml',
  'html',
  'htm',
  'dart',
  'js',
  'ts',
  'css',
  'rtf',
};

const _imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'heic', 'heif'};

const _videoExtensions = {'mp4', 'mov', 'avi', 'mkv', 'm4v', 'webm', '3gp'};

/// Открывает медиафайл в приложении или через системное меню «Поделиться / Открыть в…».
class MediaFileOpener {
  static Future<void> open(BuildContext context, {required File file, required String type}) async {
    if (!await file.exists()) {
      if (context.mounted) {
        TopSnackBar.show(context, message: 'File not found', duration: const Duration(seconds: 2));
      }
      return;
    }

    final ext = p.extension(file.path).replaceFirst('.', '').toLowerCase();

    if (type == 'image' || _imageExtensions.contains(ext)) {
      if (!context.mounted) return;
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => _FullScreenImagePage(file: file)));
      return;
    }

    if (type == 'video' || _videoExtensions.contains(ext)) {
      if (!context.mounted) return;
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => _FullScreenVideoPage(file: file)));
      return;
    }

    if (ext == 'pdf') {
      if (!context.mounted) return;
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => _FullScreenPdfPage(file: file)));
      return;
    }

    if (_textExtensions.contains(ext)) {
      if (!context.mounted) return;
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => _FullScreenTextPage(file: file)));
      return;
    }

    if (!context.mounted) return;
    await _openWithSystemSheet(context, file);
  }

  static Future<void> _openWithSystemSheet(BuildContext context, File file) async {
    try {
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)], subject: p.basename(file.path)));
    } catch (_) {
      if (context.mounted) {
        TopSnackBar.show(context, message: 'Could not open file', duration: const Duration(seconds: 2));
      }
    }
  }
}

class _FullScreenImagePage extends StatelessWidget {
  const _FullScreenImagePage({required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black, foregroundColor: Colors.white, elevation: 0),
      body: PhotoView(
        imageProvider: FileImage(file),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 4,
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        errorBuilder: (_, __, ___) =>
            const Center(child: Icon(Icons.broken_image_outlined, color: Colors.white54, size: 64)),
      ),
    );
  }
}

class _FullScreenVideoPage extends StatefulWidget {
  const _FullScreenVideoPage({required this.file});

  final File file;

  @override
  State<_FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<_FullScreenVideoPage> {
  VideoPlayerController? _controller;
  var _failed = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    final controller = VideoPlayerController.file(widget.file);
    _controller = controller;
    try {
      await controller.initialize();
      if (!mounted) return;
      setState(() {});
      await controller.play();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    setState(() {
      controller.value.isPlaying ? controller.pause() : controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          p.basename(widget.file.path),
          style: AppStyle.style(16, fontWeight: FontWeight.w600, color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Center(
        child: _failed
            ? const Icon(Icons.videocam_off_outlined, color: Colors.white54, size: 64)
            : controller == null || !controller.value.isInitialized
            ? const CircularProgressIndicator(color: AppColors.buttonColor)
            : GestureDetector(
                onTap: _togglePlayback,
                child: AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller)),
              ),
      ),
    );
  }
}

class _FullScreenPdfPage extends StatefulWidget {
  const _FullScreenPdfPage({required this.file});

  final File file;

  @override
  State<_FullScreenPdfPage> createState() => _FullScreenPdfPageState();
}

class _FullScreenPdfPageState extends State<_FullScreenPdfPage> {
  late final PdfControllerPinch _controller;

  @override
  void initState() {
    super.initState();
    _controller = PdfControllerPinch(document: PdfDocument.openFile(widget.file.path));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.black,
        elevation: 0,
        title: Text(
          p.basename(widget.file.path),
          style: AppStyle.style(16, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: PdfViewPinch(controller: _controller, padding: 12),
    );
  }
}

class _FullScreenTextPage extends StatelessWidget {
  const _FullScreenTextPage({required this.file});

  final File file;

  Future<String> _loadText() async {
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) return '';
    return utf8.decode(bytes, allowMalformed: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.black,
        elevation: 0,
        title: Text(
          p.basename(file.path),
          style: AppStyle.style(16, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: FutureBuilder<String>(
        future: _loadText(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator(color: AppColors.buttonColor));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              snapshot.data ?? '',
              style: AppStyle.style(15, height: 1.5, color: AppColors.grey2),
            ),
          );
        },
      ),
    );
  }
}
