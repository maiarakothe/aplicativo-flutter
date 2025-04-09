import 'package:awidgets/fields/a_field_checkbox_list.dart';
import 'package:awidgets/fields/a_field_email.dart';
import 'package:awidgets/fields/a_field_name.dart';
import 'package:awidgets/fields/a_field_password.dart';
import 'package:awidgets/fields/a_field_search.dart';
import 'package:awidgets/fields/a_option.dart';
import 'package:awidgets/general/a_button.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import 'package:awidgets/general/a_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../api/api.dart';
import '../api/api_users.dart';
import '../configs.dart';
import '../core/app_drawer.dart';
import '../core/colors.dart';
import '../models/account.dart';
import '../models/account_permission.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../theme_toggle_button.dart';

class UsersPage extends StatefulWidget {
  final void Function(Locale) changeLanguage;

  const UsersPage({super.key, required this.changeLanguage});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final GlobalKey<ATableState<User>> tableKey = GlobalKey<ATableState<User>>();
  String searchText = '';

  final List<PermissionData> allPermissions = [
    PermissionData(
      permission: AccountPermission.account_management,
      ptBr: 'Gerenciamento de contas',
    ),
    PermissionData(
      permission: AccountPermission.users,
      ptBr: 'Tela de Usuários',
    ),
    PermissionData(
      permission: AccountPermission.add_and_delete_products,
      ptBr: 'Cadastro e edição de produtos',
    ),
  ];

  List<Option> getPermissionOptions(BuildContext context) {
    return List.generate(
      allPermissions.length,
          (index) => Option(allPermissions[index].ptBr, index),
    );
  }

  String _getPermissionPtBr(AccountPermission permission) {
    try {
      return allPermissions.firstWhere((p) => p.permission == permission).ptBr;
    } catch (e) {
      return permission.encoded; // Fallback
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshUsers();
  }

  Future<void> _refreshUsers() async {
    final provider = Provider.of<UsersProvider>(context, listen: false);
    await provider.loadUsers(selectedAccount!.id);
    tableKey.currentState?.reload();
  }


  Future<List<User>> loadUsers(BuildContext context) async {
    final provider = Provider.of<UsersProvider>(context, listen: false);
    await provider.loadUsers(selectedAccount!.id);
    return provider.users.where((u) {
      return u.name.toLowerCase().contains(searchText.toLowerCase()) ||
          u.email.toLowerCase().contains(searchText.toLowerCase());
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final columns = <ATableColumn<User>>[
      ATableColumn<User>(
        title: localizations!.name,
        cellBuilder: (_, __, user) => Text(user.name),
      ),
      ATableColumn<User>(
        title: localizations.email,
        cellBuilder: (_, __, user) => Text(user.email),
      ),
      ATableColumn<User>(
        title: localizations.permissions,
        cellBuilder: (_, __, user) => Wrap(
          spacing: 6,
          runSpacing: 4,
          children: user.permissions.map((p) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getPermissionPtBr(p.permission),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      ATableColumn<User>(
        cellBuilder: (_, __, user) => IconButton(
          icon: const Icon(Icons.edit, color: Colors.blueAccent),
          tooltip: localizations.edit,
          onPressed: () => _openUserDialog(user: user),
        ),
      ),
    ];

    return Row(
      children: [
        const Material(child: AppDrawer()),
        const VerticalDivider(width: 1),
        Expanded(
          child: Scaffold(
            backgroundColor: Theme.of(context).cardColor,
            appBar: AppBar(
              title: Text(
                localizations.users,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              automaticallyImplyLeading: false,
              actions: [
                DropdownButton<Locale>(
                  icon: const Icon(Icons.language, color: Colors.white),
                  underline: const SizedBox.shrink(),
                  dropdownColor: Colors.black,
                  onChanged: (Locale? newValue) {
                    if (newValue != null) widget.changeLanguage(newValue);
                  },
                  items: const [
                    DropdownMenuItem(
                      value: Locale('en'),
                      child:
                      Text('English', style: TextStyle(color: Colors.white)),
                    ),
                    DropdownMenuItem(
                      value: Locale('pt'),
                      child: Text('Português',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ThemeToggleButton(),
                ),
              ],
            ),
            body: ColoredBox(
              color: DefaultColors.backgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AFieldSearch(
                            label: localizations.search,
                            onChanged: (value) {
                              setState(() => searchText = value ?? '');
                              tableKey.currentState?.reload();
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        AButton(
                          text: localizations.addUser,
                          landingIcon: Icons.person_add,
                          onPressed: _openUserDialog,
                          color: DefaultColors.circleAvatar,
                          fontWeight: FontWeight.bold,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ATable<User>(
                        key: tableKey,
                        columns: columns,
                        striped: true,
                        loadItems: (_, __) => loadUsers(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openUserDialog({User? user}) {
    final isEdit = user != null;

    showDialog(
      context: context,
      builder: (context) {
        return AFormDialog<User>(
          title: (AppLocalizations.of(context)!.addUser),
          submitText: AppLocalizations.of(context)!.save,
          persistent: true,
          initialData: isEdit
              ? {
            'name': user.name,
            'email': user.email,
            'password': '',
            'permissions': user.permissions
                .map((p) => allPermissions.indexWhere(
                  (perm) => perm.permission == p.permission,
            ))
                .where((i) => i != -1)
                .toList(),
          }
              : null,
          fields: [
            if (!isEdit) ...[
              AFieldName(
                label: AppLocalizations.of(context)!.name,
                identifier: 'name',
                required: true,
              ),
              AFieldEmail(
                label: AppLocalizations.of(context)!.email,
                identifier: 'email',
                required: true,
              ),
              AFieldPassword(
                label: AppLocalizations.of(context)!.password,
                identifier: 'password',
              ),
            ],
            AFieldCheckboxList(
              label: AppLocalizations.of(context)!.permissions,
              identifier: 'permissions',
              options: getPermissionOptions(context),
              minRequired: 1,
            ),
          ],
          fromJson: (json) => User(
            id: user?.id ?? 0,
            name: json['name'],
            email: json['email'],
            password: json['password'],
            permissions: (json['permissions'] as List<dynamic>)
                .map((index) => allPermissions[index as int])
                .toList(),
          ),
          onSubmit: (userData) async {
            final provider = Provider.of<UsersProvider>(context, listen: false);
            final accountId = selectedAccount!.id;

            try {
              final userToSave = userData.copyWith(id: user?.id ?? 0);
              if (isEdit) {
                await provider.updateUser(accountId, userToSave);
              } else {
                await provider.addUser(accountId, userToSave);
              }
              return null;
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.genericError),
                  backgroundColor: Colors.red,
                ),
              );
              return e.toString();
            }
          },
          onSuccess: () async {
            await _refreshUsers();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isEdit
                      ? AppLocalizations.of(context)!.userEditedSuccessfully
                      : AppLocalizations.of(context)!.userRegisteredSuccessfully,
                ),
                backgroundColor: DefaultColors.green,
              ),
            );
          },
        );
      },
    );
  }
}