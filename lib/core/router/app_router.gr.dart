// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:flutter/material.dart' as _i12;
import 'package:time_leak_flutter/feature/about/presentation/about_page.dart'
    as _i1;
import 'package:time_leak_flutter/feature/calendar_page/presentation/calendar_page.dart'
    as _i2;
import 'package:time_leak_flutter/feature/login/presentation/page/login_page.dart'
    as _i5;
import 'package:time_leak_flutter/feature/on_boarding_page/on_boarding_page.dart'
    as _i6;
import 'package:time_leak_flutter/feature/register/presentation/page/register_password_page.dart'
    as _i7;
import 'package:time_leak_flutter/feature/register/presentation/page/register_phone_page.dart'
    as _i8;
import 'package:time_leak_flutter/feature/register/presentation/page/register_verify_page.dart'
    as _i9;
import 'package:time_leak_flutter/feature/reset_password/presentation/page/create_new_password_page.dart'
    as _i3;
import 'package:time_leak_flutter/feature/reset_password/presentation/page/forgot_password_page.dart'
    as _i4;
import 'package:time_leak_flutter/feature/reset_password/presentation/page/reset_verify_page.dart'
    as _i10;

/// generated route for
/// [_i1.AboutPage]
class AboutRoute extends _i11.PageRouteInfo<void> {
  const AboutRoute({List<_i11.PageRouteInfo>? children})
    : super(AboutRoute.name, initialChildren: children);

  static const String name = 'AboutRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutPage();
    },
  );
}

/// generated route for
/// [_i2.CalendarPage]
class CalendarRoute extends _i11.PageRouteInfo<void> {
  const CalendarRoute({List<_i11.PageRouteInfo>? children})
    : super(CalendarRoute.name, initialChildren: children);

  static const String name = 'CalendarRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i2.CalendarPage();
    },
  );
}

/// generated route for
/// [_i3.CreateNewPasswordPage]
class CreateNewPasswordRoute
    extends _i11.PageRouteInfo<CreateNewPasswordRouteArgs> {
  CreateNewPasswordRoute({
    _i12.Key? key,
    required String token,
    required String phone,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         CreateNewPasswordRoute.name,
         args: CreateNewPasswordRouteArgs(key: key, token: token, phone: phone),
         initialChildren: children,
       );

  static const String name = 'CreateNewPasswordRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateNewPasswordRouteArgs>();
      return _i3.CreateNewPasswordPage(
        key: args.key,
        token: args.token,
        phone: args.phone,
      );
    },
  );
}

class CreateNewPasswordRouteArgs {
  const CreateNewPasswordRouteArgs({
    this.key,
    required this.token,
    required this.phone,
  });

  final _i12.Key? key;

  final String token;

  final String phone;

  @override
  String toString() {
    return 'CreateNewPasswordRouteArgs{key: $key, token: $token, phone: $phone}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CreateNewPasswordRouteArgs) return false;
    return key == other.key && token == other.token && phone == other.phone;
  }

  @override
  int get hashCode => key.hashCode ^ token.hashCode ^ phone.hashCode;
}

/// generated route for
/// [_i4.ForgotPasswordPage]
class ForgotPasswordRoute extends _i11.PageRouteInfo<void> {
  const ForgotPasswordRoute({List<_i11.PageRouteInfo>? children})
    : super(ForgotPasswordRoute.name, initialChildren: children);

  static const String name = 'ForgotPasswordRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i4.ForgotPasswordPage();
    },
  );
}

/// generated route for
/// [_i5.LoginPage]
class LoginRoute extends _i11.PageRouteInfo<void> {
  const LoginRoute({List<_i11.PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i5.LoginPage();
    },
  );
}

/// generated route for
/// [_i6.OnBoardingPage]
class OnBoardingRoute extends _i11.PageRouteInfo<void> {
  const OnBoardingRoute({List<_i11.PageRouteInfo>? children})
    : super(OnBoardingRoute.name, initialChildren: children);

  static const String name = 'OnBoardingRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i6.OnBoardingPage();
    },
  );
}

