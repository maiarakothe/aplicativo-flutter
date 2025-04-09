import 'package:dio/src/dio.dart';
import 'package:flutter/material.dart';
import '../api/api.dart';
import '../api/api_users.dart';
import '../configs.dart';
import '../models/account_permission.dart';
import '../models/user.dart';

class UsersProvider extends ChangeNotifier {
  final List<User> _users = [];
  final UserAPI _userAPI = UserAPI(API());

  List<User> get users => _users;

  Future<void> loadUsers(int accountId) async {
    try {
      final fetchedUsers = await _userAPI.getMembers(accountId);
      _users.clear();
      _users.addAll(fetchedUsers);
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao carregar usuários: $e');
    }
  }

  Future<void> addUser(int accountId, User userData) async {
    try {
      final newUser = await _userAPI.createUser(accountId, userData);
      _users.add(newUser);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUser(int accountId, User user) async {
    try {
      await _userAPI.editMember(accountId: accountId, user: user);
      await loadUsers(accountId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleUserActive(User user, bool isActive) async {
    final accountId = selectedAccount?.id;
    if (accountId == null) throw Exception('Conta não selecionada.');

    await _userAPI.toggleActive(
      userId: user.id,
      accountId: accountId,
      isActive: isActive,
    );
  }

}