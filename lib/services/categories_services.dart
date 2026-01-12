import 'dart:io';

import 'package:food_app/models/categories.dart';
import 'package:food_app/services/main_url.dart';
import 'package:http/http.dart' as http;

class CategoriesServices {
  final MainUrl url = MainUrl();

  CategoriesServices._internal();
  static final CategoriesServices _instance = CategoriesServices._internal();

  factory CategoriesServices() => _instance;

  Future<List<Categories>> fetchCategory() async {
    final String baseUrl = '${url.baseUrll}/categories';
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final ResponseCategories categories = ResponseCategories.fromJson(
          response.body,
        );
        return categories.categories;
      } else {
        throw HttpException('Error format ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Invalid loading $e');
    }
  }
}
