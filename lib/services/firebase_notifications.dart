import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';

class FirebaseNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    String? token = await _messaging.getToken();
    print("Firebase Token (WEB): $token");

    await _messaging.requestPermission();

    // Lidar com mensagens enquanto o app está em primeiro plano
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(notification.title ?? 'Nova notificação'),
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    // Lidar com mensagens que abrem o app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final notification = message.notification;
      final context = navigatorKey.currentState?.overlay?.context;

      if (notification != null && context != null) {
        // Aguarda o frame atual terminar antes de mostrar o diálogo
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text(notification.title ?? 'Sem título'),
              content: Text(notification.body ?? 'Sem conteúdo'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context).cancel),
                ),
              ],
            ),
          );
        });
      }
    });
  }
}