part of 'map_bloc.dart';

@immutable
abstract class MapEvent {}

class MapInitializeCoordinatesEvent extends MapEvent {}

class MapUpateCoordinatesEvent extends MapEvent {}
