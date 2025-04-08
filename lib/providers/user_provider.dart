import 'package:dio/src/dio.dart';
import 'package:flutter/material.dart';
import '../api/api_users.dart';
import '../models/user.dart';

class UsersProvider extends ChangeNotifier {
  final List<User> _users = [];

  List<User> get users => _users;

  Future<void> loadUsers(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> addUser(int accountId, User userData) async {
    _users.add(userData);
    notifyListeners();
  }
}
