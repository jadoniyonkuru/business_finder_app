import 'package:cloud_firestore/cloud_firestore.dart';

class Business {
  final String id;
  final String name;
  final String description;
  final String address;
  final double? latitude;
  final double? longitude;
  final double rating;
  final int totalRatings;
  final List<String> photos;
  final String type;
  final bool isOpen;
  final int priceLevel;
  final String website;
  final String phoneNumber;

  Business({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    this.latitude,
    this.longitude,
    this.rating = 0.0,
    this.totalRatings = 0,
    this.photos = const [],
    this.type = 'unknown',
    this.isOpen = false,
    this.priceLevel = 0,
    this.website = '',
    this.phoneNumber = '',
  });

  factory Business.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Business(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      address: data['address'] ?? '',
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: data['totalRatings'] ?? 0,
      photos: List<String>.from(data['photos'] ?? []),
      type: data['type'] ?? 'unknown',
      isOpen: data['isOpen'] ?? false,
      priceLevel: data['priceLevel'] ?? 0,
      website: data['website'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: json['totalRatings'] as int? ?? 0,
      photos: (json['photos'] as List<dynamic>?)?.cast<String>() ?? [],
      type: json['type'] as String? ?? 'unknown',
      isOpen: json['isOpen'] ?? false,
      priceLevel: json['priceLevel'] as int? ?? 0,
      website: json['website'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'totalRatings': totalRatings,
      'photos': photos,
      'type': type,
      'isOpen': isOpen,
      'priceLevel': priceLevel,
      'website': website,
      'phoneNumber': phoneNumber,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'rating': rating,
      'totalRatings': totalRatings,
      'photos': photos,
      'type': type,
      'isOpen': isOpen,
      'priceLevel': priceLevel,
      'website': website,
      'phoneNumber': phoneNumber,
    };
  }

  Business copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    double? rating,
    int? totalRatings,
    List<String>? photos,
    String? type,
    bool? isOpen,
    int? priceLevel,
    String? website,
    String? phoneNumber,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      photos: photos ?? this.photos,
      type: type ?? this.type,
      isOpen: isOpen ?? this.isOpen,
      priceLevel: priceLevel ?? this.priceLevel,
      website: website ?? this.website,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

class Review {
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime timestamp;

  Review({
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      userId: map['userId'],
      userName: map['userName'],
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
} 