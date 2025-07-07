import 'package:flutter/foundation.dart';

/// Restaurant 데이터 모델
class Restaurant {
  final int id;
  final String name;
  final String description;
  final double lat;
  final double lng;
  final String address;
  final String imageUrl;
  final DateTime createdAt;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.lat,
    required this.lng,
    required this.address,
    required this.imageUrl,
    required this.createdAt,
  });

  /// Supabase에서 받아온 Map을 Restaurant 객체로 변환
  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String? ?? '',
      lat: (map['lat'] as num).toDouble(),
      lng: (map['lng'] as num).toDouble(),
      address: map['address'] as String? ?? '',
      imageUrl: map['image_url'] as String? ?? '',
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  /// Restaurant 객체를 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'lat': lat,
      'lng': lng,
      'address': address,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// 복사본 생성 (필드 일부만 변경 가능)
  Restaurant copyWith({
    int? id,
    String? name,
    String? description,
    double? lat,
    double? lng,
    String? address,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
} 