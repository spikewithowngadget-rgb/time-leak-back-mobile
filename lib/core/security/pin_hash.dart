import 'dart:convert';

import 'package:crypto/crypto.dart';

String hashAppPin(String pin) {
  const salt = 'time_leak_app_pin_v1';
  final bytes = utf8.encode('$salt|$pin');
  return sha256.convert(bytes).toString();
}
