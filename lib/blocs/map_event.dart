part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class MapInitializeCoordinatesEvent extends MapEvent {}

class MapUpateCoordinatesEvent extends MapEvent {
  final LatLng coordinates;
  final int index;
  MapUpateCoordinatesEvent({required this.coordinates, required this.index});
}
