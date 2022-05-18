import 'package:event_app/blocs/map_bloc.dart';
import 'package:event_app/constants/constants.dart';
import 'package:event_app/models/models.dart';
import 'package:event_app/utilities/cached_tile_provider.dart';
import 'package:event_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  late final MapController _mapController;

  void _animatedMapMove(LatLng desinationLocation, double destinationZoom) {
    final _latTween = Tween<double>(begin: _mapController.center.latitude, end: desinationLocation.latitude);
    final _lngTween = Tween<double>(begin: _mapController.center.longitude, end: desinationLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destinationZoom);

    var animationController = AnimationController(
      duration: const Duration(
        milliseconds: 500,
      ),
      vsync: this,
    );

    Animation<double> animation = CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn);

    animationController.addListener(() {
      _mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)), _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.dispose();
      } else if (status == AnimationStatus.dismissed) {
        animationController.dispose();
      }
    });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapState>(
      listener: (context, state) {
        if (state.mapStatus == MapStateStatus.updating) {
          _animatedMapMove(state.coordinates, zoomMove);
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
                    zoom: zoom,
                    minZoom: zoomMin,
                    maxZoom: zoomMax,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    plugins: [
                      MarkerClusterPlugin(),
                    ],
                  ),
                  layers: [
                    TileLayerOptions(
                      tileProvider: const CachedTileProvider(),
                      urlTemplate: dotenv.get('MAPBOX_URL'),
                      additionalOptions: {
                        'accessToken': dotenv.get('MAPBOX_ACCESS_TOKEN'),
                        'id': dotenv.get('MAPBOX_ID'),
                      },
                      attributionBuilder: (_) {
                        return const AppText(text: copyright);
                      },
                    ),
                    MarkerClusterLayerOptions(
                      anchor: AnchorPos.align(AnchorAlign.center),
                      maxClusterRadius: 30,
                      size: const Size(40, 40),
                      fitBoundsOptions: const FitBoundsOptions(
                        padding: EdgeInsets.all(50),
                      ),
                      animationsOptions: const AnimationsOptions(zoom: Duration(milliseconds: 800)),
                      builder: (context, marker) {
                        return const Icon(
                          Icons.local_attraction,
                          color: Colors.orange,
                        );
                      },
                      onClusterTap: (node) {
                        _animatedMapMove(node.point, zoomMove);
                      },
                      zoomToBoundsOnClick: false,
                      markers: state.points.map((point) => _customMarker(point, state.points.indexOf(point))).toList(),
                    ),
                  ],
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: double.infinity,
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
                              children: const [],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
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

  Marker _customMarker(Point point, int index) {
    return Marker(
      width: markerWidth,
      height: markerHeight,
      anchorPos: AnchorPos.align(AnchorAlign.center),
      point: LatLng(point.coordinates.latitude, point.coordinates.longitude),
      builder: (ctx) => AppMarker(point: point, index: index),
    );
  }
}
