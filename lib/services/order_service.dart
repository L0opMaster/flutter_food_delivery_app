import 'dart:io';

import 'package:food_app/models/order.dart';
import 'package:food_app/services/main_url.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final MainUrl url = MainUrl();

  OrderService._internal();
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;

  Future<List<Order>> fetchOrder() async {
  final String baseUrl = '${url.baseUrll}/orders';
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final ResponseOrder order = ResponseOrder.fromJson(response.body);
        return order.orders;
      } else {
        throw HttpException('Fail to format order ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Invalid loading data $e');
    }
  }
}
