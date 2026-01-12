import 'dart:io';

import 'package:food_app/models/review.dart';
import 'package:food_app/services/main_url.dart';
import 'package:http/http.dart' as http;

class ReviewService {
  final MainUrl url = MainUrl();

  ReviewService._internal();
  static final ReviewService _instance = ReviewService._internal();
  factory ReviewService() => _instance;

  Future<List<Review>> fechReview() async {
    final String baseUrl = '${url.baseUrll}/reviews';
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final ResponseReview review = ResponseReview.fromJson(response.body);
        return review.reviews;
      } else {
        throw HttpException('Fail to format review ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Invalid loading review $e');
    }
  }
}
