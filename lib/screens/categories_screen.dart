import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  static const List<Map<String, dynamic>> categories = [
    {'name': 'Hotels', 'icon': Icons.hotel, 'type': 'lodging'},
    {'name': 'Restaurants', 'icon': Icons.restaurant, 'type': 'restaurant'},
    {'name': 'Cafes', 'icon': Icons.local_cafe, 'type': 'cafe'},
    {'name': 'Shopping', 'icon': Icons.shopping_bag, 'type': 'store'},
    {'name': 'Entertainment', 'icon': Icons.movie, 'type': 'movie_theater'},
    {'name': 'Health & Fitness', 'icon': Icons.fitness_center, 'type': 'gym'},
    {'name': 'Beauty & Spa', 'icon': Icons.spa, 'type': 'beauty_salon'},
    {'name': 'Education', 'icon': Icons.school, 'type': 'school'},
    {'name': 'Automotive', 'icon': Icons.directions_car, 'type': 'car_dealer'},
    {'name': 'Home Services', 'icon': Icons.home_repair_service, 'type': 'home_goods_store'},
    {'name': 'Professional Services', 'icon': Icons.business, 'type': 'lawyer'},
    {'name': 'Real Estate', 'icon': Icons.home, 'type': 'real_estate_agency'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            elevation: 2,
            child: InkWell(
              onTap: () {
                Navigator.pop(context, category['type']);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category['icon'] as IconData,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category['name'] as String,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 