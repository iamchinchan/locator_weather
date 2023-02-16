import 'package:geolocator/geolocator.dart';

class Location {
  Future<void> checkServiceAndPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // print(permission);
  }

  Future<Position?> getCurrentPosition() async {
    Position? pos;
    try {
      await checkServiceAndPermission();
    } catch (e) {
      print(e);
      return pos;
    }
    pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low); // print(pos.latitude);
    return pos;
  }

  Future<Position?> getLastPosition() async {
    Position? pos;
    try {
      await checkServiceAndPermission();
    } catch (e) {
      print(e);
      return pos;
    }
    pos = await Geolocator.getLastKnownPosition();
    return pos;
  }
}
