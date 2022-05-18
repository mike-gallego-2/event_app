import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/services/services.dart';
import 'package:latlong2/latlong.dart';

class MapRepository {
  Future<LatLng?> getCurrentLocation() async {
    var position = await GeoService().getCurrentLocation();
    if (position.isLeft) {
      return LatLng(position.left.latitude, position.left.longitude);
    } else {
      return null;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPoints() {
    return FirestoreService().getPoints();
  }
}
