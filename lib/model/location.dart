import 'package:geolocator/geolocator.dart';

class LiveLocation {
  double? latitude;
  double? longitude;

  Future<void> getLiveLocation() async {
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
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  void setLocationCoordinate(double? longitude, double? latitude) {
    this.longitude = longitude;
    this.latitude = latitude;
  }

  @override
  String toString() {
    return 'LiveLocation{latitude: $latitude, longitude: $longitude}';
  }
}
