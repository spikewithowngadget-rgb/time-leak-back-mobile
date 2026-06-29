import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:pdfx/pdfx.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/style.dart';

const _textExtensions = {
  'txt', 'md', 'json', 'xml', 'csv', 'log', 'ini', 'yaml', 'yml', 'html', 'htm',
  'dart', 'js', 'ts', 'css', 'rtf',
};

const _imageExtensions = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'heic', 'heif'};

const _maxPreviewChars = 2500;

enum _DocumentPreviewKind { text, image, pdf, unsupported }

_DocumentPreviewKind _previewKindForExtension(String extension) {
  final ext = extension.toLowerCase();
  if (_imageExtensions.contains(ext)) return _DocumentPreviewKind.image;
  if (ext == 'pdf') return _DocumentPreviewKind.pdf;
  if (_textExtensions.contains(ext)) return _DocumentPreviewKind.text;
  return _DocumentPreviewKind.unsupported;
}

/// Превью содержимого документа под карточкой файла.
class DocumentContentPreview extends StatelessWidget {
  const DocumentContentPreview({super.key, required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    final extension = p.extension(file.path).replaceFirst('.', '');
    final kind = _previewKindForExtension(extension);

    return switch (kind) {
      _DocumentPreviewKind.image => _ImagePreview(file: file),
      _DocumentPreviewKind.text => _TextPreview(file: file),
      _DocumentPreviewKind.pdf => _PdfPreview(file: file),
      _DocumentPreviewKind.unsupported => const SizedBox.shrink(),
    };
  }
}

class _PreviewFrame extends StatelessWidget {
  const _PreviewFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: 240),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          border: Border.all(color: AppColors.brandColor6.withValues(alpha: 0.6)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return _PreviewFrame(
      child: Image.file(
        file,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _PreviewError(icon: Icons.broken_image_outlined),
      ),
    );
  }
}

class _TextPreview extends StatelessWidget {
  const _TextPreview({required this.file});

  final File file;

  Future<String?> _loadText() async {
    if (!await file.exists()) return null;
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) return '';
    final chunk = bytes.length > 512 * 1024 ? bytes.sublist(0, 512 * 1024) : bytes;
    return utf8.decode(chunk, allowMalformed: true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _loadText(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _PreviewFrame(
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.buttonColor),
              ),
            ),
          );
        }

        final raw = snapshot.data;
        if (raw == null) return const _PreviewError(icon: Icons.description_outlined);

        var text = raw;
        if (text.length > _maxPreviewChars) {
          text = '${text.substring(0, _maxPreviewChars)}…';
        }

        return _PreviewFrame(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              text,
              style: AppStyle.style(13, height: 1.45, color: AppColors.grey2),
            ),
          ),
        );
      },
    );
  }
}

class _PdfPreview extends StatefulWidget {
  const _PdfPreview({required this.file});

  final File file;

  @override
  State<_PdfPreview> createState() => _PdfPreviewState();
}

class _PdfPreviewState extends State<_PdfPreview> {
  PdfControllerPinch? _controller;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _controller = PdfControllerPinch(document: PdfDocument.openFile(widget.file.path));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed || _controller == null) {
      return _PdfPlaceholder(file: widget.file);
    }

    return _PreviewFrame(
      child: SizedBox(
        height: 220,
        child: PdfViewPinch(
          controller: _controller!,
          padding: 8,
          onDocumentError: (_) {
            if (mounted) setState(() => _failed = true);
          },
        ),
      ),
    );
  }
}

class _PdfPlaceholder extends StatelessWidget {
  const _PdfPlaceholder({required this.file});

  final File file;

  @override
  Widget build(BuildContext context) {
    return _PreviewFrame(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.picture_as_pdf_rounded, size: 48, color: AppColors.brandColor1),
            const SizedBox(height: 8),
            Text(
              p.basename(file.path),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.style(13, fontWeight: FontWeight.w600, color: AppColors.black),
            ),
            const SizedBox(height: 4),
            Text('PDF', style: AppStyle.style(12, color: AppColors.grey2)),
          ],
        ),
      ),
    );
  }
}

class _PreviewError extends StatelessWidget {
  const _PreviewError({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _PreviewFrame(
      child: Center(
        child: Icon(icon, size: 40, color: AppColors.grey1),
      ),
    );
  }
}
