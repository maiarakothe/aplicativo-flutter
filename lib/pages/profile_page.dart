import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teste/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/models/profile.dart';
import 'package:awidgets/fields/a_field_name.dart';
import 'package:awidgets/fields/a_field_password.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import '../api/api.dart';
import '../api/api_login.dart';
import '../api/api_profile.dart';
import '../core/app_drawer.dart';
import '../theme_toggle_button.dart';

class ProfilePage extends StatefulWidget {
  final void Function(Locale) changeLanguage;

  const ProfilePage({Key? key, required this.changeLanguage}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final UserAPI _userAPI = UserAPI(API());
  Profile? _profileData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _loadUserInfo() async {
    try {
      final userData = await _userAPI.getUser();
      setState(() {
        _profileData = Profile(
          name: userData['name'] ?? 'Nome não disponível',
          email: userData['email'] ?? 'Email não disponível',
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).somethingWentWrong),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _showEditProfileDialog() async {
    final localizations = AppLocalizations.of(context);

    await AFormDialog.show<Map<String, dynamic>>(
      context,
      title: localizations.editProfile,
      persistent: true,
      submitText: localizations.confirm,
      fromJson: (json) => json as Map<String, dynamic>,
      onSubmit: (Map<String, dynamic> data) async {
        try {
          await _userAPI.updateUser(
            name: data['name'],
            newPassword: data['new_password'],
            oldPassword: data['old_password'],
          );

          if (!mounted) return;
          Navigator.pop(context);
          _loadUserInfo();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.profileUpdated),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).somethingWentWrong),
              backgroundColor: Colors.red,
            ),
          );
        }
        return null;
      },
      fields: [
        AFieldName(
          identifier: 'name',
          label: localizations.name,
          required: true,
          initialValue: _profileData?.name ?? '',
        ),
        const SizedBox(height: 10),
        AFieldPassword(
          identifier: 'old_password',
          label: localizations.oldPassword,
          minLength: 6,
        ),
        const SizedBox(height: 10),
        AFieldPassword(
          identifier: 'new_password',
          label: localizations.newPassword,
          minLength: 6,
        ),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    bool confirmLogout = await _showLogoutDialog(context);
    if (confirmLogout) {
      try {
        final loginAPI = LoginAPI(API());
        await loginAPI.logout();

        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } catch (e) {
        debugPrint('Erro ao deslogar: $e');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao sair"), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context).confirmLogout),
            content: Text(AppLocalizations.of(context).areYouSureLogout),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context).cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  AppLocalizations.of(context).logout,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AppDrawer(),
          const VerticalDivider(width: 1),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  AppLocalizations.of(context).profile,
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
              body: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 60),
                          Icon(
                            Icons.account_circle,
                            size: 160,
                            color: DefaultColors.backgroundButton,
                          ),
                          SizedBox(height: 60),
                          Text(
                            _profileData?.name ?? 'Nome não disponível',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          Text(
                            _profileData?.email ?? 'Email não disponível',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _showEditProfileDialog,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: DefaultColors.backgroundButton,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              textStyle: TextStyle(fontSize: 20),
                            ),
                            child:
                                Text(AppLocalizations.of(context).editProfile),
                          ),
                          SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () => _logout(context),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: DefaultColors.backgroundButton,
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              textStyle: TextStyle(fontSize: 20),
                            ),
                            child: Text(AppLocalizations.of(context).logout),
                          ),
                          SizedBox(height: 60),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
