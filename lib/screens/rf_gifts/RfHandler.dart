import 'package:flutter/material.dart';
import 'package:navigator/screens/rf_gifts/ShowRfGiftsInfo.dart';
import 'package:navigator/screens/rf_gifts/SpeakRfGiftsInfo.dart';

class RfHandler {
  static const double ritualLatitude = 53.962625;
  static const double ritualLongitude = 38.354072;
  static const double distanceThreshold = 0.001;

  static void handleMapTap(
      BuildContext context, double latitude, double longitude) {
    if ((latitude - ritualLatitude).abs() < distanceThreshold &&
        (longitude - ritualLongitude).abs() < distanceThreshold) {
      ShowRfGiftsInfo().show(context);
      SpeakRfGiftsInfo().speakRfInfo();
    }
  }
}
