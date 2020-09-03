import 'package:geolocator/geolocator.dart';

class UserLocation {
  Position currentLocation;
  double latitude;
  double longitude;
  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  getUserLocation() async {
    currentLocation = await locateUser();
    latitude = currentLocation.latitude;
    longitude = currentLocation.longitude;
  }

  updateLatLng() {
    getUserLocation();
  }
}
