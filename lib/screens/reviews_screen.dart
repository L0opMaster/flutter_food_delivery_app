import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_app/models/review.dart';
import 'package:food_app/services/review_service.dart';
import 'package:intl/intl.dart';

/// =====================================================
/// REVIEWS SCREEN
/// =====================================================
class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen>
    with SingleTickerProviderStateMixin {
  /// -------------------------------
  /// TAB TITLES
  /// -------------------------------
  final List<String> reAndwri = ['Reviews', 'Write Review'];

  /// -------------------------------
  /// CONTROLLERS
  /// -------------------------------
  late TabController _tabController;
  final TextEditingController textEditingController = TextEditingController();

  /// -------------------------------
  /// DATA
  /// -------------------------------
  late Future<List<Review>> reviews;
  final int maxText = 500;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: reAndwri.length, vsync: this);
    reviews = ReviewService().fechReview();
  }

  @override
  void dispose() {
    _tabController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: reAndwri.length,
      child: FutureBuilder<List<Review>>(
        future: reviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reviews found'));
          }

          final reviewsData = snapshot.data!;
          final int totalRating = reviewsData.length;
          final double averageRating =
              reviewsData.fold(0, (sum, item) => sum + item.rating) /
              totalRating;
          final Map<int, int> ratingCount = {
            5: reviewsData.where((r) => r.rating == 5).length,
            4: reviewsData.where((r) => r.rating == 4).length,
            3: reviewsData.where((r) => r.rating == 3).length,
            2: reviewsData.where((r) => r.rating == 2).length,
            1: reviewsData.where((r) => r.rating == 1).length,
          };

          return Scaffold(
            body: CustomScrollView(
              slivers: [
                _buildAppBar(),
                _buildTabBarHeader(),
                _buildTabBarContent(
                  averageRating,
                  totalRating,
                  ratingCount,
                  reviewsData,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// =====================================================
  /// APP BAR
  /// =====================================================
  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      title: const Text(
        'Reviews & Rating',
        style: TextStyle(fontWeight: FontWeight.w100),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios, size: 25),
      ),
    );
  }

  /// =====================================================
  /// TAB BAR HEADER
  /// =====================================================
  SliverPersistentHeader _buildTabBarHeader() {
    return SliverPersistentHeader(
      delegate: TabBarsHeader(
        tabBar: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: reAndwri.map((title) => Tab(text: title)).toList(),
        ),
      ),
    );
  }

  /// =====================================================
  /// TAB BAR CONTENT
  /// =====================================================
  SliverFillRemaining _buildTabBarContent(
    double averageRating,
    int totalRating,
    Map<int, int> ratingCount,
    List<Review> reviewsData,
  ) {
    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: reAndwri.map((tab) {
          if (tab == 'Reviews') {
            return _reviewSection(
              averageRating,
              totalRating,
              ratingCount,
              reviewsData,
            );
          } else {
            return _writeReviewSection();
          }
        }).toList(),
      ),
    );
  }

  /// =====================================================
  /// REVIEW SECTION
  /// =====================================================
  Widget _reviewSection(
    double averageRating,
    int totalRating,
    Map<int, int> ratingCount,
    List<Review> reviewsData,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ratingSummary(averageRating, totalRating, ratingCount),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _tabController.animateTo(1);
            },
            icon: const Icon(Icons.edit),
            label: const Text('Write a Review', style: TextStyle(fontSize: 15)),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: reviewsData.length,
              itemBuilder: (context, index) {
                final review = reviewsData[index];
                return _reviewCard(review);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// =====================================================
  /// WRITE REVIEW SECTION
  /// =====================================================
  Widget _writeReviewSection() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Rate your experience',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tap a star to rate',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 10),
          RatingBar(
            initialRating: 0,
            minRating: 1,
            allowHalfRating: true,
            itemCount: 5,
            glowColor: Colors.black,
            unratedColor: Colors.grey[400],
            ratingWidget: RatingWidget(
              full: const Icon(Icons.star, color: Colors.amber),
              half: const Icon(Icons.star_half, color: Colors.amber),
              empty: const Icon(Icons.star, color: Colors.grey),
            ),
            onRatingUpdate: (rating) {},
          ),
          const SizedBox(height: 10),
          const Text(
            'Write your review',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.green),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: textEditingController,
              maxLines: null,
              expands: true,
              maxLength: maxText,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Write your review...',
                counterText: '',
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: textEditingController,
                builder: (context, value, child) {
                  return Text('${value.text.length}/$maxText');
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(fixedSize: const Size(0, 50)),
            onPressed: () {},
            child: const Text('Submit Review', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  /// =====================================================
  /// RATING SUMMARY
  /// =====================================================
  Widget _ratingSummary(
    double averageRating,
    int totalRating,
    Map<int, int> ratingCount,
  ) {
    return Row(
      children: [
        Column(
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            RatingBarIndicator(
              rating: averageRating,
              itemCount: 5,
              itemSize: 25,
              itemBuilder: (context, index) =>
                  const Icon(Icons.star, color: Colors.amber),
            ),
            Text(
              '$totalRating reviews',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: ratingCount.entries
                .map(
                  (entry) => _ratingProgress(
                    star: entry.key,
                    count: entry.value,
                    total: totalRating,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  /// =====================================================
  /// REVIEW CARD
  /// =====================================================
  Widget _reviewCard(Review review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),

          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.39),
              blurRadius: 6,
              offset: const Offset(0, 0),
              spreadRadius: -1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _userInfo(review),
                  RatingBarIndicator(
                    rating: review.rating.toDouble(),
                    itemCount: 5,
                    itemSize: 20,
                    itemBuilder: (_, __) =>
                        const Icon(Icons.star, color: Colors.amberAccent),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(review.comment),
              const SizedBox(height: 25),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.thumb_up_alt_outlined,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    'Helpful (${review.helpful})',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userInfo(Review review) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22.5,
          backgroundColor: Colors.green,
          child: Text(
            review.userName[0],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.userName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat('dd MMM yyyy').format(review.createdAt),
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }
}

/// =====================================================
/// RATING PROGRESS BAR
/// =====================================================
Widget _ratingProgress({
  required int star,
  required int count,
  required int total,
}) {
  return Row(
    children: [
      Text(
        '$star',
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      const SizedBox(width: 5),
      const Icon(Icons.star, size: 16, color: Colors.amber),
      const SizedBox(width: 7),
      Expanded(
        child: LinearProgressIndicator(
          value: total == 0 ? 0 : count / total,
          color: Colors.amber,
          backgroundColor: Colors.grey[400],
          minHeight: 6,
        ),
      ),
      const SizedBox(width: 20),
      Text('$count', style: const TextStyle(color: Colors.black54)),
    ],
  );
}

/// =====================================================
/// TAB BAR HEADER DELEGATE
/// =====================================================
class TabBarsHeader extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  TabBarsHeader({required this.tabBar});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.green, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;
}
