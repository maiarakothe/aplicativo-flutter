import 'package:flutter/material.dart';

class ShowProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Aqui serão exibidos os produtos cadastrados.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
