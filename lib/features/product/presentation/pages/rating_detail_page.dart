import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/rating_detail_controller.dart';
import '../widgets/rating_statistics_widget.dart';
import '../widgets/review_item_widget.dart';

class RatingDetailPage extends GetView<RatingDetailController> {
  const RatingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    Get.put(RatingDetailController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
              onPressed: () => Get.back(),
              padding: EdgeInsets.zero,
              iconSize: 14,
            ),
          ),
        ),
        title: const Text(
          'Ulasan',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          // Overall rating section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Rating in horizontal layout (aligned left)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Big rating number
                      Obx(() => Text(
                            controller.overallRating.value.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      const SizedBox(width: 16),
                      // Stars and total reviews
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Stars
                          Row(
                            children: List.generate(5, (index) {
                              return Obx(() => Icon(
                                    index < controller.overallRating.value.floor()
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.orange,
                                    size: 24,
                                  ));
                            }),
                          ),
                          const SizedBox(height: 4),
                          // Total reviews
                          Obx(() => Text(
                                '${controller.totalReviews.value} Ulasan',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Rating statistics bars
                  Obx(() => Column(
                        children: controller.ratingStats
                            .map((stat) => RatingStatisticsWidget(
                                  star: stat['star'],
                                  percentage: stat['percentage'],
                                ))
                            .toList(),
                      )),
                ],
              ),
            ),
          ),

          // Search and filter section
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Search field
                    Expanded(
                      child: TextField(
                        onChanged: controller.searchReviews,
                        decoration: InputDecoration(
                          hintText: 'Cari',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    // Divider
                    Container(
                      width: 1,
                      height: 24,
                      color: Colors.grey[300],
                    ),
                    // Filter button
                    GestureDetector(
                      onTap: controller.filterReviews,
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.tune,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),

          // Reviews list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: Obx(() => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final review = controller.reviews[index];
                      return ReviewItemWidget(review: review);
                    },
                    childCount: controller.reviews.length,
                  ),
                )),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
        ],
      ),
    );
  }
}
