import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../core/http_utils.dart';
import '../models/account.dart';
import 'api.dart';
import 'api_base_module.dart';
import '../configs.dart';

class AccountAPI {
  final API api;
  AccountAPI(this.api);

  Future<Account> getAccounts() async {
    try {
      final response = await api.dio.get(
        '/accounts',
      );
      return Account.fromJson(response.data[0]);
    } on DioException catch (e) {
      print('[ERRO AO BUSCAR CONTAS]');
      print('Status: ${e.response?.statusCode}');
      print('Detalhes: ${e.response?.data}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getCurrentAccount(int accountId) async {
    try {
      final response = await api.dio.get(
        '/account',
        queryParameters: {'account_id': accountId},
      );
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      print('[ERRO AO BUSCAR CONTA]');
      print('Status: ${e.response?.statusCode}');
      print('Detalhes: ${e.response?.data}');
      rethrow;
    }
  }
}