/// generated route for
/// [_i7.RegisterPasswordPage]
class RegisterPasswordRoute
    extends _i11.PageRouteInfo<RegisterPasswordRouteArgs> {
  RegisterPasswordRoute({
    _i12.Key? key,
    required String phone,
    required String verificationToken,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         RegisterPasswordRoute.name,
         args: RegisterPasswordRouteArgs(
           key: key,
           phone: phone,
           verificationToken: verificationToken,
         ),
         initialChildren: children,
       );

  static const String name = 'RegisterPasswordRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegisterPasswordRouteArgs>();
      return _i7.RegisterPasswordPage(
        key: args.key,
        phone: args.phone,
        verificationToken: args.verificationToken,
      );
    },
  );
}

class RegisterPasswordRouteArgs {
  const RegisterPasswordRouteArgs({
    this.key,
    required this.phone,
    required this.verificationToken,
  });

  final _i12.Key? key;

  final String phone;

  final String verificationToken;

  @override
  String toString() {
    return 'RegisterPasswordRouteArgs{key: $key, phone: $phone, verificationToken: $verificationToken}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RegisterPasswordRouteArgs) return false;
    return key == other.key &&
        phone == other.phone &&
        verificationToken == other.verificationToken;
  }

  @override
  int get hashCode =>
      key.hashCode ^ phone.hashCode ^ verificationToken.hashCode;
}

/// generated route for
/// [_i8.RegisterPhonePage]
class RegisterPhoneRoute extends _i11.PageRouteInfo<void> {
  const RegisterPhoneRoute({List<_i11.PageRouteInfo>? children})
    : super(RegisterPhoneRoute.name, initialChildren: children);

  static const String name = 'RegisterPhoneRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      return const _i8.RegisterPhonePage();
    },
  );
}

/// generated route for
/// [_i9.RegisterVerifyPage]
class RegisterVerifyRoute extends _i11.PageRouteInfo<RegisterVerifyRouteArgs> {
  RegisterVerifyRoute({
    _i12.Key? key,
    required String requestId,
    required String phone,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         RegisterVerifyRoute.name,
         args: RegisterVerifyRouteArgs(
           key: key,
           requestId: requestId,
           phone: phone,
         ),
         initialChildren: children,
       );

  static const String name = 'RegisterVerifyRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<RegisterVerifyRouteArgs>();
      return _i9.RegisterVerifyPage(
        key: args.key,
        requestId: args.requestId,
        phone: args.phone,
      );
    },
  );
}

class RegisterVerifyRouteArgs {
  const RegisterVerifyRouteArgs({
    this.key,
    required this.requestId,
    required this.phone,
  });

  final _i12.Key? key;

  final String requestId;

  final String phone;

  @override
  String toString() {
    return 'RegisterVerifyRouteArgs{key: $key, requestId: $requestId, phone: $phone}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! RegisterVerifyRouteArgs) return false;
    return key == other.key &&
        requestId == other.requestId &&
        phone == other.phone;
  }

  @override
  int get hashCode => key.hashCode ^ requestId.hashCode ^ phone.hashCode;
}

/// generated route for
/// [_i10.ResetVerifyPage]
class ResetVerifyRoute extends _i11.PageRouteInfo<ResetVerifyRouteArgs> {
  ResetVerifyRoute({
    _i12.Key? key,
    required String requestId,
    required String phone,
    List<_i11.PageRouteInfo>? children,
  }) : super(
         ResetVerifyRoute.name,
         args: ResetVerifyRouteArgs(
           key: key,
           requestId: requestId,
           phone: phone,
         ),
         initialChildren: children,
       );

  static const String name = 'ResetVerifyRoute';

  static _i11.PageInfo page = _i11.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResetVerifyRouteArgs>();
      return _i10.ResetVerifyPage(
        key: args.key,
        requestId: args.requestId,
        phone: args.phone,
      );
    },
  );
}

class ResetVerifyRouteArgs {
  const ResetVerifyRouteArgs({
    this.key,
    required this.requestId,
    required this.phone,
  });

  final _i12.Key? key;

  final String requestId;

  final String phone;

  @override
  String toString() {
    return 'ResetVerifyRouteArgs{key: $key, requestId: $requestId, phone: $phone}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ResetVerifyRouteArgs) return false;
    return key == other.key &&
        requestId == other.requestId &&
        phone == other.phone;
  }

  @override
  int get hashCode => key.hashCode ^ requestId.hashCode ^ phone.hashCode;
}
