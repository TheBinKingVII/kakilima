import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_header.dart';
import '../widgets/merchant_info_card.dart';
import '../widgets/product_list_item.dart';

class ProductPage extends GetView<ProductController> {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    Get.put(ProductController());

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header with background image
              const ProductHeader(),

              // Spacing for card
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),

              // Product list
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                sliver: Obx(() => SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = controller.products[index];
                          return ProductListItem(product: product);
                        },
                        childCount: controller.products.length,
                      ),
                    )),
              ),

              // Bottom spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              ),
            ],
          ),
          
          // Merchant card positioned on top of background
          Positioned(
            top: 130,
            left: 16,
            right: 16,
            child: const MerchantInfoCard(),
          ),
        ],
      ),
    );
  }
}
