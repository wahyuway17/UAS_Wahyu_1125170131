import 'package:dio/dio.dart';
import 'package:shopping_tangerang/core/constants/api_constants.dart';
import 'package:shopping_tangerang/core/services/dio_client.dart';
import 'package:shopping_tangerang/features/order/data/models/order_model.dart';
import 'package:shopping_tangerang/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  @override
  Future<OrderModel> checkout({
    required String shippingAddress,
    String? notes,
    required String paymentMethod,
  }) async {
    try {
      final response = await DioClient.instance.post(
        ApiConstants.checkout,
        data: {
          'shipping_address': shippingAddress,
          'notes': notes ?? '',
          'payment_method': paymentMethod,
        },
      );

      print("CHECKOUT RESPONSE:");
      print(response.data);

      // Validasi response
      if (response.data == null) {
        throw Exception('Response kosong dari server');
      }

      if (response.data['data'] == null) {
        throw Exception('Data order tidak ditemukan');
      }

      final data = response.data['data'] as Map<String, dynamic>;

      return OrderModel.fromJson(data);
    } on DioException catch (e) {
      print("DIO ERROR:");
      print(e.response?.data);

      throw Exception(
        e.response?.data['message'] ??
            e.message ??
            'Gagal checkout',
      );
    } catch (e) {
      print("CHECKOUT ERROR:");
      print(e);

      rethrow;
    }
  }

  @override
  Future<List<OrderModel>> getMyOrders({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await DioClient.instance.get(
        ApiConstants.orders,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final List<dynamic> data =
          response.data['data'] as List<dynamic>? ?? [];

      return data
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.message ??
            'Gagal mengambil orders',
      );
    }
  }

  @override
  Future<OrderModel> getOrderDetail(int orderId) async {
    try {
      final response = await DioClient.instance.get(
        '${ApiConstants.orders}/$orderId',
      );

      final data = response.data['data'] as Map<String, dynamic>;

      return OrderModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            e.message ??
            'Gagal mengambil detail order',
      );
    }
  }

  @override
  Future<OrderModel> checkPaymentStatus(int orderId) {
    return getOrderDetail(orderId);
  }
}