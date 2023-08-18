import 'package:flutter/material.dart';
import 'package:navigator/screens/bulldog/ShowBullDogInfo.dart';
import 'package:navigator/screens/bulldog/SpeakBullDogInfo.dart';

class BullDogHandler {
  static const double ritualLatitude = 53.969617;
  static const double ritualLongitude = 38.315070;
  static const double distanceThreshold = 0.001;

  static void handleMapTap(
      BuildContext context, double latitude, double longitude) {
    if ((latitude - ritualLatitude).abs() < distanceThreshold &&
        (longitude - ritualLongitude).abs() < distanceThreshold) {
      ShowBullDogInfo().show(context);
      SpeakBullDogInfo().speakBullDogInfo();
    }
  }
}
