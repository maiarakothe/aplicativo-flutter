import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../core/http_utils.dart';
import 'api_base_module.dart';

class ProductAPI extends BaseModuleAPI {
  ProductAPI(super.api);

  Future<void> createProduct({
    required String name,
    required double value,
    required String url,
  }) async {
    final response = await requestWrapper(
          () => api.dio.post(
        '/product',
        data: jsonEncode({
          "name": name,
          "category_type": null,
          "quantity": null,
          "value": value,
          "url": url,
        }),
      ),
    );
    debugPrint('Resposta: ${response.data}');
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final response = await requestWrapper(
          () => api.dio.get('/products'),
    );
    return List<Map<String, dynamic>>.from(response.data);
  }

  Future<Map<String, dynamic>> getProductById(int productId) async {
    final response = await requestWrapper(
          () => api.dio.get('/product/$productId'),
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<void> updateProduct({
    required int id,
    required String name,
    required double value,
    required url,
  }) async {
    await requestWrapper(
          () => api.dio.patch(
        '/product/update',
        queryParameters: {'product_id': id},
        data: jsonEncode({
          "name": name,
          "category_type": null,
          "quantity": null,
          "value": value,
          "url": url,
        }),
      ),
    );
  }

  Future<void> deleteProduct(int productId) async {
    await requestWrapper(
          () => api.dio.delete('/product/$productId'),
    );
  }
}