import 'package:flutter/foundation.dart';
import '../models/business.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<String> _favoriteIds = {};

  bool isFavorite(String businessId) => _favoriteIds.contains(businessId);

  void toggleFavorite(String businessId) {
    if (_favoriteIds.contains(businessId)) {
      _favoriteIds.remove(businessId);
    } else {
      _favoriteIds.add(businessId);
    }
    notifyListeners();
  }

  List<Business> getFavoriteBusinesses(List<Business> allBusinesses) {
    return allBusinesses.where((business) => _favoriteIds.contains(business.id)).toList();
  }
} 