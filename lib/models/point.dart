import 'package:latlong2/latlong.dart';

abstract class Point {
  final LatLng coordinates;
  Point({required this.coordinates});
}

class EventPoint extends Point {
  EventPoint({required LatLng coordinates}) : super(coordinates: coordinates);
}

class UserPoint extends Point {
  UserPoint({required LatLng coordinates}) : super(coordinates: coordinates);
}
