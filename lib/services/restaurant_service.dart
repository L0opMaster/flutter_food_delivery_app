import 'package:food_app/models/restaurant.dart';
import 'package:food_app/services/main_url.dart';
import 'package:http/http.dart' as http;

class RestaurantService {
  final MainUrl url = MainUrl();
  RestaurantService._internal();
  static final RestaurantService _instance = RestaurantService._internal();
  factory RestaurantService() => _instance;

  Future<List<Restaurants>> fetchingRestaurant() async {
    final String baseUrl = '${url.baseUrll}/restaurants';
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final ResponseRestaurant data = ResponseRestaurant.fromJson(
          response.body,
        );
        return data.restaurants;
      } else {
        throw Exception('Invalid to loading formart ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to loading product');
    }
  }
}
