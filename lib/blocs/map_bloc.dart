import 'package:bloc/bloc.dart';
import 'package:event_app/repositories/map_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository mapRepository;
  MapBloc({required this.mapRepository})
      : super(MapState(coordinates: LatLng(0, 0), mapStatus: MapStateStatus.initial)) {
    on<MapInitializeCoordinatesEvent>((event, emit) async {
      emit(state.copyWith(mapStatus: MapStateStatus.processing));
      var coordinates = await mapRepository.getCurrentLocation();
      if (coordinates != null) {
        emit(state.copyWith(coordinates: coordinates, mapStatus: MapStateStatus.success));
      } else {
        emit(state.copyWith(mapStatus: MapStateStatus.error));
      }
    });
  }
}
