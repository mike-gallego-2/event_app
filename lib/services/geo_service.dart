import 'package:either_dart/either.dart';
import 'package:geolocator/geolocator.dart';

class GeoService {
  Future<Either<Position, bool>> getCurrentLocation() async {
    if (await checkPermission()) {
      return Left(await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high));
    } else {
      var permission = await Geolocator.requestPermission();
      if (permission.index == LocationPermission.always.index ||
          permission.index == LocationPermission.whileInUse.index) {
        return Left(await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high));
      } else {
        return const Right(false);
      }
    }
  }

  Future<bool> checkPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission.index == LocationPermission.always.index ||
        permission.index == LocationPermission.whileInUse.index) {
      return true;
    } else {
      return false;
    }
  }
}
