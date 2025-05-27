import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../models/business.dart';
import '../services/business_service.dart';

class BusinessProvider with ChangeNotifier {
  final BusinessService _businessService = BusinessService();
  List<Business> _businesses = [];
  final Set<String> _favoriteIds = {};
  bool _isLoading = false;
  String? _error;
  Position? _currentPosition;
  bool _isLocationServiceEnabled = false;

  List<Business> get businesses => _businesses;
  List<Business> get favoriteBusinesses => 
      _businesses.where((business) => _favoriteIds.contains(business.id)).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;
  Position? get currentPosition => _currentPosition;
  bool get isLocationServiceEnabled => _isLocationServiceEnabled;

  Future<void> _checkLocationService() async {
    try {
      _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_isLocationServiceEnabled) {
        throw Exception('Location services are disabled. Please enable location services in your device settings.');
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      await _checkLocationService();

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied. Please grant location permission to use this feature.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied. Please enable location permission in app settings.');
      }

      // Get last known position first
      Position? lastKnownPosition = await Geolocator.getLastKnownPosition();
      if (lastKnownPosition != null) {
        debugPrint('Last known position: ${lastKnownPosition.latitude}, ${lastKnownPosition.longitude}');
      }

      // Get current position with high accuracy
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: 10),
      );

      if (_currentPosition == null) {
        throw Exception('Failed to get current location');
      }

      debugPrint('Current position: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
      debugPrint('Location accuracy: ${_currentPosition!.accuracy} meters');
      debugPrint('Location altitude: ${_currentPosition!.altitude} meters');
      debugPrint('Location speed: ${_currentPosition!.speed} m/s');
      debugPrint('Location heading: ${_currentPosition!.heading} degrees');
      debugPrint('Location timestamp: ${_currentPosition!.timestamp}');

      // Verify if the location is reasonable (not in the middle of the ocean or extreme values)
      if (_currentPosition!.latitude < -90 || _currentPosition!.latitude > 90 ||
          _currentPosition!.longitude < -180 || _currentPosition!.longitude > 180) {
        throw Exception('Invalid location coordinates received');
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> searchBusinesses({
    String? query,
    String? type,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Get current location if not already available
      if (_currentPosition == null) {
        await _getCurrentLocation();
      }

      if (_currentPosition == null) {
        throw Exception('Current location not available');
      }

      debugPrint('Searching businesses near: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');

      _businesses = await _businessService.getNearbyBusinesses(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        query: query,
        type: type,
      );

      debugPrint('Found ${_businesses.length} businesses');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> refreshLocation() async {
    try {
      _currentPosition = null;
      _error = null;
      notifyListeners();
      
      await _checkLocationService();
      await _getCurrentLocation();
      await searchBusinesses();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<Business?> getBusinessDetails(String businessId) async {
    try {
      return await _businessService.getBusinessDetails(businessId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  bool isFavorite(String businessId) => _favoriteIds.contains(businessId);

  void toggleFavorite(String businessId) {
    if (_favoriteIds.contains(businessId)) {
      _favoriteIds.remove(businessId);
    } else {
      _favoriteIds.add(businessId);
    }
    notifyListeners();
  }

  void addBusiness(Business business) {
    _businesses.add(business);
    notifyListeners();
  }

  void removeBusiness(String businessId) {
    _businesses.removeWhere((business) => business.id == businessId);
    _favoriteIds.remove(businessId);
    notifyListeners();
  }

  void updateBusiness(Business updatedBusiness) {
    final index = _businesses.indexWhere((b) => b.id == updatedBusiness.id);
    if (index != -1) {
      _businesses[index] = updatedBusiness;
      notifyListeners();
    }
  }

  void clearBusinesses() {
    _businesses.clear();
    _favoriteIds.clear();
    notifyListeners();
  }
} 