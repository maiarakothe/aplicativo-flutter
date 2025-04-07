import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../core/http_utils.dart';
import 'api_base_module.dart';

class ProductAPI extends BaseModuleAPI {
  ProductAPI(super.api);

  Future<void> createProduct({
    required String name,
    required double value,
    required String url,
    required int accountId,
  }) async {
    final response = await requestWrapper(
      () => api.dio.post(
        '/product',
        queryParameters: {'account_id': accountId},
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

  Future<List<Map<String, dynamic>>> getAllProducts(
      {required int accountId}) async {
    final response = await requestWrapper(
      () => api.dio.get(
        '/products',
        queryParameters: {
          'account_id': accountId,
        },
      ),
    );
    debugPrint('[RAW PRODUCTS RESPONSE] ${response.data}');
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
    required String url,
    required double value,
    int? accountId,
  }) async {
    final Map<String, dynamic> data = {
      "name": name,
      "category_type": null,
      "quantity": null,
      "value": value,
      "url": url,
    };

    await requestWrapper(
      () => api.dio.patch(
        '/product/update',
        queryParameters: {
          'product_id': id,
          'account_id': accountId ?? null,
        },
        data: jsonEncode(data),
      ),
    );
  }

  Future<void> deleteProduct(int productId) async {
    await requestWrapper(
      () => api.dio.delete('/product/$productId'),
    );
  }
}
