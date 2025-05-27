import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/business_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/business_details_screen.dart';

class BusinessListScreen extends StatelessWidget {
  const BusinessListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<BusinessProvider, AuthProvider>(
      builder: (context, businessProvider, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Businesses'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: businessProvider.businesses.isEmpty
              ? const Center(
                  child: Text('No businesses found'),
                )
              : ListView.builder(
                  itemCount: businessProvider.businesses.length,
                  itemBuilder: (context, index) {
                    final business = businessProvider.businesses[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(business.name[0]),
                        ),
                        title: Text(business.name),
                        subtitle: Text(business.address),
                        trailing: IconButton(
                          icon: Icon(
                            businessProvider.isFavorite(business.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: businessProvider.isFavorite(business.id)
                                ? Colors.red
                                : null,
                          ),
                          onPressed: () {
                            businessProvider.toggleFavorite(business.id);
                          },
                        ),
                        onTap: () {
                          // Navigate to business details and remove profile from stack
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BusinessDetailsScreen(
                                business: business,
                              ),
                            ),
                            (route) => route.isFirst, // Keep only the first route (home)
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
} 