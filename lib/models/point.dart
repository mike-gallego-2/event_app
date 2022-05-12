import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Point {
  final String name;
  final String description;
  final String imageUrl;
  final bool private;
  final GeoPoint coordinates;
  Point(
      {required this.name,
      required this.description,
      required this.imageUrl,
      required this.private,
      required this.coordinates});
}

class EventPoint extends Point {
  EventPoint({
    required String name,
    required String description,
    required String imageUrl,
    private = false,
    required GeoPoint coordinates,
  }) : super(name: name, description: description, imageUrl: imageUrl, private: private, coordinates: coordinates);

  factory EventPoint.fromJson(Map<String, dynamic> json) {
    return EventPoint(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      private: json['private'],
      coordinates: json['coordinates'],
    );
  }
}

class BasePoint extends Point {
  BasePoint({
    required String name,
    required String description,
    required String imageUrl,
    private = true,
    required GeoPoint coordinates,
  }) : super(name: name, description: description, imageUrl: imageUrl, private: private, coordinates: coordinates);

  factory BasePoint.fromJson(Map<String, dynamic> json) {
    return BasePoint(
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      private: json['private'],
      coordinates: json['coordinates'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'private': private,
      'coordinates': {
        'latitude': coordinates.latitude,
        'longitude': coordinates.longitude,
      },
    };
  }
}
