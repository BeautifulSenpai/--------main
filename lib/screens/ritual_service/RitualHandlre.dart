import 'package:flutter/material.dart';
import 'package:navigator/screens/ritual_service/SpeakRitualServiceInfo.dart';
import 'package:navigator/screens/ritual_service/ShowRitualServicesInfo.dart';

class RitualHandler {
  static const double ritualLatitude = 54.018162;
  static const double ritualLongitude = 38.297166;
  static const double distanceThreshold = 0.001;

  static void handleMapTap(
      BuildContext context, double latitude, double longitude) {
    if ((latitude - ritualLatitude).abs() < distanceThreshold &&
        (longitude - ritualLongitude).abs() < distanceThreshold) {
      ShowRitualServicesInfo().show(context);
      SpeakRitualServiceInfo().speakRitualInfo();
    }
  }
}
