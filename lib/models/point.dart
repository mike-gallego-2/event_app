import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Point {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final bool private;
  final GeoPoint coordinates;
  Point(
      {required this.id,
      required this.name,
      required this.description,
      required this.imageUrl,
      required this.private,
      required this.coordinates});
}

class EventPoint extends Point {
  EventPoint({
    required int id,
    required String name,
    required String description,
    required String imageUrl,
    private = false,
    required GeoPoint coordinates,
  }) : super(
            id: id,
            name: name,
            description: description,
            imageUrl: imageUrl,
            private: private,
            coordinates: coordinates);

  factory EventPoint.fromJson(Map<String, dynamic> json) {
    return EventPoint(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      private: json['private'],
      coordinates: json['coordinates'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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

class BasePoint extends Point {
  BasePoint({
    required int id,
    required String name,
    required String description,
    required String imageUrl,
    private = true,
    required GeoPoint coordinates,
  }) : super(
            id: id,
            name: name,
            description: description,
            imageUrl: imageUrl,
            private: private,
            coordinates: coordinates);

  factory BasePoint.fromJson(Map<String, dynamic> json) {
    return BasePoint(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      private: json['private'],
      coordinates: json['coordinates'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
