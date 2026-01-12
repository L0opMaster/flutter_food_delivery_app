// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Review {
  final String id;
  final String restaurantId;
  final String? orderId;
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final int helpful;
  final int foodQuality;
  final int deliverySpeed;
  final int customerService;

  const Review({
    required this.id,
    required this.restaurantId,
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.helpful,
    required this.foodQuality,
    required this.deliverySpeed,
    required this.customerService,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'orderId': orderId,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'helpful': helpful,
      'foodQuality': foodQuality,
      'deliverySpeed': deliverySpeed,
      'customerService': customerService,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'] as String,
      restaurantId: map['restaurantId'] as String,
      orderId: map['orderId']?.toString() ?? 'unknow',
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      rating: map['rating'] as int,
      comment: map['comment'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      helpful: map['helpful'] as int,
      foodQuality: map['foodQuality'] as int,
      deliverySpeed: map['deliverySpeed'] as int,
      customerService: map['customerService'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));
}

class ResponseReview {
  final List<Review> reviews;
  ResponseReview({required this.reviews});

  ResponseReview copyWith({List<Review>? reviews}) {
    return ResponseReview(reviews: reviews ?? this.reviews);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'reviews': reviews.map((x) => x.toMap()).toList()};
  }

  factory ResponseReview.fromMap(Map<String, dynamic> map) {
    return ResponseReview(
      reviews: List<Review>.from(
        (map['reviews'] as List<int>).map<Review>(
          (x) => Review.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseReview.fromJson(String source) {
    try {
      final List<dynamic> jsonList = jsonDecode(source) as List<dynamic>;
      return ResponseReview(
        reviews: jsonList.map((json) => Review.fromMap(json)).toList(),
      );
    } catch (e) {
      throw Exception('Invalid loading format $e');
    }
  }

  @override
  String toString() => 'ResponseReview(reviews: $reviews)';

  @override
  bool operator ==(covariant ResponseReview other) {
    if (identical(this, other)) return true;

    return listEquals(other.reviews, reviews);
  }

  @override
  int get hashCode => reviews.hashCode;
}
