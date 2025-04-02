import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../models/user.dart';
import './api_interceptor_web.dart' if (dart.library.io) './api_interceptor_web.dart';
import 'api_login.dart';
import 'api_register.dart';

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


  late LoginAPI _login;
  late RegisterAPI _signup;

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
  }

  Codec<String, String> stringToBase64 = utf8.fuse(base64Url);

  Future<User?> getUserData() async {
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
            return User.fromJson(userData);
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
