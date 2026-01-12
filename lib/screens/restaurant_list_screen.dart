import 'package:flutter/material.dart';
import 'package:food_app/models/restaurant.dart';
import 'package:food_app/screens/location_picker_screen.dart';
import 'package:food_app/screens/restaurant_detail_screen.dart';
import 'package:food_app/services/restaurant_service.dart';
import 'package:food_app/widgets/restaurant_cart.dart';

/// =====================================================
/// RESTAURANT LIST SCREEN
/// =====================================================
class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  /// -------------------------------
  /// DATA STATE
  /// -------------------------------
  late Future<List<Restaurants>> restaurant;
  List<Restaurants> allRestaurants = [];
  List<Restaurants> displayRestaurants = [];

  /// -------------------------------
  /// SEARCH & FILTER STATE
  /// -------------------------------
  bool isSearching = false;
  String onSelectedCategory = 'All';

  /// -------------------------------
  /// CATEGORY LIST
  /// -------------------------------
  final List<String> categories = [
    'All',
    'Italian',
    'Pizza',
    'Pasta',
    'American',
    'Burgers',
    'Fast Food',
    'Japanese',
    'Sushi',
    'Cambodia',
    'Soup',
    'Spicy',
    'Mediterranean',
    'Healthy',
    'Vegetarian',
  ];

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  /// =====================================================
  /// LOAD RESTAURANTS FROM API
  /// =====================================================
  void _loadRestaurants() {
    restaurant = RestaurantService().fetchingRestaurant();
  }

  /// =====================================================
  /// SEARCH HANDLER
  /// =====================================================
  void _onSearchChange(String query) {
    setState(() {
      isSearching = query.isNotEmpty;

      if (query.isEmpty) {
        displayRestaurants = allRestaurants;
      } else {
        displayRestaurants = allRestaurants
            .where(
              (res) => res.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  /// =====================================================
  /// SEARCH SELECTION (FROM SUGGESTIONS)
  /// =====================================================
  void _onSelection(Restaurants res) {
    setState(() {
      isSearching = true;
      displayRestaurants = [res];
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchHeader(media),
          Expanded(child: _buildRestaurantBody()),
        ],
      ),
    );
  }

  /// =====================================================
  /// APP BAR
  /// =====================================================
  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Food Delivery'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.location_on, size: 25),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LocationPickerScreen()),
            );
          },
        ),
      ],
    );
  }

  /// =====================================================
  /// SEARCH HEADER
  /// =====================================================
  Widget _buildSearchHeader(Size media) {
    return Container(
      width: media.width,
      height: 85,
      color: Colors.green,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: SearchAnchor(
        builder: (context, controller) {
          return SearchBar(
            controller: controller,
            hintText: 'Search Restaurant',
            onChanged: _onSearchChange,
            leading: const Icon(Icons.search),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide.none,
              ),
            ),
            trailing: [
              if (controller.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.clear();
                    _onSearchChange('');
                  },
                ),
            ],
          );
        },
        suggestionsBuilder: (context, controller) {
          final query = controller.text.toLowerCase();
          final filtered = allRestaurants
              .where((res) => res.name.toLowerCase().contains(query))
              .toList();

          return filtered.map((res) {
            return ListTile(
              title: Text(res.name),
              onTap: () {
                controller.closeView(res.name);
                _onSearchChange(res.name);
                _onSelection(res);
              },
            );
          }).toList();
        },
      ),
    );
  }

  /// =====================================================
  /// MAIN BODY (FUTURE BUILDER)
  /// =====================================================
  Widget _buildRestaurantBody() {
    return FutureBuilder<List<Restaurants>>(
      future: restaurant,
      builder: (context, snapshot) {
        /// LOADING
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        /// ERROR
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        /// EMPTY
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No restaurants found'));
        }

        /// INIT DATA ONCE
        if (allRestaurants.isEmpty) {
          allRestaurants = snapshot.data!;
          displayRestaurants = allRestaurants;
        }

        /// SEARCH RESULT VIEW
        if (isSearching) {
          return _buildSearchListView();
        }

        /// CATEGORY FILTER VIEW
        return _buildCategoryView();
      },
    );
  }

  /// =====================================================
  /// CATEGORY FILTER VIEW
  /// =====================================================
  Widget _buildCategoryView() {
    final filteredByCategory = onSelectedCategory == 'All'
        ? allRestaurants
        : allRestaurants.where((res) {
            return res.categories.any(
              (cat) => cat.toLowerCase() == onSelectedCategory.toLowerCase(),
            );
          }).toList();

    return Column(
      children: [
        _buildCategoryChips(),
        const SizedBox(height: 10),
        Expanded(child: _buildRestaurantList(filteredByCategory)),
      ],
    );
  }

  /// =====================================================
  /// CATEGORY CHIPS
  /// =====================================================
  Widget _buildCategoryChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 10,
          children: categories.map((cat) {
            return FilterChip(
              label: Text(cat),
              selected: onSelectedCategory == cat,
              onSelected: (selected) {
                setState(() {
                  onSelectedCategory = selected ? cat : 'All';
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  /// =====================================================
  /// RESTAURANT CARD LIST
  /// =====================================================
  Widget _buildRestaurantList(List<Restaurants> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final res = list[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RestaurantDetailScreen(restaurants: res),
                ),
              );
            },
            child: RestaurantCart(res: res),
          ),
        );
      },
    );
  }

  /// =====================================================
  /// SEARCH RESULT LIST
  /// =====================================================
  Widget _buildSearchListView() {
    if (displayRestaurants.isEmpty) {
      return const Center(
        child: Text(
          'No Restaurants Found',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: displayRestaurants.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final res = displayRestaurants[index];
        return ListTile(
          leading: Image.network(
            res.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return SizedBox(
                width: 50,
                height: 50,
                child: Center(
                  child: Icon(
                    Icons.restaurant_menu,
                    color: Colors.green,
                    size: 15,
                  ),
                ),
              );
            },
          ),
          title: Text(res.name),
          subtitle: Text('Rating: ${res.rating}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(restaurants: res),
              ),
            );
          },
        );
      },
    );
  }
}
