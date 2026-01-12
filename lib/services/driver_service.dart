import 'dart:io';

import 'package:food_app/models/driver.dart';
import 'package:food_app/services/main_url.dart';
import 'package:http/http.dart' as http;

class DriverService {
  DriverService._internal();
  static final DriverService _instance = DriverService._internal();
  factory DriverService() => _instance;

  final MainUrl url = MainUrl();

  Future<List<Driver>> fetchDriver() async {
    final String baseUrl = '${url.baseUrll}/drivers';
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final ResponseDriver driver = ResponseDriver.fromJson(response.body);
        return driver.drivers;
      } else {
        throw HttpException('Failed formart driver ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('invalid loading Driver $e');
    }
  }
}
