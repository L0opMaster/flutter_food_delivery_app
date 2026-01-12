// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Restaurants {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final List<String> categories;
  final String phoneNumber;
  final bool isOpen;
  final int deliveryTime;
  final double deliveryFee;
  final int minimumOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Restaurants({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.categories,
    required this.phoneNumber,
    required this.isOpen,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  Restaurants copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? address,
    double? latitude,
    double? longitude,
    double? rating,
    int? reviewCount,
    List<String>? categories,
    String? phoneNumber,
    bool? isOpen,
    int? deliveryTime,
    double? deliveryFee,
    int? minimumOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Restaurants(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      categories: categories ?? this.categories,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOpen: isOpen ?? this.isOpen,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'reviewCount': reviewCount,
      'categories': categories,
      'phoneNumber': phoneNumber,
      'isOpen': isOpen,
      'deliveryTime': deliveryTime,
      'deliveryFee': deliveryFee,
      'minimumOrder': minimumOrder,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Restaurants.fromMap(Map<String, dynamic> map) {
    return Restaurants(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      imageUrl: map['imageUrl'] as String,
      address: map['address'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      rating: (map['rating'] as num).toDouble(),
      reviewCount: map['reviewCount'] as int,
      categories: List<String>.from(map['categories'] ?? []),
      phoneNumber: map['phoneNumber'] as String,
      isOpen: map['isOpen'] as bool,
      deliveryTime: map['deliveryTime'] as int,
      deliveryFee: (map['deliveryFee'] as num).toDouble(),
      minimumOrder: map['minimumOrder'] as int,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Restaurants.fromJson(String source) =>
      Restaurants.fromMap(json.decode(source));

  @override
  bool operator ==(covariant Restaurants other) =>
      identical(this, other) && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class ResponseRestaurant {
  final List<Restaurants> restaurants;
  ResponseRestaurant({required this.restaurants});

  ResponseRestaurant copyWith({List<Restaurants>? restaurants}) {
    return ResponseRestaurant(restaurants: restaurants ?? this.restaurants);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'restaurants': restaurants.map((x) => x.toMap()).toList(),
    };
  }

  factory ResponseRestaurant.fromMap(Map<String, dynamic> map) {
    return ResponseRestaurant(
      restaurants: List<Restaurants>.from(
        (map['restaurants'] as List<int>).map<Restaurants>(
          (x) => Restaurants.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResponseRestaurant.fromJson(String source) {
    try {
      final List<dynamic> jsonList = jsonDecode(source) as List<dynamic>;
      return ResponseRestaurant(
        restaurants: jsonList.map((json) => Restaurants.fromMap(json)).toList(),
      );
    } catch (e) {
      throw FormatException('invalid Json Fomrat: $e');
    }
  }

  @override
  String toString() => 'ResponseRestaurant(restaurants: $restaurants)';

  @override
  bool operator ==(covariant ResponseRestaurant other) {
    if (identical(this, other)) return true;

    return listEquals(other.restaurants, restaurants);
  }

  @override
  int get hashCode => restaurants.hashCode;
}
