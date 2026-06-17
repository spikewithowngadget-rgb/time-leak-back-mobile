/// Цели OTP (используются в Telegram OTP request и приходят в verify-ответе).
class OtpPurpose {
  static const String registration = 'registration';
  static const String login = 'login';
  static const String passwordReset = 'password_reset';
}

/// Канал доставки OTP.
class OtpChannel {
  static const String whatsapp = 'whatsapp';
  static const String telegram = 'telegram';
}

/// Ответ на запрос OTP. Подходит и для WhatsApp, и для Telegram сценариев:
/// в Telegram дополнительно приходят [telegramDeepLink] и [status].
class OtpRequestResponse {
  final String requestId;
  final int expiresInSeconds;
  final String? telegramDeepLink;
  final String? status;

  OtpRequestResponse({
    required this.requestId,
    required this.expiresInSeconds,
    this.telegramDeepLink,
    this.status,
  });

  factory OtpRequestResponse.fromJson(Map<String, dynamic> json) => OtpRequestResponse(
    requestId: json['request_id'] as String,
    expiresInSeconds: (json['expires_in_seconds'] as num).toInt(),
    telegramDeepLink: json['telegram_deep_link'] as String?,
    status: json['status'] as String?,
  );
}

/// Ответ на верификацию OTP.
/// [purpose] возвращается бэкендом после изменений (registration / login / password_reset).
class OtpVerifyResponse {
  final String verificationToken;
  final String phone;
  final String? purpose;

  OtpVerifyResponse({
    required this.verificationToken,
    required this.phone,
    this.purpose,
  });

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) => OtpVerifyResponse(
    verificationToken: json['verification_token'] as String,
    phone: json['phone'] as String,
    purpose: json['purpose'] as String?,
  );
}

/// Ответ на регистрацию (нам тут важен статус).
class RegisterResponse {
  final String status;
  RegisterResponse({required this.status});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(status: json['status'] as String);
}
