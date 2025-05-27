import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/business.dart';

class BusinessService {
  static const String _overpassApiUrl = 'https://overpass-api.de/api/interpreter';

  Future<List<Business>> getNearbyBusinesses({
    required double latitude,
    required double longitude,
    double radius = 5000,
    String? query,
    String? type,
  }) async {
    try {
      // Build the Overpass QL query to get more comprehensive business data
      final String queryString = '''
        [out:json][timeout:25];
        (
          // Get all nodes with business-related tags
          node["amenity"](around:$radius,$latitude,$longitude);
          node["shop"](around:$radius,$latitude,$longitude);
          node["office"](around:$radius,$latitude,$longitude);
          node["building"="commercial"](around:$radius,$latitude,$longitude);
          node["building"="retail"](around:$radius,$latitude,$longitude);
          node["building"="office"](around:$radius,$latitude,$longitude);
          
          // Get ways (buildings) with business-related tags
          way["amenity"](around:$radius,$latitude,$longitude);
          way["shop"](around:$radius,$latitude,$longitude);
          way["office"](around:$radius,$latitude,$longitude);
          way["building"="commercial"](around:$radius,$latitude,$longitude);
          way["building"="retail"](around:$radius,$latitude,$longitude);
          way["building"="office"](around:$radius,$latitude,$longitude);
        );
        out body;
        >;
        out skel qt;
      ''';

      final response = await http.post(
        Uri.parse(_overpassApiUrl),
        body: queryString,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch data from OpenStreetMap');
      }

      final data = json.decode(response.body);
      final elements = data['elements'] as List;

      final businesses = <Business>[];

      for (var element in elements) {
        try {
          if (element is! Map<String, dynamic>) continue;
          
          final tags = element['tags'] as Map<String, dynamic>?;
          if (tags == null) continue;

          // Get business name from various possible tags
          String name = tags['name'] as String? ?? 
                       tags['brand'] as String? ?? 
                       tags['operator'] as String? ?? 
                       'Unnamed Place';
          
          // Get business type from various possible tags
          String businessType = tags['amenity'] as String? ?? 
                              tags['shop'] as String? ?? 
                              tags['office'] as String? ?? 
                              tags['building'] as String? ?? 
                              'other';

          // Get description from various possible tags
          String description = tags['description'] as String? ?? 
                             tags['note'] as String? ?? 
                             tags['comment'] as String? ?? 
                             '';

          // Get address components
          String address = _buildAddress(tags);

          // Get coordinates
          double? lat;
          double? lon;

          if (element['type'] == 'node') {
            lat = element['lat'] as double?;
            lon = element['lon'] as double?;
          } else if (element['type'] == 'way' && element['center'] != null) {
            final center = element['center'] as Map<String, dynamic>;
            lat = center['lat'] as double?;
            lon = center['lon'] as double?;
          }

          // Skip if we don't have valid coordinates
          if (lat == null || lon == null) continue;

          // Skip if the business is too far away
          final distance = _calculateDistance(latitude, longitude, lat, lon);
          if (distance > radius) continue;

          businesses.add(Business(
            id: element['id'].toString(),
            name: name,
            description: description,
            address: address,
            latitude: lat,
            longitude: lon,
            rating: 0.0, // OpenStreetMap doesn't provide ratings
            totalRatings: 0,
            type: businessType,
            isOpen: true, // We don't have opening hours info
            priceLevel: 0,
          ));
        } catch (e) {
          debugPrint('Error processing business: $e');
          continue;
        }
      }

      // Filter businesses based on query and type
      return businesses.where((business) {
        if (query != null && query.isNotEmpty) {
          return business.name.toLowerCase().contains(query.toLowerCase()) ||
                 business.description.toLowerCase().contains(query.toLowerCase()) ||
                 business.address.toLowerCase().contains(query.toLowerCase());
        }
        if (type != null && type.isNotEmpty) {
          return business.type == type;
        }
        return true;
      }).toList();
    } catch (e) {
      throw Exception('Failed to load businesses: $e');
    }
  }

  String _buildAddress(Map<String, dynamic> tags) {
    final parts = <String>[];
    
    // Try to get street address
    if (tags['addr:street'] != null) {
      parts.add(tags['addr:street']);
      if (tags['addr:housenumber'] != null) {
        parts.add(tags['addr:housenumber']);
      }
    }
    
    // Try to get city/town
    if (tags['addr:city'] != null) {
      parts.add(tags['addr:city']);
    } else if (tags['addr:town'] != null) {
      parts.add(tags['addr:town']);
    }
    
    // Try to get district/neighborhood
    if (tags['addr:district'] != null) {
      parts.add(tags['addr:district']);
    } else if (tags['addr:neighbourhood'] != null) {
      parts.add(tags['addr:neighbourhood']);
    }
    
    // Try to get postcode
    if (tags['addr:postcode'] != null) {
      parts.add(tags['addr:postcode']);
    }
    
    return parts.isEmpty ? 'Address not available' : parts.join(', ');
  }

  Future<Business?> getBusinessDetails(String businessId) async {
    try {
      final String queryString = '''
        [out:json][timeout:25];
        (
          node($businessId);
          way($businessId);
        );
        out body;
        >;
        out skel qt;
      ''';

      final response = await http.post(
        Uri.parse(_overpassApiUrl),
        body: queryString,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch business details');
      }

      final data = json.decode(response.body);
      final elements = data['elements'] as List;
      
      if (elements.isEmpty) {
        return null;
      }

      final element = elements.first;
      if (element is! Map<String, dynamic>) {
        throw Exception('Invalid business data');
      }

      final tags = element['tags'] as Map<String, dynamic>?;
      if (tags == null) {
        throw Exception('No business details available');
      }
      
      String name = tags['name'] as String? ?? 
                   tags['brand'] as String? ?? 
                   tags['operator'] as String? ?? 
                   'Unnamed Place';
      
      String businessType = tags['amenity'] as String? ?? 
                          tags['shop'] as String? ?? 
                          tags['office'] as String? ?? 
                          tags['building'] as String? ?? 
                          'other';

      double? lat;
      double? lon;

      if (element['type'] == 'node') {
        lat = element['lat'] as double?;
        lon = element['lon'] as double?;
      } else if (element['type'] == 'way' && element['center'] != null) {
        final center = element['center'] as Map<String, dynamic>;
        lat = center['lat'] as double?;
        lon = center['lon'] as double?;
      }

      if (lat == null || lon == null) {
        throw Exception('Invalid business location');
      }

      return Business(
        id: element['id'].toString(),
        name: name,
        description: tags['description'] as String? ?? '',
        address: _buildAddress(tags),
        latitude: lat,
        longitude: lon,
        rating: 0.0,
        totalRatings: 0,
        type: businessType,
        isOpen: true,
        priceLevel: 0,
      );
    } catch (e) {
      throw Exception('Failed to load business details: $e');
    }
  }

  double _calculateDistance(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) {
    return Geolocator.distanceBetween(
      startLat,
      startLng,
      endLat,
      endLng,
    );
  }
}

extension on double {
  double toRadians() {
    return this * (3.141592653589793 / 180);
  }
} 