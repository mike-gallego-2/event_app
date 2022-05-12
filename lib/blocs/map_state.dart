part of 'map_bloc.dart';

class MapState extends Equatable {
  final LatLng coordinates;
  final MapStateStatus mapStatus;
  final List<Point> points;

  const MapState({
    required this.coordinates,
    required this.mapStatus,
    required this.points,
  });

  MapState copyWith({
    LatLng? coordinates,
    MapStateStatus? mapStatus,
    List<Point>? points,
  }) {
    return MapState(
      coordinates: coordinates ?? this.coordinates,
      mapStatus: mapStatus ?? this.mapStatus,
      points: points ?? this.points,
    );
  }

  @override
  List<Object?> get props => [coordinates, mapStatus, points];
}

enum MapStateStatus {
  initial,
  updating,
  processing,
  success,
  error,
}
