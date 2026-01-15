import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/providers/cart_provider.dart';
import 'package:food_app/screens/order_success_screen.dart';
import 'package:food_app/services/payment_service.dart';
import 'package:food_app/widgets/mini_map_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _textController = TextEditingController();
  final int maxText = 30;
  final PaymentService paymentService = PaymentService();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  final LatLng _deliveryLatLng = const LatLng(11.6693, 105.0670);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _orderSection(),
              const SizedBox(height: 15),
              _deliveryAddress(),
              const SizedBox(height: 15),
              _paymentMethod(),
              const SizedBox(height: 15),
              _instructions(),
              const SizedBox(height: 15),
              ValueListenableBuilder<List<CartProvider>>(
                valueListenable: paymentService.paymentnotifier,
                builder: (context, value, child) {
                  // final total = value[0].itemTotal;
                  final subtotal = value.fold<double>(
                    0,
                    (sum, value) =>
                        sum + (value.foodItem.price * value.quantity),
                  );
                  final tax = value.fold<double>(
                    0,
                    (sum, value) => value.tax + sum,
                  );
                  final double deliveryFee =
                      value.first.restaurants.deliveryFee;
                  final totalPrice = deliveryFee + subtotal + tax;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(0, 50),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderSuccessScreen(totalPrice: totalPrice,),
                        ),
                      );
                    },
                    child: Text(
                      'Place Order: \$${totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                },
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Card _instructions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.find_in_page_rounded, color: Colors.green),
                SizedBox(width: 10),
                Text(
                  'Special Instructions',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.black12),
              ),
              child: TextField(
                controller: _textController,
                expands: true,
                maxLines: null,
                maxLength: maxText,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  hintText: 'Write...',
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _textController,
                  builder: (context, value, _) {
                    return Text('${value.text.length} / $maxText');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card _paymentMethod() {
    int selected = 1;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.payment, color: Colors.green),
                    SizedBox(width: 10),
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: Colors.green),
                  label: const Text(
                    'Add',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Column(
              children: List.generate(
                2,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selected = index;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              selected == index
                                  ? Icons.circle_rounded
                                  : Icons.circle_outlined,
                              color: selected == index
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Visa ending in 1234',
                                  style: TextStyle(fontSize: 18),
                                ),
                                if (index == 0)
                                  Text(
                                    'Default',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                    ),
                                  ),

                                // Text(
                                //   'Default',
                                //   style: TextStyle(
                                //     fontSize: 15,
                                //     color: Colors.black54,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.payment, size: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _deliveryAddress() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.green),
                SizedBox(width: 10),
                Text(
                  'Delivery Address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Color(0x895F5F5F)),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.green),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 250,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Current Location',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'Street, Village, Community, District, Province',
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.location_on,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                  const Divider(thickness: 1, height: 1),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MiniMap(latLng: _deliveryLatLng),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.my_location, color: Colors.green),
                SizedBox(width: 10),
                Text(
                  'Use Current Location',
                  style: TextStyle(color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _orderSection() {
    final cartItems = paymentService.paymentnotifier.value;

    // Group items by restaurant name
    final Map<String, List<CartProvider>> itemsByRestaurant = {};

    for (final item in cartItems) {
      // final restaurantName = item.restaurants.description;
      // Create list if restaurant not exists

      // on this case we create key for map if item.restaurants.name already as key do nothing (that mean do return)
      //if item.restaurants.name not exist(that mean not yet take as key) return  emptylist and take item.restaurants.name as key
      itemsByRestaurant.putIfAbsent(
        item.restaurants.name,
        () => <CartProvider>[],
      );
      // Add item to that restaurant
      itemsByRestaurant[item.restaurants.name]!.add(item);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            ...itemsByRestaurant.entries.map((entry) {
              final restaurantName = entry.key;
              final items = entry.value;

              final deliveryFee = items.first.restaurants.deliveryFee;

              // final subtotal = items.fold<double>(
              //   0,
              //   (sum, item) => sum + (item.foodItem.price * item.quantity),
              // );
              final subtotal = items.fold<double>(
                0,
                (sum, items) => items.subTotal + sum,
              );
              final tax = items.fold<double>(0, (sum, item) => sum + item.tax);

              final total = subtotal + deliveryFee + tax;
              // final total = items.first.itemTotal;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name
                  Text(
                    restaurantName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Divider(),

                  // Items
                  ...items.map((item) {
                    final itemTotal = item.foodItem.price * item.quantity;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity}x ${item.foodItem.name}',
                            ),
                          ),
                          Text('\$${itemTotal.toStringAsFixed(2)}'),
                        ],
                      ),
                    );
                  }),

                  const Divider(),
                  _summaryRow('Subtotal', subtotal),
                  _summaryRow('Delivery Fee', deliveryFee),
                  _summaryRow('Tax & Fees', tax),

                  const Divider(),

                  _summaryRow('Total', total, isTotal: true),
                  const SizedBox(height: 10),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                : null,
          ),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: isTotal
                ? const TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
