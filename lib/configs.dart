import 'package:flutter/material.dart';

class Configs {
  // BorderRadius
  static BorderRadius radiusBorder = BorderRadius.circular(16);

  // BorderRadius para botão
  static BorderRadius buttonBorderRadius = BorderRadius.circular(28);

  // Máscara para URL da imagem (URL genérica)
  static List<String> imageURLMask = <String>['http://*', 'https://*'];

  // Máscara para valores de produto
  static List<String> productPriceMask = <String>['R\$ ###,###.##'];
}
