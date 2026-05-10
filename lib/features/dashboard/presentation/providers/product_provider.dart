import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping_tangerang/core/constants/api_constants.dart';
import 'package:shopping_tangerang/core/services/dio_client.dart';
import 'package:shopping_tangerang/features/dashboard/data/models/product_model.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  ProductStatus _status = ProductStatus.initial;
  List<ProductModel> _products = [];
  String? _error;

  ProductStatus get status => _status;
  List<ProductModel> get products => _products;
  String? get error => _error;
  bool get isLoading => _status == ProductStatus.loading;

  /// Fetch products — token otomatis disertakan oleh DioClient interceptor
  Future<void> fetchProducts() async {
    _status = ProductStatus.loading;
    notifyListeners();

    try {
      final response = await DioClient.instance.get(ApiConstants.products);

      print("PRODUCT RESPONSE:");
      print(response.data);

      List<dynamic> data = [];

      // Kalau backend return:
      // { "data": [...] }
      if (response.data is Map && response.data['data'] != null) {
        data = response.data['data'];
      }

      // Kalau backend return langsung array
      else if (response.data is List) {
        data = response.data;
      }

      _products = data.map((e) => ProductModel.fromJson(e)).toList();

      _status = ProductStatus.loaded;
    } on DioException catch (e) {
      print("DIO ERROR: $e");

      _error = e.response?.data.toString() ?? 'Gagal memuat produk';
      _status = ProductStatus.error;
    } catch (e) {
      print("GENERAL ERROR: $e");

      _error = 'Terjadi kesalahan: $e';
      _status = ProductStatus.error;
    }

    notifyListeners();
  }
}
