import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:time_leak_flutter/core/dependencies/injection.dart';
import 'package:time_leak_flutter/core/extension/l10n_ext.dart';
import 'package:time_leak_flutter/core/resources/colors.dart';
import 'package:time_leak_flutter/core/resources/png.dart';
import 'package:time_leak_flutter/core/resources/style.dart';
import 'package:time_leak_flutter/core/security/pin_hash.dart';
import 'package:time_leak_flutter/core/security/pin_session.dart';
import 'package:time_leak_flutter/core/storage/app_database.dart';
import 'package:time_leak_flutter/feature/calendar_page/presentation/widget/snack_bar.dart';

enum _PinStep { setupNew, setupConfirm, unlock }

/// Показывает экран PIN перед календарём: первый раз — создание кода, далее — ввод.
class CalendarPinGate extends StatefulWidget {
  const CalendarPinGate({super.key, required this.child});

  final Widget child;

  @override
  State<CalendarPinGate> createState() => _CalendarPinGateState();
}

class _CalendarPinGateState extends State<CalendarPinGate> with WidgetsBindingObserver {
  static const _pinLen = 4;
  static const _inactivityLock = Duration(minutes: 1);
  static const _mintBg = Color(0xFFEFFEF0);
  static const _dotEmpty = Color(0xFFE8DDD0);
  static const _titleGrey = Color(0xFF9E9E9E);

  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _loading = true;
  bool _showChild = false;
  _PinStep? _step;
  String _buffer = '';
  String? _firstPin;
  String? _storedHash;
  bool _biometricAvailable = false;
  List<BiometricType> _biometrics = const [];
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bootstrap();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _lockFromInactivity();
    }
  }

  void _lockFromInactivity() {
    if (!_showChild || _storedHash == null) return;
    PinSession.lock();
    setState(() {
      _showChild = false;
      _step = _PinStep.unlock;
      _buffer = '';
    });
    _inactivityTimer?.cancel();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    if (!_showChild) return;
    _inactivityTimer = Timer(_inactivityLock, _lockFromInactivity);
  }

  Future<void> _bootstrap() async {
    final db = sl<AppDatabase>();
    final hash = await db.getPinHash();
    _storedHash = hash;
    try {
      _biometricAvailable = await _localAuth.canCheckBiometrics && await _localAuth.isDeviceSupported();
      if (_biometricAvailable) {
        _biometrics = await _localAuth.getAvailableBiometrics();
      }
    } catch (_) {
      _biometricAvailable = false;
      _biometrics = const [];
    }
    if (!mounted) return;
    if (PinSession.calendarUnlocked) {
      setState(() {
        _loading = false;
        _showChild = true;
      });
      _resetInactivityTimer();
      return;
    }
    setState(() {
      _loading = false;
      if (hash == null || hash.isEmpty) {
        _step = _PinStep.setupNew;
      } else {
        _step = _PinStep.unlock;
      }
    });
    if (_step == _PinStep.unlock && _biometricAvailable) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometricUnlock(silent: true));
    }
  }

  Future<void> _tryBiometricUnlock({bool silent = false}) async {
    if (_step != _PinStep.unlock || _storedHash == null) return;
    try {
      final ok = await _localAuth.authenticate(
        localizedReason: context.l10n.pin_biometricReason,
        options: const AuthenticationOptions(biometricOnly: true, stickyAuth: true),
      );
      if (!mounted) return;
      if (ok) {
        PinSession.unlock();
        setState(() {
          _showChild = true;
          _step = null;
          _buffer = '';
        });
        _resetInactivityTimer();
      }
    } on PlatformException catch (_) {
      if (!silent && mounted) {
        TopSnackBar.show(context, message: context.l10n.pin_wrongCode);
      }
    }
  }

  void _onDigit(String d) {
    if (_buffer.length >= _pinLen) return;
    final next = _buffer + d;
    setState(() => _buffer = next);
    if (next.length == _pinLen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _onPinComplete());
    }
  }

  void _onBackspace() {
    if (_buffer.isEmpty) return;
    setState(() => _buffer = _buffer.substring(0, _buffer.length - 1));
  }

  Future<void> _onPinComplete() async {
    final db = sl<AppDatabase>();
    final pin = _buffer;
    setState(() => _buffer = '');

    switch (_step!) {
      case _PinStep.setupNew:
        setState(() {
          _firstPin = pin;
          _step = _PinStep.setupConfirm;
        });
        break;
      case _PinStep.setupConfirm:
        if (pin != _firstPin) {
          if (mounted) {
            TopSnackBar.show(context, message: context.l10n.pin_codesDoNotMatch);
          }
          setState(() {
            _step = _PinStep.setupNew;
            _firstPin = null;
          });
        } else {
          await db.setPinHash(hashAppPin(pin));
          _storedHash = hashAppPin(pin);
          PinSession.unlock();
          if (mounted) {
            setState(() {
              _showChild = true;
              _step = null;
            });
            _resetInactivityTimer();
          }
        }
        break;
      case _PinStep.unlock:
        if (hashAppPin(pin) == _storedHash) {
          PinSession.unlock();
          if (mounted) {
            setState(() {
              _showChild = true;
              _step = null;
            });
            _resetInactivityTimer();
          }
        } else {
          HapticFeedback.mediumImpact();
          if (mounted) {
            TopSnackBar.show(context, message: context.l10n.pin_wrongCode);
          }
        }
        break;
    }
  }

  String _title(BuildContext context) {
    switch (_step!) {
      case _PinStep.setupNew:
        return context.l10n.pin_createCode;
      case _PinStep.setupConfirm:
        return context.l10n.pin_confirmCode;
      case _PinStep.unlock:
        return context.l10n.pin_accessCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: _mintBg,
        body: const Center(child: CircularProgressIndicator(color: AppColors.buttonColor)),
      );
    }
    if (_showChild) {
      return Listener(
        onPointerDown: (_) => _resetInactivityTimer(),
        child: widget.child,
      );
    }
    return Scaffold(
      backgroundColor: _mintBg,
      body: SafeArea(
        child: Column(
          children: [
            // Верхний заголовок скрыт — как в макете.
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.10),
                          blurRadius: 18,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(AppPng.brand, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 36),
                  Text(_title(context), style: AppStyle.style(16, color: _titleGrey)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pinLen, (i) {
                      final filled = i < _buffer.length;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: filled ? AppColors.buttonColor : _dotEmpty,
                            border: Border.all(
                              color: filled ? AppColors.buttonColor : const Color(0xFFD9CEC0),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            _Keypad(
              showBiometric: _step == _PinStep.unlock && _biometricAvailable,
              biometrics: _biometrics,
              onDigit: _onDigit,
              onBackspace: _onBackspace,
              onBiometric: () => _tryBiometricUnlock(silent: false),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.onDigit,
    required this.onBackspace,
    required this.showBiometric,
    required this.biometrics,
    required this.onBiometric,
  });

  static const double _cellHeight = 64;
  static const double _digitFontSize = 28;
  static const double _rowGap = 14;
  static const BorderRadius _tapRadius = BorderRadius.all(Radius.circular(16));

  final void Function(String) onDigit;
  final VoidCallback onBackspace;
  final bool showBiometric;
  final List<BiometricType> biometrics;
  final VoidCallback onBiometric;

  Widget _tapCell({required VoidCallback? onTap, required Widget child}) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: _tapRadius,
          splashColor: AppColors.brandColor2.withValues(alpha: 0.45),
          highlightColor: AppColors.brandColor1.withValues(alpha: 0.14),
          splashFactory: InkRipple.splashFactory,
          child: SizedBox(height: _cellHeight, child: Center(child: child)),
        ),
      ),
    );
  }

  Widget _digitCell(String d) {
    return _tapCell(
      onTap: () => onDigit(d),
      child: Text(
        d,
        style: AppStyle.style(
          _digitFontSize,
          color: AppColors.black,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      ),
    );
  }

  IconData _biometricIcon() {
    if (biometrics.contains(BiometricType.fingerprint) ||
        biometrics.contains(BiometricType.strong) ||
        biometrics.contains(BiometricType.weak)) {
      return Icons.fingerprint_rounded;
    }
    return Icons.face_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      child: Column(
        children: [
          for (final row in [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: _rowGap),
              child: Row(children: [for (final d in row) _digitCell(d)]),
            ),
          Row(
            children: [
              showBiometric
                  ? _tapCell(
                      onTap: onBiometric,
                      child: Icon(_biometricIcon(), size: 30, color: AppColors.grey2),
                    )
                  : const Expanded(child: SizedBox(height: _cellHeight)),
              _digitCell('0'),
              _tapCell(
                onTap: onBackspace,
                child: Icon(Icons.backspace_outlined, size: 24, color: AppColors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
