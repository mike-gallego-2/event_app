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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: double.infinity,
                  child: Padding(
                    padding: largePadding,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        AppText(
                          text: 'Michael Gallego',
                          fontWeight: bold,
                          fontSize: headerText,
                        ),
                        ProfileAvatar()
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: double.infinity,
                      child: Center(
                        child: Container(
                          height: 65,
                          margin: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: primaryColorOpaque,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: BackdropFilter(
                              filter: imageFilter,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    AppText(text: 'Expand more option', fontWeight: bold, fontSize: headerText),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 30,
                                      color: textColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
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
