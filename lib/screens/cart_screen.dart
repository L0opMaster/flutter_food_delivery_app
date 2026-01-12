import 'package:flutter/material.dart';
import 'package:food_app/models/food_item.dart';
import 'package:food_app/providers/cart_provider.dart';
import 'package:food_app/screens/checkout_screen.dart';
import 'package:food_app/services/payment_service.dart';

/// ===============================
/// CART SCREEN
/// ===============================
class CartScreen extends StatefulWidget {
  final FoodItem? foodItem;

  const CartScreen({super.key, this.foodItem});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  /// Payment & cart controller
  final PaymentService paymentService = PaymentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),

      /// Listen to cart changes globally
      body: ValueListenableBuilder<List<CartProvider>>(
        valueListenable: paymentService.paymentnotifier,
        builder: (context, items, child) {
          /// -----------------------------
          /// EMPTY CART VIEW
          /// -----------------------------
          if (items.isEmpty) {
            return _emptyCartView();
          }

          /// -----------------------------
          /// CART CONTENT VIEW
          /// -----------------------------
          return Column(
            children: [_buildOrderingSection(), _buildCheckoutSection()],
          );
        },
      ),
    );
  }

  /// ===============================
  /// EMPTY CART UI
  /// ===============================
  Widget _emptyCartView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.shopping_cart, size: 90, color: Colors.green),
          Text(
            'Empty Cart',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// ORDERING SECTION (LIST + HEADER)
  /// ===============================
  Expanded _buildOrderingSection() {
    return Expanded(
      child: ValueListenableBuilder<List<CartProvider>>(
        valueListenable: paymentService.paymentnotifier,
        builder: (context, items, child) {
          final restaurantName = items.isNotEmpty
              ? items.first.restaurants.name
              : '';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRestaurantHeader(restaurantName),
              Expanded(child: _buildCartList(items)),
            ],
          );
        },
      ),
    );
  }

  /// ===============================
  /// RESTAURANT HEADER
  /// ===============================
  Widget _buildRestaurantHeader(String restaurantName) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ordering from', style: TextStyle(color: Colors.black54)),
          Text(
            restaurantName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// CART ITEMS LIST
  /// ===============================
  ListView _buildCartList(List<CartProvider> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final cart = items[index];
        final food = cart.foodItem;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: _buildCartItem(cart, food),
        );
      },
    );
  }

  /// ===============================
  /// SINGLE CART ITEM CARD
  /// ===============================
  Widget _buildCartItem(CartProvider cart, FoodItem food) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          children: [
            _buildItemMainRow(cart, food),
            const SizedBox(height: 10),
            _buildSpecialInstructionField(),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// ITEM INFO + QUANTITY CONTROLS
  /// ===============================
  Widget _buildItemMainRow(CartProvider cart, FoodItem food) {
    return Row(
      children: [
        _buildFoodImage(food.imageUrl),
        const SizedBox(width: 15),
        Expanded(child: _buildItemDetails(cart, food)),
      ],
    );
  }

  /// ===============================
  /// FOOD IMAGE
  /// ===============================
  Widget _buildFoodImage(String imageUrl) {
    return SizedBox(
      height: 80,
      width: 80,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.restaurant_menu, color: Colors.green),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  /// ===============================
  /// ITEM DETAILS
  /// ===============================
  Widget _buildItemDetails(CartProvider cart, FoodItem food) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildItemTitle(food),
        Text('\$${food.price}', style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 10),
        _buildQuantityRow(cart, food),
      ],
    );
  }

  /// ===============================
  /// ITEM TITLE + DELETE
  /// ===============================
  Widget _buildItemTitle(FoodItem food) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          food.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () {
            final PaymentService paymentService = PaymentService();
            paymentService.removeProduct(food);
          },
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
      ],
    );
  }

  /// ===============================
  /// QUANTITY CONTROLS
  /// ===============================
  Widget _buildQuantityRow(CartProvider cart, FoodItem food) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildQuantityButtons(cart, food),
        Text('\$ ${cart.subTotal.toStringAsFixed(2)}'),
      ],
    );
  }

  Widget _buildQuantityButtons(CartProvider cart, FoodItem food) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black45),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () =>
                paymentService.updateQuantity(food.id, cart.quantity - 1),
          ),
          Text('${cart.quantity}'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final success = paymentService.updateQuantity(
                food.id,
                cart.quantity + 1,
              );
              if (!success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        'You’ve reached the maximum of 5 items for this product.',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xA40A0A0A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    duration: Duration(seconds: 3),
                    backgroundColor: const Color(0xEBFFFFFF),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 3,
                        color: const Color(0x2F000000),
                      ),
                      borderRadius: BorderRadiusGeometry.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// SPECIAL INSTRUCTION FIELD
  /// ===============================
  Widget _buildSpecialInstructionField() {
    return Container(
      height: 60,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: const TextField(
        expands: true,
        maxLines: null,
        decoration: InputDecoration(
          labelText: 'Special instructions:',
          hintText: 'write...',
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// ===============================
  /// CHECKOUT SECTION
  /// ===============================
  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(color: Colors.white),
      child: ValueListenableBuilder<List<CartProvider>>(
        valueListenable: paymentService.paymentnotifier,
        builder: (context, items, child) {
          if (items.isEmpty) return const SizedBox();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPriceRow('Subtotal', paymentService.subTotal),
              SizedBox(height: 5),
              _buildPriceRow('Delivery Fee', paymentService.deliveryFee),
              SizedBox(height: 5),
              _buildPriceRow('Tax & Fees', paymentService.tax),
              SizedBox(height: 5),
              const Divider(thickness: 2),
              _buildPriceRow('Total', paymentService.totalPrice, isTotal: true),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CheckoutScreen()),
                  );
                },
                child: const Text(
                  'Proceed to Checkout',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// ===============================
  /// PRICE ROW
  /// ===============================
  Widget _buildPriceRow(String title, double value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: isTotal
              ? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
              : null,
        ),
        Text(
          '\$ ${value.toStringAsFixed(2)}',
          style: isTotal
              ? const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                )
              : null,
        ),
      ],
    );
  }

  /// ===============================
  /// APP BAR
  /// ===============================
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text('Your Cart'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final PaymentService paymentService = PaymentService();
            paymentService.clearCart();
          },
          child: const Text('Clear All', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
