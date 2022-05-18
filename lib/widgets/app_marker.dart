import 'package:event_app/blocs/map_bloc.dart';
import 'package:event_app/constants/constants.dart';
import 'package:event_app/models/point.dart';
import 'package:event_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

class AppMarker extends StatelessWidget {
  final Point point;
  final int index;
  const AppMarker({Key? key, required this.point, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<MapBloc>().add(MapUpateCoordinatesEvent(
            coordinates: LatLng(point.coordinates.latitude, point.coordinates.longitude), index: index));
      },
      child: Column(
        children: [
          Expanded(
            child: EventPopup(
              isOpen: point.opened,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SvgPicture.asset(
            'assets/markers/event.svg',
            height: iconSize,
            color: point.private ? Colors.red : markerColor,
          ),
        ],
      ),
    );
  }
}
