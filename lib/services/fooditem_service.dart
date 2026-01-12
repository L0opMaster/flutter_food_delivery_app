// ignore: file_names
import 'dart:io';
import 'package:food_app/models/food_item.dart';
import 'package:food_app/services/main_url.dart';
import 'package:http/http.dart' as http;

class FooditemService {
  final MainUrl url = MainUrl();
  FooditemService._internal();
  static final FooditemService _instance = FooditemService._internal();
  factory FooditemService() => _instance;

  Future<List<FoodItem>> fecthingFoodProduct() async {
    final String baseUrl = '${url.baseUrll}/foodItems';
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final ResponseFoodItem foodItemData = ResponseFoodItem.fromJson(
          response.body,
        );
        return foodItemData.foodItems;
      } else {
        throw HttpException('Invalid loading format ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Fail to loading FoodItem $e');
    }
  }
}
