import 'package:flutter/material.dart';
import 'package:food_app/models/food_item.dart';
import 'package:food_app/models/restaurant.dart';
import 'package:food_app/providers/cart_provider.dart';
import 'package:food_app/screens/cart_screen.dart';
import 'package:food_app/screens/restaurant_detail_screen.dart';
import 'package:food_app/services/payment_service.dart';

/// =====================================================
/// MENU SCREEN
/// =====================================================
class MenuDetialFoodItemScreen extends StatefulWidget {
  final List<FoodItem> matchCategoryItem;
  final Restaurants restaurants;

  const MenuDetialFoodItemScreen({
    super.key,
    required this.matchCategoryItem,
    required this.restaurants,
  });

  @override
  State<MenuDetialFoodItemScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuDetialFoodItemScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 0, bottom: 10),
      itemCount: widget.matchCategoryItem.length,
      itemBuilder: (context, index) {
        final item = widget.matchCategoryItem[index];
        return _menuItemCard(context, item);
      },
    );
  }

  Widget _menuItemCard(BuildContext context, FoodItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                DetailMenu(foodItem: item, restaurants: widget.restaurants),
          ),
        ),
        child: Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _foodImage(item),
                const SizedBox(width: 15),
                Expanded(child: _foodInfo(context, item)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _foodImage(FoodItem item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        item.imageUrl,
        height: 100,
        width: 100,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 100,
            height: 100,
            color: const Color(0x87B1B1B1),
            child: const Center(
              child: Icon(
                Icons.event_repeat_rounded,
                size: 30,
                color: Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _foodInfo(BuildContext context, FoodItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 20),
                ),
                Text(
                  '\$${item.price}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.description,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 1),
            Text('${item.rating}'),
            const SizedBox(width: 13),
            _addButton(item, context),
          ],
        ),
      ],
    );
  }

  Widget _addButton(FoodItem item, context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        minimumSize: const Size(0, 32),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {
        final paymentService = PaymentService();
        final added = paymentService.addProduct(item, widget.restaurants);
        if (!added) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'You can only order from one restaurant at a time.',
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: const Text('Add', style: TextStyle(fontSize: 12)),
    );
  }
}

/// =====================================================
/// CLASS DETAIL MENU SCREEN
/// =====================================================
class DetailMenu extends StatefulWidget {
  final FoodItem foodItem;
  final Restaurants restaurants;

  const DetailMenu({
    super.key,
    required this.foodItem,
    required this.restaurants,
  });

  @override
  State<DetailMenu> createState() => _DetailMenuState();
}

class _DetailMenuState extends State<DetailMenu> {
  int upDateQunatity = 1;
  final maxItemForUpdateQuantity = 5;
  final PaymentService paymentService = PaymentService();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              _foodImageSection(media),
              _foodDetailSection(context, media, widget.foodItem),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(
        widget.foodItem.name,
        style: Theme.of(
          context,
        ).textTheme.headlineMedium?.copyWith(color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 30),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                RestaurantDetailScreen(restaurants: widget.restaurants),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart, size: 30),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CartScreen(foodItem: widget.foodItem),
            ),
          ),
        ),
      ],
    );
  }

  Widget _foodImageSection(Size media) {
    return Image.network(
      widget.foodItem.imageUrl,
      width: double.infinity,
      height: media.height * 0.4,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: double.infinity,
          height: media.height * 0.4,
          color: Colors.black26,
          child: const Center(
            child: Icon(Icons.restaurant_menu, size: 90, color: Colors.green),
          ),
        );
      },
    );
  }

  Widget _foodDetailSection(
    BuildContext context,
    Size media,
    FoodItem foodItem,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: media.width * 0.05,
        vertical: media.width * 0.03,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _restaurantInfo(context),
          const SizedBox(height: 10),
          _foodPricing(context),
          const SizedBox(height: 10),
          _foodDescription(),
          const SizedBox(height: 10),
          _foodIngredients(),
          const SizedBox(height: 10),
          _foodType(),
          const SizedBox(height: 10),
          _quantityAndCartSection(media),
          const SizedBox(height: 10),
          _addBottom(foodItem),
        ],
      ),
    );
  }

  Widget _restaurantInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Restaurant',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Colors.black54),
            ),
            Text(
              widget.restaurants.name,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontSize: 28),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber),
            Text(
              '${widget.restaurants.rating}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }

  Widget _foodPricing(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Item: ${widget.foodItem.name}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Text(
          'USD: ${widget.foodItem.price}',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Colors.green),
        ),
      ],
    );
  }

  Widget _foodDescription() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Description',
        style: TextStyle(fontWeight: FontWeight.w400, color: Colors.black45),
      ),
      Text(widget.foodItem.description),
    ],
  );

  Widget _foodIngredients() => Row(
    children: [
      const Text(
        'Ingredients:',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black38,
          fontSize: 18,
        ),
      ),
      const SizedBox(width: 5),
      Expanded(
        child: Wrap(
          spacing: 6,
          children: widget.foodItem.ingredients
              .map((ing) => Chip(label: Text(ing)))
              .toList(),
        ),
      ),
    ],
  );

  Widget _foodType() => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Calories: ${widget.foodItem.calories}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            'Stock: ${widget.foodItem.isAvailable ? 'Available' : 'Out of Stock'}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            'Taste: ${widget.foodItem.isSpicy ? 'Spicy' : 'Not Spicy'}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
      const SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Vegan: ${widget.foodItem.isVegan ? 'Yes' : 'No'}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            'Vegetarian: ${widget.foodItem.isVegetarian ? 'Yes' : 'No'}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Preparation Time: ${widget.foodItem.preparationTime} min',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Text(
            'Review Count: ${widget.foodItem.reviewCount}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    ],
  );

  Widget _quantityAndCartSection(Size media) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Number of portions',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () => upDateQunatity > 1
                  ? setState(() {
                      upDateQunatity--;
                    })
                  : ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('0'))),
              icon: const Icon(
                Icons.remove_circle_outline,
                size: 30,
                color: Colors.green,
              ),
            ),
            Text('$upDateQunatity'),
            IconButton(
              onPressed: () {
                if (upDateQunatity < maxItemForUpdateQuantity) {
                  setState(() {
                    upDateQunatity++;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(
                        child: Text(
                          'You can only add 5 items for this product.',
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
              icon: const Icon(
                Icons.add_circle_outline,
                size: 30,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  ElevatedButton _addBottom(FoodItem food) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(fixedSize: Size(0, 50)),
      onPressed: () {
        final PaymentService paymentService = PaymentService();
        final incart = paymentService.getQuantity(food.id);
        if (incart + upDateQunatity <= maxItemForUpdateQuantity) {
          paymentService.addProductWithQuantity(
            widget.foodItem,
            upDateQunatity,
            widget.restaurants,
          );
        } else {
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
                side: BorderSide(width: 3, color: const Color(0x2F000000)),
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
      label: Text('Add to cart'),
      icon: Icon(Icons.shopping_cart),
    );
  }
}
