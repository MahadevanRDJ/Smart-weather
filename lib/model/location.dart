import 'package:geolocator/geolocator.dart';

class LiveLocation {
  double? latitude;
  double? longitude;

  Future<void> getLiveLocation() async {
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
