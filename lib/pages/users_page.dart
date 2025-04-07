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
import '../api/api_profile.dart';
import '../configs.dart';
import '../core/app_drawer.dart';
import '../core/colors.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../theme_toggle_button.dart';

class UsersPage extends StatefulWidget {
  final void Function(Locale) changeLanguage;
  final UserAPI _userAPI = UserAPI(API());
  UsersPage({super.key, required this.changeLanguage});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final GlobalKey<ATableState<User>> tableKey = GlobalKey<ATableState<User>>();
  String searchText = '';
  List<User> allUsers = [];

  Future<List<User>> loadUsers(BuildContext context) async {
    return allUsers
        .where((u) =>
            u.name.toLowerCase().contains(searchText.toLowerCase()) ||
            u.email.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  List<Option> getPermissionOptions(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return [
      Option(localizations.accountManagement, 1),
      Option(localizations.userScreen, 2),
      Option(localizations.productForm, 3),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final columns = <ATableColumn<User>>[
      ATableColumn<User>(
        title: AppLocalizations.of(context).name,
        cellBuilder: (_, __, user) => Text(user.name),
      ),
      ATableColumn<User>(
        title: AppLocalizations.of(context).email,
        cellBuilder: (_, __, user) => Text(user.email),
      ),
      ATableColumn<User>(
        title: AppLocalizations.of(context).permissions,
        cellBuilder: (_, __, user) => Text(user.permissions.join(', ')),
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
                AppLocalizations.of(context).users,
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
                      child: Text('English',
                          style: TextStyle(color: Colors.white)),
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
                            label: AppLocalizations.of(context).search,
                            onChanged: (value) {
                              setState(() => searchText = value!);
                              tableKey.currentState?.reload();
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        AButton(
                          text: AppLocalizations.of(context).addUser,
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

  void _openUserDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AFormDialog<User>(
          title: AppLocalizations.of(context).addUser,
          submitText: AppLocalizations.of(context).save,
          persistent: true,
          fields: [
            AFieldName(
              label: AppLocalizations.of(context).name,
              identifier: 'name',
              required: true,
            ),
            AFieldEmail(
              label: AppLocalizations.of(context).email,
              identifier: 'email',
              required: true,
            ),
            AFieldPassword(
              label: AppLocalizations.of(context).password,
              identifier: 'password',
            ),
            AFieldCheckboxList(
              label: AppLocalizations.of(context).permissions,
              identifier: 'permissions',
              options: getPermissionOptions(context),
              minRequired: 1,
            ),
          ],
          fromJson: (json) => User(
            id: 0,
            name: json['name'],
            email: json['email'],
            password: json['password'],
            permissions: json['permissions'],
          ),
          onSubmit: (userData) async {
            final provider = Provider.of<UsersProvider>(context, listen: false);

            final result = await API().getUserData();
            final accountId = selectedAccount!.id;

            return null;
          },
          onSuccess: () {
            tableKey.currentState?.reload();
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    AppLocalizations.of(context).userRegisteredSuccessfully),
                backgroundColor: DefaultColors.green,
              ),
            );
          },
        );
      },
    );
  }
}
