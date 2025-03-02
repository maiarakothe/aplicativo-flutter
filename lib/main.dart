import 'package:flutter/material.dart';
import 'pages/login_pagina.dart'; // Importa a tela de login

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
      title: 'Login App',
      home: LoginPage(), // Define a tela de login como a inicial
    );
  }
}
