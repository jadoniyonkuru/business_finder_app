class Constants {
  // API Keys
  static const String googlePlacesApiKey = 'AIzaSyDxXxXxXxXxXxXxXxXxXxXxXxXxXxXxXx';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String reviewsCollection = 'reviews';
  
  // App Settings
  static const int searchRadius = 5000; // 5km
  static const int maxResults = 20;
  
  // Error Messages
  static const String locationError = 'Unable to get your location. Please check your location settings.';
  static const String networkError = 'Network error. Please check your internet connection.';
  static const String unknownError = 'An unknown error occurred. Please try again.';
} 