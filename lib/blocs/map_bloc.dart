import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:event_app/models/point.dart';
import 'package:event_app/repositories/map_repository.dart';
import 'package:latlong2/latlong.dart';
import 'package:meta/meta.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapRepository mapRepository;
  MapBloc({required this.mapRepository})
      : super(MapState(coordinates: LatLng(0, 0), mapStatus: MapStateStatus.initial, points: const [])) {
    on<MapInitializeCoordinatesEvent>((event, emit) async {
      emit(state.copyWith(mapStatus: MapStateStatus.processing));
      var coordinates = await mapRepository.getCurrentLocation();
      if (coordinates != null) {
        emit(state.copyWith(coordinates: coordinates));
        var pointStream = mapRepository.getPoints();
        await emit.forEach<QuerySnapshot<Map<String, dynamic>>>(pointStream, onData: (snapshot) {
          List<Point> points = snapshot.docs.map((doc) => EventPoint.fromJson(doc.data())).toList();
          return state.copyWith(mapStatus: MapStateStatus.success, points: points);
        });
      } else {
        emit(state.copyWith(mapStatus: MapStateStatus.error));
      }
    });

    on<MapUpateCoordinatesEvent>((event, emit) {
      List<Point> newPoints = state.points;

      // clear the old points
      for (var point in newPoints) {
        if (point.opened) {
          newPoints[newPoints.indexOf(point)] = newPoints[newPoints.indexOf(point)].copyWith(opened: false);
        }
      }
      // set the new point to opened
      newPoints[event.index] = newPoints[event.index].copyWith(opened: true);
      emit(state.copyWith(mapStatus: MapStateStatus.updating, coordinates: event.coordinates, points: newPoints));
    });
  }
}
