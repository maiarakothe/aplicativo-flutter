import 'package:flutter/material.dart';
import '../models/user.dart';

class UsersProvider with ChangeNotifier {
  final List<User> _users = [];

  List<User> get users => _users;

  Future<void> loadUsers() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<void> addUser(User user) async {
    _users.add(user);
    notifyListeners();
  }
}

