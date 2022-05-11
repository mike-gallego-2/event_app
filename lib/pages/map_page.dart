import 'package:event_app/blocs/map_bloc.dart';
import 'package:event_app/constants/colors.dart';
import 'package:event_app/widgets/profile_avatar.dart';
import 'package:event_app/widgets/swipe_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final _mapController;

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state.mapStatus == MapStateStatus.success) {
          return Scaffold(
            body: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: state.coordinates,
                    zoom: 13.0,
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
                            children: const [
                              ProfileAvatar(),
                              ProfileAvatar(),
                              ProfileAvatar(),
                              ProfileAvatar(),
                              ProfileAvatar(),
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
