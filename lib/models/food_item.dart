// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class FoodItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
  final String restaurantId;
  final bool isAvailable;
  final List<String> ingredients;
  final bool isVegetarian;
  final bool isVegan;
  final bool isSpicy;
  final double rating;
  final int reviewCount;
  final int calories;
  final int preparationTime;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.restaurantId,
    required this.isAvailable,
    required this.ingredients,
    required this.isVegetarian,
    required this.isVegan,
    required this.isSpicy,
    required this.rating,
    required this.reviewCount,
    required this.calories,
    required this.preparationTime,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    String? category,
    String? restaurantId,
    bool? isAvailable,
    List<String>? ingredients,
    bool? isVegetarian,
    bool? isVegan,
    bool? isSpicy,
    double? rating,
    int? reviewCount,
    int? calories,
    int? preparationTime,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      category: category ?? this.category,
      restaurantId: restaurantId ?? this.restaurantId,
      isAvailable: isAvailable ?? this.isAvailable,
      ingredients: ingredients ?? this.ingredients,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isSpicy: isSpicy ?? this.isSpicy,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      calories: calories ?? this.calories,
      preparationTime: preparationTime ?? this.preparationTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'category': category,
      'restaurantId': restaurantId,
      'isAvailable': isAvailable,
      'ingredients': ingredients,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'isSpicy': isSpicy,
      'rating': rating,
      'reviewCount': reviewCount,
      'calories': calories,
      'preparationTime': preparationTime,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      price: (map['price'] as num).toDouble(),
      category: map['category'] as String,
      restaurantId: map['restaurantId'] as String,
      isAvailable: map['isAvailable'] as bool,
      ingredients: List<String>.from(map['ingredients'] ?? []),
      isVegetarian: map['isVegetarian'] as bool,
      isVegan: map['isVegan'] as bool,
      isSpicy: map['isSpicy'] as bool,
      rating: (map['rating'] as num).toDouble(),
      reviewCount: map['reviewCount'] as int,
      calories: map['calories'] as int,
      preparationTime: map['preparationTime'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodItem.fromJson(String source) =>
      FoodItem.fromMap(json.decode(source));

  @override
  bool operator ==(covariant FoodItem other) => other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class ResponseFoodItem {
  final List<FoodItem> foodItems;
  ResponseFoodItem({required this.foodItems});

  ResponseFoodItem copyWith({List<FoodItem>? foodItems}) {
    return ResponseFoodItem(foodItems: foodItems ?? this.foodItems);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'foodItems': foodItems.map((x) => x.toMap()).toList(),
    };
  }

  factory ResponseFoodItem.fromMap(Map<String, dynamic> map) {
    return ResponseFoodItem(
      foodItems: List<FoodItem>.from(
        (map['foodItems'] as List<int>).map<FoodItem>(
          (x) => FoodItem.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseFoodItem.fromJson(String source) {
    try {
      final List<dynamic> jsonList = jsonDecode(source) as List<dynamic>;
      return ResponseFoodItem(
        foodItems: jsonList.map((json) => FoodItem.fromMap(json)).toList(),
      );
    } catch (e) {
      throw Exception('Fail to loading FoodItem $e');
    }
  }

  @override
  String toString() => 'ResponseFoodItem(foodItems: $foodItems)';

  @override
  bool operator ==(covariant ResponseFoodItem other) {
    if (identical(this, other)) return true;

    return listEquals(other.foodItems, foodItems);
  }

  @override
  int get hashCode => foodItems.hashCode;
}
