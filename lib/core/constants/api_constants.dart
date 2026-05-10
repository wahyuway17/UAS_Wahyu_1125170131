class ApiConstants {
  static const String baseUrl = 'http://192.168.250.3:8080';

  // Auth
  static const String verifyToken = '/v1/auth/verify-token';

  // Products
  static const String products = '/v1/products';

  // Cart
  static const String cart = '/v1/cart';
  static const String checkout = '/v1/cart/checkout';

  // Orders
  static const String orders = '/v1/orders';

  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}