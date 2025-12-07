import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';

class MerchantInfoCard extends GetView<ProductController> {
  const MerchantInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top section: Profile, Name, Address, Share, Edit
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Merchant profile image
                _buildMerchantAvatar(),
                const SizedBox(width: 12),

                // Merchant name and address
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMerchantNameSection(),
                      const SizedBox(height: 4),
                      _buildAddressSection(),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Share and Edit buttons
                _buildActionButtons(),
              ],
            ),

            const SizedBox(height: 16),

            // Bottom section: Rating
            _buildRatingSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMerchantAvatar() {
    return Obx(() => Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.green,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Image.network(
              controller.merchantImage.value,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, size: 30),
                );
              },
            ),
          ),
        ));
  }

  Widget _buildMerchantNameSection() {
    return Obx(() => Text(
          controller.merchantName.value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ));
  }

  Widget _buildAddressSection() {
    return Row(
      children: [
        const Icon(
          Icons.sensors,
          color: Colors.green,
          size: 16,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Obx(() => Text(
                controller.merchantAddress.value,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        // Rating number
        Obx(() => Text(
              controller.merchantRating.value.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            )),
        const SizedBox(width: 12),
        // Star rating and reviews
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Star rating
              Row(
                children: List.generate(5, (index) {
                  return Obx(() => Icon(
                        index < controller.merchantRating.value.floor()
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.orange,
                        size: 18,
                      ));
                }),
              ),
              const SizedBox(height: 2),
              // Total reviews
              Obx(() => Text(
                    '${controller.totalReviews.value} Ulasan',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  )),
            ],
          ),
        ),
        // Arrow button aligned with rating number
        InkWell(
          onTap: () {
            controller.viewRatingDetails();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        GestureDetector(
          onTap: controller.shareProduct,
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.share,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: controller.editProduct,
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
      ],
    );
  }
}
