// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:food_app/models/restaurant.dart';

/// A Card widget that displays restaurant details for the cart screen.
class RestaurantCart extends StatelessWidget {
  final Restaurants res;

  const RestaurantCart({super.key, required this.res});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        height: 360,
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            // ----------------------------
            // Restaurant Image & Info Overlay
            // ----------------------------
            Stack(
              children: [
                // Restaurant Image
                Image.network(
                  res.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 50,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                ),

                // Open/Close Status
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: res.isOpen ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      child: Text(
                        res.isOpen ? 'Open' : 'Close',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ),
                ),

                // Delivery Time
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0x5E000000),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.av_timer, size: 15, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(
                          '${res.deliveryTime} min',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ----------------------------
            // Restaurant Details
            // ----------------------------
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Name & Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        res.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Container(
                        height: 30,
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.star, size: 15, color: Colors.white),
                              Text(
                                '${res.rating}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Description
                  Text(
                    res.description,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.black54,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                  ),
                  const SizedBox(height: 15),

                  // Categories as Chips
                  Wrap(
                    spacing: 7,
                    children: res.categories.map((category) {
                      return Chip(
                        visualDensity: VisualDensity(vertical: -4),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 0, color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        label: Text(category),
                        backgroundColor: const Color(0x7EE1EBF8),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(color: Colors.black54),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 15),

                  // Delivery Fee & Minimum Order
                  Row(
                    children: [
                      const Icon(Icons.motorcycle_sharp, size: 15),
                      Text(
                        '  \$${res.deliveryFee} delivery fee',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.card_travel, size: 15),
                      Text(
                        '   ${res.minimumOrder} minimum',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
