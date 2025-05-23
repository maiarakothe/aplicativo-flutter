import 'package:awidgets/general/a_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:teste/services/auth_service.dart';
import 'package:teste/core/colors.dart';
import 'package:teste/models/profile.dart';
import 'package:awidgets/fields/a_field_name.dart';
import 'package:awidgets/fields/a_field_password.dart';
import 'package:awidgets/general/a_form_dialog.dart';
import '../api/api.dart';
import '../api/api_profile.dart';
import '../core/responsive_scaffold.dart';
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
              oldPassword: '',
              newPassword: '',
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
        const SizedBox(height: 20),
        AButton(
          landingIcon:Icons.lock,
          text: localizations.changePassword,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          onPressed: () => _showPasswordEditDialog(localizations),
        ),
      ],
    );
  }

  Future<void> _showPasswordEditDialog(AppLocalizations localizations) async {
    await AFormDialog.show<Map<String, dynamic>>(
      context,
      title: localizations.changePassword,
      persistent: true,
      submitText: localizations.confirm,
      fromJson: (json) => json as Map<String, dynamic>,
      onSubmit: (Map<String, dynamic> data) async {
        try {
          await _userAPI.updateUser(
            name: _profileData?.name ?? '',
            oldPassword: data['old_password'],
            newPassword: data['new_password'],
          );

          if (!mounted) return;
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.passwordUpdated),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations.somethingWentWrong),
              backgroundColor: Colors.red,
            ),
          );
        }
        return null;
      },
      fields: [
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

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
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
                child: Text('English', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: Locale('pt'),
                child: Text('Português', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
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
            const SizedBox(height: 30),
            Icon(
              Icons.account_circle,
              size: 160,
              color: DefaultColors.backgroundButton,
            ),
            const SizedBox(height: 30),
            Text(
              _profileData?.name ?? 'Nome não disponível',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _profileData?.email ?? 'Email não disponível',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showEditProfileDialog,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: DefaultColors.backgroundButton,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                textStyle: const TextStyle(fontSize: 20),
              ),
              child: Text(AppLocalizations.of(context).editProfile),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}