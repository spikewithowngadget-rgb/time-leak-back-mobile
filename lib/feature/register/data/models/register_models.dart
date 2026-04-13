// 1. Ответ на запрос OTP
class OtpRequestResponse {
  final String requestId;
  final int expiresInSeconds;

  OtpRequestResponse({required this.requestId, required this.expiresInSeconds});

  factory OtpRequestResponse.fromJson(Map<String, dynamic> json) =>
      OtpRequestResponse(requestId: json['request_id'], expiresInSeconds: json['expires_in_seconds']);
}

// 2. Ответ на верификацию OTP
class OtpVerifyResponse {
  final String verificationToken;
  final String phone;

  OtpVerifyResponse({required this.verificationToken, required this.phone});

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) =>
      OtpVerifyResponse(verificationToken: json['verification_token'], phone: json['phone']);
}

// 3. Ответ на регистрацию (нам тут важен статус)
class RegisterResponse {
  final String status;
  RegisterResponse({required this.status});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(status: json['status']);
}
