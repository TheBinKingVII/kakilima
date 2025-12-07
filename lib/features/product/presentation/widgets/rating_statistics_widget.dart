import 'package:flutter/material.dart';

class RatingStatisticsWidget extends StatelessWidget {
  final int star;
  final int percentage;

  const RatingStatisticsWidget({
    super.key,
    required this.star,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Star number
          Text(
            '$star',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          // Star icon
          const Icon(
            Icons.star,
            color: Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          // Progress bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Percentage
          SizedBox(
            width: 35,
            child: Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
