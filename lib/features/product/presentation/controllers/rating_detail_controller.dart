import 'package:get/get.dart';

class RatingDetailController extends GetxController {
  // Dummy data untuk UI
  final overallRating = 4.0.obs;
  final totalReviews = 1034.obs;
  final merchantName = 'Siomay Hengki'.obs;

  // Rating statistics
  final ratingStats = <Map<String, dynamic>>[
    {'star': 5, 'percentage': 87},
    {'star': 4, 'percentage': 77},
    {'star': 3, 'percentage': 57},
    {'star': 2, 'percentage': 17},
    {'star': 1, 'percentage': 3},
  ].obs;

  // Search query
  final searchQuery = ''.obs;

  // Dummy reviews list
  final reviews = <Map<String, dynamic>>[
    {
      'name': 'Juan Pedro',
      'date': '04/05/2023',
      'rating': 4.7,
      'image': 'https://via.placeholder.com/50',
      'foodImage': 'https://via.placeholder.com/350x200',
      'comment':
          'I recently dined here and I had a good time with my family. The staff were welcoming and really attentive with all our requests.',
    },
    {
      'name': 'Juan Pedro',
      'date': '04/05/2023',
      'rating': 4.7,
      'image': 'https://via.placeholder.com/50',
      'foodImage': 'https://via.placeholder.com/350x200',
      'comment':
          'I recently dined here and I had a good time with my family. The staff were welcoming and really attentive with all our requests.',
    },
    {
      'name': 'Maria Garcia',
      'date': '03/05/2023',
      'rating': 5.0,
      'image': 'https://via.placeholder.com/50',
      'foodImage': 'https://via.placeholder.com/350x200',
      'comment':
          'Amazing food! The taste is authentic and the portion is generous. Will definitely come back again.',
    },
    {
      'name': 'Ahmad Fadli',
      'date': '02/05/2023',
      'rating': 4.5,
      'image': 'https://via.placeholder.com/50',
      'foodImage': 'https://via.placeholder.com/350x200',
      'comment':
          'Sangat enak dan pelayanan ramah. Harga juga terjangkau untuk ukuran makanan sebesar ini.',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize data here if needed
  }

  void searchReviews(String query) {
    searchQuery.value = query;
    // Filter reviews based on search query
    // This will be implemented when connected to backend
  }

  void filterReviews() {
    // Open filter dialog
    Get.snackbar('Filter', 'Filter functionality');
  }
}
