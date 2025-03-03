import 'package:flutter/material.dart';
import 'package:teste/pages/registrar_produto_pagina.dart';
import 'pages/login_pagina.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      home: LoginPage(),
    );
  }
}
