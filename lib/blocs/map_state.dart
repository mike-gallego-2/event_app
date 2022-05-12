part of 'map_bloc.dart';

class MapState extends Equatable {
  final LatLng coordinates;
  final MapStateStatus mapStatus;

  const MapState({
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

  @override
  List<Object?> get props => [coordinates, mapStatus];
}

enum MapStateStatus {
  initial,
  updating,
  processing,
  success,
  error,
}
