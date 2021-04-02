import 'package:flutter/cupertino.dart';
import 'package:prs_staff/model/map/address.dart';

class AppData extends ChangeNotifier {
  Address currentLocation, userLocation;

  void updateCurrentLocation(Address currentAddress) {
    currentLocation = currentAddress;
    notifyListeners();
  }

  void updateUserLocation(Address userAddress) {
    userLocation = userAddress;
    notifyListeners();
  }
}
