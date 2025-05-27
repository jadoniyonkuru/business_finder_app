import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/business.dart';

class PlacesService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  
  String get _apiKey {
    final apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Google Places API key not found. Please add it to your .env file.');
    }
    return apiKey;
  }

  Future<List<Business>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    double radius = 5000,
    String? type,
    String? query,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/nearbysearch/json?'
        'location=$latitude,$longitude'
        '&radius=$radius'
        '${type != null ? '&type=$type' : ''}'
        '${query != null ? '&keyword=$query' : ''}'
        '&key=$_apiKey'
      );

      final response = await http.get(url);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load places: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      
      if (data['status'] != 'OK' && data['status'] != 'ZERO_RESULTS') {
        throw Exception('Places API error: ${data['status']}');
      }

      if (data['status'] == 'ZERO_RESULTS') {
        return [];
      }

      final results = data['results'] as List;
      return results.map((place) => Business(
        id: place['place_id'],
        name: place['name'],
        description: place['vicinity'] ?? '',
        address: place['vicinity'] ?? '',
        latitude: place['geometry']['location']['lat'],
        longitude: place['geometry']['location']['lng'],
        rating: (place['rating'] ?? 0.0).toDouble(),
        totalRatings: place['user_ratings_total'] ?? 0,
        photos: (place['photos'] as List?)?.map((photo) => 
          'https://maps.googleapis.com/maps/api/place/photo?'
          'maxwidth=400'
          '&photo_reference=${photo['photo_reference']}'
          '&key=$_apiKey'
        ).toList() ?? [],
        type: place['types']?.first ?? 'unknown',
        isOpen: place['opening_hours']?['open_now'] ?? false,
        priceLevel: place['price_level'] ?? 0,
        website: place['website'] ?? '',
        phoneNumber: place['formatted_phone_number'] ?? '',
      )).toList();
    } catch (e) {
      throw Exception('Failed to load nearby places: $e');
    }
  }

  Future<Business?> getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/details/json?'
        'place_id=$placeId'
        '&fields=name,formatted_address,geometry,rating,user_ratings_total,'
        'photos,types,opening_hours,price_level,website,formatted_phone_number'
        '&key=$_apiKey'
      );

      final response = await http.get(url);
      
      if (response.statusCode != 200) {
        throw Exception('Failed to load place details: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      
      if (data['status'] != 'OK') {
        throw Exception('Places API error: ${data['status']}');
      }

      final result = data['result'];
      return Business(
        id: placeId,
        name: result['name'],
        description: result['formatted_address'] ?? '',
        address: result['formatted_address'] ?? '',
        latitude: result['geometry']['location']['lat'],
        longitude: result['geometry']['location']['lng'],
        rating: (result['rating'] ?? 0.0).toDouble(),
        totalRatings: result['user_ratings_total'] ?? 0,
        photos: (result['photos'] as List?)?.map((photo) => 
          'https://maps.googleapis.com/maps/api/place/photo?'
          'maxwidth=400'
          '&photo_reference=${photo['photo_reference']}'
          '&key=$_apiKey'
        ).toList() ?? [],
        type: result['types']?.first ?? 'unknown',
        isOpen: result['opening_hours']?['open_now'] ?? false,
        priceLevel: result['price_level'] ?? 0,
        website: result['website'] ?? '',
        phoneNumber: result['formatted_phone_number'] ?? '',
      );
    } catch (e) {
      throw Exception('Failed to load place details: $e');
    }
  }

  String getPhotoUrl(String photoReference, {int maxWidth = 400}) {
    return '$_baseUrl/photo?maxwidth=$maxWidth&photo_reference=$photoReference&key=$_apiKey';
  }
} 