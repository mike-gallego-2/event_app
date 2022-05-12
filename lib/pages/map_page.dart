import 'package:event_app/blocs/map_bloc.dart';
import 'package:event_app/constants/colors.dart';
import 'package:event_app/widgets/profile_avatar.dart';
import 'package:event_app/widgets/swipe_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final MapController _mapController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) {
        if (state.mapStatus == MapStateStatus.updating) {
          _mapController.move(state.coordinates, 10);
        }
      },
      builder: (context, state) {
        if (state.mapStatus == MapStateStatus.success || state.mapStatus == MapStateStatus.updating) {
          return Scaffold(
            body: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: state.coordinates,
                    zoom: 10.0,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate: dotenv.get('MAPBOX_URL'),
                      additionalOptions: {
                        'accessToken': dotenv.get('MAPBOX_ACCESS_TOKEN'),
                        'id': dotenv.get('MAPBOX_ID'),
                      },
                      attributionBuilder: (_) {
                        return const Text("© OpenStreetMap contributors");
                      },
                    ),
                    MarkerLayerOptions(
                      markers: [
                        Marker(
                          width: 80.0,
                          height: 80.0,
                          point: state.coordinates,
                          builder: (ctx) => Image.asset(
                            'assets/markers/house.png',
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        const SwipeIndicator(),
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ProfileAvatar(
                                onTap: () => context
                                    .read<MapBloc>()
                                    .add(MapUpateCoordinatesEvent(coordinates: LatLng(41.2404965, -75.8485746))),
                              ),
                              const ProfileAvatar(),
                              const ProfileAvatar(),
                              const ProfileAvatar(),
                              const ProfileAvatar(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ))
              ],
            ),
          );
        } else {
          return Container(
            color: primaryColor,
          );
        }
      },
    );
  }
}
