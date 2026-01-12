// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OrderItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final double totalPrice;
  final String? specialInstructions;

  const OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.totalPrice,
    this.specialInstructions,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
      specialInstructions: map['specialInstructions']?.toString(),
    );
  }
}

class Order {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double total;
  final String status;
  final DateTime createdAt;
  final DateTime estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final String deliveryAddress;
  final String? specialInstructions;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final double? driverLatitude;
  final double? driverLongitude;
  final String paymentMethod;
  final String paymentStatus;

  const Order({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    required this.deliveryAddress,
    this.specialInstructions,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.driverLatitude,
    this.driverLongitude,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id']?.toString() ?? '',
      restaurantId: map['restaurantId']?.toString() ?? '',
      restaurantName: map['restaurantName']?.toString() ?? '',
      items: (map['items'] as List? ?? [])
          .map((e) => OrderItem.fromMap(e))
          .toList(),
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      tax: (map['tax'] as num?)?.toDouble() ?? 0.0,
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      status: map['status']?.toString() ?? 'unknown',

      // status: map['status'] as String,
      createdAt:
          DateTime.tryParse(map['createdAt'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      estimatedDeliveryTime:
          DateTime.tryParse(map['estimatedDeliveryTime'] ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      actualDeliveryTime: map['actualDeliveryTime'] != null
          ? DateTime.tryParse(map['actualDeliveryTime'])
          : null,
      deliveryAddress: map['deliveryAddress']?.toString() ?? '',
      specialInstructions: map['specialInstructions']?.toString(),
      driverId: map['driverId']?.toString(),
      driverName: map['driverName']?.toString(),
      driverPhone: map['driverPhone']?.toString(),
      driverLatitude: (map['driverLatitude'] as num?)?.toDouble(),
      driverLongitude: (map['driverLongitude'] as num?)?.toDouble(),
      paymentMethod: map['paymentMethod']?.toString() ?? 'unknown',
      paymentStatus: map['paymentStatus']?.toString() ?? 'unknown',
    );
  }
}

class ResponseOrder {
  final List<Order> orders;

  ResponseOrder({required this.orders});

  factory ResponseOrder.fromJson(String source) {
    try {
      final decoded = jsonDecode(source);

      // API returns { "orders": [...] }
      if (decoded is Map<String, dynamic>) {
        final list = decoded['orders'] as List? ?? [];
        return ResponseOrder(
          orders: list.map((e) => Order.fromMap(e)).toList(),
        );
      }

      // API returns [ {...}, {...} ]
      if (decoded is List) {
        return ResponseOrder(
          orders: decoded.map((e) => Order.fromMap(e)).toList(),
        );
      }

      throw Exception('Unexpected JSON structure');
    } catch (e) {
      throw Exception('Invalid loading Order: $e');
    }
  }
}
