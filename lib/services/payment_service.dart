import 'package:flutter/cupertino.dart';
import 'package:food_app/models/food_item.dart';
import 'package:food_app/models/restaurant.dart';
import 'package:food_app/providers/cart_provider.dart';

/// PaymentService manages the cart, quantities, and price calculations.
/// Implements Singleton pattern to ensure a single instance throughout the app.
class PaymentService {
  // ----------------------------
  // Singleton Pattern
  // ----------------------------
  PaymentService._internal();
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;

  // ----------------------------
  // ValueNotifier to update UI reactively
  // ----------------------------
  final ValueNotifier<List<CartProvider>> paymentnotifier = ValueNotifier([]);

  // limitOrder
  final int maxOrderQuantity = 5;

  // ----------------------------
  // Add Product
  // ----------------------------
  /// Adds a product with default quantity of 1
  /// Returns false if the cart has items from another restaurant
  bool addProduct(FoodItem foodItem, Restaurants restaurants) {
    return addProductWithQuantity(foodItem, 1, restaurants);
  }

  /// Adds product with a specified quantity
  /// Returns false if quantity < 0 or restaurant mismatch
  bool addProductWithQuantity(
    FoodItem foodItem,
    int quantityToAdd,
    Restaurants restaurants,
  ) {
    if (quantityToAdd < 0) return false;

    // Copy current cart items
    final List<CartProvider> currentItem = paymentnotifier.value.toList();

    // Restrict ordering from multiple restaurants
    if (currentItem.isNotEmpty &&
        currentItem[0].restaurants.id != restaurants.id) {
      return false;
    }

    // Check if item already exists in cart
    final index = currentItem.indexWhere(
      (item) => item.foodItem.id == foodItem.id,
    );

    if (index != -1) {
      // Update existing quantity
      currentItem[index].quantity += quantityToAdd;
    } else {
      // Add new item
      currentItem.add(
        CartProvider(
          foodItem: foodItem,
          restaurants: restaurants,
          quantity: quantityToAdd,
        ),
      );
    }

    // Update notifier
    paymentnotifier.value = currentItem;
    return true;
  }

  // ----------------------------
  // Update or Remove Product Quantity
  // ----------------------------
  /// Update quantity of a product by its foodId
  /// Removes item if quantity <= 0
  bool updateQuantity(String foodId, int quantity) {
    if (quantity > maxOrderQuantity) {
      return false;
    }
    final List<CartProvider> currentItem = paymentnotifier.value.toList();
    final index = currentItem.indexWhere((item) => item.foodItem.id == foodId);

    if (index != -1) {
      if (quantity > 0) {
        currentItem[index].quantity = quantity;
      } else {
        currentItem.removeAt(index);
      }
    }

    paymentnotifier.value = currentItem;
    return true;
  }

  // ----------------------------
  // Price Calculations
  // ----------------------------
  /// Sum of all item subtotals
  double get subTotal {
    return paymentnotifier.value.fold(0.0, (sum, item) => sum + item.subTotal);
  }

  /// Sum of all item taxes
  double get tax {
    return paymentnotifier.value.fold(0.0, (sum, item) => sum + item.tax);
  }

  /// Delivery fee from the first restaurant in cart
  double get deliveryFee {
    if (paymentnotifier.value.isEmpty) return 0.0;
    return paymentnotifier.value.first.restaurants.deliveryFee;
  }

  /// Total price including subtotal, tax, and delivery
  double get totalPrice {
    return subTotal + tax + deliveryFee;
  }

  // ----------------------------
  // Optional Helper Methods
  // ----------------------------

  /// Remove an item completely from the cart
  void removeProduct(FoodItem foodItem) {
    updateQuantity(foodItem.id, 0);
  }

  /// Clear all items from cart
  void clearCart() {
    paymentnotifier.value = [];
  }

  ///getQuantity item inCart
  /// Get the quantity of a specific food item in the cart
  /// Get the quantity of a specific food item in the cart
  int getQuantity(String foodId) {
    try {
      final item = paymentnotifier.value.firstWhere(
        (i) => i.foodItem.id == foodId,
      );
      return item.quantity;
    } catch (e) {
      // Item not found in cart
      return 0;
    }
  }
}
