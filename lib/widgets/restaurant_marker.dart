import 'package:flutter/material.dart';
import '../models/restaurant.dart';

/// 식당 마커 정보창 위젯
class RestaurantMarker extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback? onTap;

  const RestaurantMarker({
    Key? key,
    required this.restaurant,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (restaurant.imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    restaurant.imageUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.address,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
} 