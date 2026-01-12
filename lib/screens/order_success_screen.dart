import 'package:flutter/material.dart';
import 'dart:math';

import 'package:food_app/screens/location_picker_screen.dart';
import 'package:food_app/screens/restaurant_list_screen.dart';
import 'package:food_app/services/payment_service.dart';

class OrderSuccessScreen extends StatefulWidget {
  final double totalPrice;
  const OrderSuccessScreen({super.key, required this.totalPrice});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> {
  final PaymentService paymentService = PaymentService();
  String generateID(int length) {
    const chars = 'ZXCVBNMLKJHGFDSAQWERTYUIOP0987654321';
    Random random = Random();
    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  late String orderID;

  @override
  void initState() {
    orderID = generateID(10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: media.height * 0.08),
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 120,
              shadows: [
                BoxShadow(
                  color: Color(0x08e069).withOpacity(0.72),
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 0,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: media.width * 0.5,
              child: Text(
                'Order Placed Successfully',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: media.width * 0.9,
              child: Text(
                'Thank you for your order! We\'re preparing it with care.',
                style: TextStyle(color: Colors.black54, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 15,
                  ),
                  child: ValueListenableBuilder(
                    valueListenable: paymentService.paymentnotifier,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          _rowOrder(
                            'Order ID',
                            orderID,
                            Icon(Icons.insert_drive_file, color: Colors.green),
                          ),
                          const SizedBox(height: 20),
                          _rowOrder(
                            'Restaurant',
                            value.first.restaurants.name,
                            Icon(Icons.restaurant, color: Colors.green),
                          ),
                          const SizedBox(height: 20),
                          _rowOrder(
                            'Estimated Delivery',
                            '${value.first.restaurants.deliveryTime} min',
                            Icon(Icons.av_timer_rounded, color: Colors.green),
                          ),
                          const SizedBox(height: 20),
                          _rowOrder(
                            'Total amount',
                            '\$ ${widget.totalPrice.toStringAsFixed(2)}',
                            Icon(Icons.money, color: Colors.green),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(media.width * 0.9, 60),

                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: Colors.green),
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationPickerScreen(),
                  ),
                );
              },
              label: Text('Trace Your order', style: TextStyle(fontSize: 18)),
              icon: Icon(Icons.track_changes, size: 25),
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(media.width * 0.9, 60),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 2, color: Colors.green),
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RestaurantListScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              label: Text(
                'Back to Home',
                style: TextStyle(color: Colors.green, fontSize: 18),
              ),
              icon: Icon(Icons.home, color: Colors.green, size: 25),
            ),
          ],
        ),
      ),
    );
  }

  Row _rowOrder(String title, String idtitle, Icon icon) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                icon,
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              idtitle,
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
