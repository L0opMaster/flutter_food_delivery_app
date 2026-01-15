// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:food_app/models/food_item.dart';
import 'package:food_app/models/restaurant.dart';
import 'package:food_app/screens/cart_screen.dart';
import 'package:food_app/screens/menu_detial_item_screen.dart';
import 'package:food_app/screens/restaurant_list_screen.dart';
import 'package:food_app/screens/reviews_screen.dart';
import 'package:food_app/services/fooditem_service.dart';
import 'package:food_app/widgets/appbar_cart_icon.dart';

/// =====================================================
/// RESTAURANT DETAIL SCREEN
/// =====================================================
class RestaurantDetailScreen extends StatefulWidget {
  final Restaurants restaurants;

  const RestaurantDetailScreen({super.key, required this.restaurants});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  /// -------------------------------
  /// CONTROLLERS & SERVICES
  /// -------------------------------
  late TabController _tabController;
  final FooditemService fooditemService = FooditemService();

  /// -------------------------------
  /// DATA
  /// -------------------------------
  late Future<List<FoodItem>> foodItem;

  @override
  void initState() {
    super.initState();

    /// Initialize tab controller (skip first category)
    _tabController = TabController(
      length: widget.restaurants.categories.skip(1).length,
      vsync: this,
    );

    /// Fetch food items
    foodItem = fooditemService.fecthingFoodProduct();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(media),
          _buildRestaurantInfo(media, context),
          _buildTabBarHeader(),
          _buildTabBarContent(),
        ],
      ),
    );
  }

  /// =====================================================
  /// SLIVER APP BAR (IMAGE + ACTIONS)
  /// =====================================================
  SliverAppBar _buildSliverAppBar(Size media) {
    return SliverAppBar(
      expandedHeight: media.width * 0.8,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,

      /// BACKGROUND IMAGE
      flexibleSpace: FlexibleSpaceBar(
        background: Image.network(
          widget.restaurants.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              color: Colors.black45,
              child: const Center(
                child: Icon(
                  Icons.restaurant_menu_outlined,
                  size: 150,
                  color: Colors.green,
                ),
              ),
            );
          },
        ),
      ),

      /// BACK BUTTON
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 25),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RestaurantListScreen()),
          );
        },
      ),

      /// CART BUTTON
      actions: [AppbarCartIcon(navigator: CartScreen())],
    );
  }

  /// =====================================================
  /// RESTAURANT INFORMATION SECTION
  /// =====================================================
  SliverToBoxAdapter _buildRestaurantInfo(Size media, BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        width: double.infinity,
        height: media.width * 0.86,
        color: const Color.fromARGB(199, 200, 230, 201),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleAndRating(context),
            const SizedBox(height: 10),
            _buildDescription(context),
            const SizedBox(height: 10),
            _buildCategoryChips(context),
            const SizedBox(height: 15),
            _buildInfoCards(media, context),
            const SizedBox(height: 20),
            _buildReviewButton(context),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// TITLE + RATING
  /// =====================================================
  Widget _buildTitleAndRating(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.restaurants.name,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Container(
          width: 60,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.white, size: 16),
              Text(
                ' ${widget.restaurants.rating}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// =====================================================
  /// DESCRIPTION
  /// =====================================================
  Widget _buildDescription(BuildContext context) {
    return Text(
      widget.restaurants.description,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Colors.black54,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  /// =====================================================
  /// CATEGORY CHIPS
  /// =====================================================
  Widget _buildCategoryChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: widget.restaurants.categories.map((cat) {
        return Chip(
          label: Text(cat),
          backgroundColor: Colors.grey[150],
          side: const BorderSide(width: 0.7, color: Colors.grey),
          labelStyle: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: Colors.black54),
        );
      }).toList(),
    );
  }

  /// =====================================================
  /// INFO CARDS (TIME / MIN ORDER / FEE)
  /// =====================================================
  Widget _buildInfoCards(Size media, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoCard(
          media,
          context,
          icon: Icons.av_timer,
          title: 'Delivery Time',
          value: '${widget.restaurants.deliveryTime} min',
        ),
        _buildInfoCard(
          media,
          context,
          icon: Icons.card_travel,
          title: 'Minimum Order',
          value: '\$ ${widget.restaurants.minimumOrder.toStringAsFixed(2)}',
        ),
        _buildInfoCard(
          media,
          context,
          icon: Icons.delivery_dining,
          title: 'Delivery Fee',
          value: '\$ ${widget.restaurants.deliveryFee}',
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    Size media,
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: media.width * 0.3,
      height: media.width * 0.29,
      decoration: BoxDecoration(
        color: const Color(0x90EEEEEE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.5, color: const Color(0x529E9E9E)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: Colors.green),
          const SizedBox(height: 5),
          Text(title, style: Theme.of(context).textTheme.titleSmall),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  /// =====================================================
  /// REVIEW BUTTON
  /// =====================================================
  Widget _buildReviewButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReviewsScreen()),
        );
      },
      child: Container(
        height: 50,
        width: 230,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 2, color: Colors.black38),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star_border, color: Colors.green),
            const SizedBox(width: 10),
            Text(
              'See Reviews (${widget.restaurants.reviewCount})',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.green,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// =====================================================
  /// TAB BAR HEADER
  /// =====================================================
  SliverPersistentHeader _buildTabBarHeader() {
    return SliverPersistentHeader(
      delegate: TabBarHeader(
        tabBar: TabBar(
          controller: _tabController,
          labelColor: Colors.green,
          indicatorColor: Colors.green,
          unselectedLabelColor: Colors.black,
          tabs: widget.restaurants.categories
              .skip(1)
              .map((cat) => Tab(text: cat))
              .toList(),
        ),
      ),
    );
  }

  /// =====================================================
  /// TAB BAR CONTENT
  /// =====================================================
  SliverFillRemaining _buildTabBarContent() {
    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: widget.restaurants.categories.skip(1).map((cat) {
          return FutureBuilder<List<FoodItem>>(
            future: foodItem,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No product Food found'));
              }

              final matchCategoryItem = snapshot.data!
                  .where(
                    (food) => food.category.toLowerCase() == cat.toLowerCase(),
                  )
                  .toList();

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MenuDetialFoodItemScreen(
                  matchCategoryItem: matchCategoryItem,
                  restaurants: widget.restaurants,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

/// =====================================================
/// TAB BAR HEADER DELEGATE
/// =====================================================
class TabBarHeader extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  TabBarHeader({required this.tabBar});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.transparent, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;
}
