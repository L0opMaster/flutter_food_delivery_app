import 'package:flutter/material.dart';
import 'package:food_app/services/payment_service.dart';

class AppbarCartIcon extends StatefulWidget {
  final Widget navigator;
  const AppbarCartIcon({super.key, required this.navigator});

  @override
  State<AppbarCartIcon> createState() => _AppbarCartIconState();
}

class _AppbarCartIconState extends State<AppbarCartIcon> {
  final PaymentService paymentService = PaymentService();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: paymentService.badge,
      builder: (context, badge, child) {
        if (badge > 0) {
          return Stack(
            children: [
              IconButton(
                onPressed: () {
                  paymentService.clearBadge();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => widget.navigator),
                  );
                },
                icon: Icon(Icons.shopping_cart, size: 30),
              ),
              Positioned(
                top: 0,
                right: 5,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '$badge',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return IconButton(
          icon: Icon(Icons.shopping_cart, size: 30),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => widget.navigator),
            );
          },
        );
      },
    );
  }
}
