part of 'map_bloc.dart';

class MapState {
  final LatLng coordinates;
  final MapStateStatus mapStatus;

  MapState({
    required this.coordinates,
    required this.mapStatus,
  });

  MapState copyWith({
    LatLng? coordinates,
    MapStateStatus? mapStatus,
  }) {
    return MapState(
      coordinates: coordinates ?? this.coordinates,
      mapStatus: mapStatus ?? this.mapStatus,
    );
  }
}

enum MapStateStatus {
  initial,
  processing,
  success,
  error,
}
