class OrderItemModel {
  final int productId;
  final String productName;
  final double price;
  final int quantity;
  final double subtotal;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['product_id'] is int
          ? json['product_id']
          : int.tryParse(json['product_id'].toString()) ?? 0,

      productName: json['product_name']?.toString() ?? '',

      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price'].toString()) ?? 0.0,

      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity'].toString()) ?? 0,

      subtotal: json['subtotal'] is num
          ? (json['subtotal'] as num).toDouble()
          : double.tryParse(json['subtotal'].toString()) ?? 0.0,
    );
  }
}

class OrderModel {
  final int id;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final String notes;
  final String paymentMethod;
  final List<OrderItemModel> items;
  final String createdAt;

  /// Nomor Virtual Account
  final String? vaNumber;

  /// Deep-link GoPay
  final String? gopayDeeplink;

  const OrderModel({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.notes,
    required this.paymentMethod,
    required this.items,
    required this.createdAt,
    this.vaNumber,
    this.gopayDeeplink,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];

    final items = rawItems
        .map((e) => OrderItemModel.fromJson(
              e as Map<String, dynamic>,
            ))
        .toList();

    return OrderModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,

      totalAmount: json['total_amount'] is num
          ? (json['total_amount'] as num).toDouble()
          : double.tryParse(json['total_amount'].toString()) ?? 0.0,

      status: json['status']?.toString() ?? 'pending',

      shippingAddress:
          json['shipping_address']?.toString() ?? '',

      notes: json['notes']?.toString() ?? '',

      paymentMethod:
          json['payment_method']?.toString() ?? '',

      items: items,

      createdAt: json['created_at']?.toString() ?? '',

      vaNumber: json['va_number']?.toString(),

      gopayDeeplink:
          json['gopay_deeplink']?.toString(),
    );
  }

  OrderModel copyWith({
    String? status,
    String? vaNumber,
    String? gopayDeeplink,
  }) {
    return OrderModel(
      id: id,
      totalAmount: totalAmount,
      status: status ?? this.status,
      shippingAddress: shippingAddress,
      notes: notes,
      paymentMethod: paymentMethod,
      items: items,
      createdAt: createdAt,
      vaNumber: vaNumber ?? this.vaNumber,
      gopayDeeplink:
          gopayDeeplink ?? this.gopayDeeplink,
    );
  }
}