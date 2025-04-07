import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:teste/api/api_product.dart';

import '../models/profile.dart';
import './api_interceptor_web.dart' if (dart.library.io) './api_interceptor_web.dart';
import 'api_account.dart';
import 'api_login.dart';
import 'api_register.dart';
import 'api_forgot_password.dart';
import 'api_profile.dart';

const String BASE_URL = String.fromEnvironment(
  'API',
  defaultValue: 'https://estagio.almt.app',
);

class API {
  Dio dio = Dio(BaseOptions(
    baseUrl: BASE_URL,
    connectTimeout: const Duration(minutes: 5),
    receiveTimeout: const Duration(minutes: 5),
    headers: <String, String>{
      "Accept": "application/json",
      'Content-type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    },
  ));
  final CookieInterceptor _cookies = CookieInterceptor();

  static API instance = API();

  static LoginAPI get login => instance._login;
  static RegisterAPI get signup => instance._signup;
  static ForgotPasswordAPI get forgotPassword => instance._forgotPassword;
  static UserAPI get user => instance._user;
  static ProductAPI get createProduct => instance._product;
  static UserAPI get users => instance._users;
  static AccountAPI get accounts => instance._accounts;


  late LoginAPI _login;
  late RegisterAPI _signup;
  late ForgotPasswordAPI _forgotPassword;
  late UserAPI _user;
  late ProductAPI _product;
  late UserAPI _users;
  late AccountAPI _accounts;

  API() {
    dio.interceptors.add(_cookies);
    // Aceite de erro de certificado SSL
    if (!kIsWeb) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () => HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) {
          return <String>{
            'estagio.almt.app',
          }.contains(host);
        };
    }
    _login = LoginAPI(this);
    _signup = RegisterAPI(this);
    _forgotPassword = ForgotPasswordAPI(this);
    _user = UserAPI(this);
    _product = ProductAPI(this);
    _users = UserAPI(this);
    _accounts = AccountAPI(this);
  }

  Codec<String, String> stringToBase64 = utf8.fuse(base64Url);

  Future<Profile?> getUserData() async {
    List<Cookie> cookies = await _cookies.getCookies();
    for (Cookie cookie in cookies) {
      if (cookie.name == 'token') {
        List<String> data = cookie.value.split('.');
        if (data.length == 3) {
          String payload = data[1];
          while (payload.length % 4 != 0) {
            payload += "=";
          }
          String encoded = stringToBase64.decode(payload);
          Map<String, dynamic> userData = json.decode(encoded);
          try {
            return Profile.fromJson(userData);
          } catch (e, stack) {
            if (kDebugMode) {
              print(e);
              print(stack);
            }
            return null;
          }
        }
      }
    }
    return null;
  }

  String? get currentToken {
    return _cookies.currentCookie;
  }

  static String? get token {
    return instance.currentToken;
  }
}
