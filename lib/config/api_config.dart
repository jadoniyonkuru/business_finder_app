import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get googlePlacesApiKey {
    final apiKey = dotenv.env['GOOGLE_PLACES_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Google Places API key not found. Please check your .env file.');
    }
    return apiKey;
  }
} 