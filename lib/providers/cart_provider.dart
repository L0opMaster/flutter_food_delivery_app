// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:food_app/models/food_item.dart';
import 'package:food_app/models/restaurant.dart';

/// CartProvider represents a cart item in the user's cart.
/// It holds the food item, its restaurant, and the quantity.
class CartProvider {
  // ----------------------------
  // Fields
  // ----------------------------
  final FoodItem foodItem;
  final Restaurants restaurants;
  int quantity;

  CartProvider({
    required this.foodItem,
    required this.restaurants,
    required this.quantity,
  });

  // ----------------------------
  // Calculated Properties
  // ----------------------------

  /// Subtotal before tax
  double get subTotal => foodItem.price * quantity;

  /// Tax (10% of subtotal)
  double get tax => subTotal * 0.10;

  /// Total price including tax
  // double get itemTotal => subTotal + tax + restaurants.deliveryFee;

  // ----------------------------
  // Serialization: Convert to Map / JSON
  // ----------------------------

  /// Convert CartProvider to Map
  Map<String, dynamic> toMap() {
    return {
      'foodItem': foodItem.toMap(),
      'restaurants': restaurants.toMap(),
      'quantity': quantity,
    };
  }

  /// Create CartProvider from Map
  factory CartProvider.fromMap(Map<String, dynamic> map) {
    return CartProvider(
      foodItem: FoodItem.fromMap(map['foodItem'] as Map<String, dynamic>),
      restaurants: Restaurants.fromMap(
        map['restaurants'] as Map<String, dynamic>,
      ),
      quantity: map['quantity'] as int,
    );
  }

  /// Convert CartProvider to JSON string
  String toJson() => json.encode(toMap());

  /// Create CartProvider from JSON string
  factory CartProvider.fromJson(String source) =>
      CartProvider.fromMap(json.decode(source) as Map<String, dynamic>);
}
