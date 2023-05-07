import 'package:flutter/cupertino.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/models/km_system_settings.dart';
import 'package:one_km/src/models/user_coordinates.dart';
import 'package:sizer/sizer.dart';

String kmLogoChatDistanceTextGetter(String chatDistance, UserCoordinates userCoordinates) {
  switch (chatDistance) {
    case "world":
      return "World";
    case "country":
      return userCoordinates.isoCountryCode;
    case "city":
      return userCoordinates.administrativeArea;
    case 'district':
      return userCoordinates.locality;
    case 'postal':
      return "null";
    default: //postal
      return "null";
  }
}

// ignore: non_constant_identifier_names
Widget appLogo(double Sizex, KmSystemSettings kmSystemSettings, UserCoordinates userCoordinates) {
  return Container(
      margin: EdgeInsets.all(8.0 * Sizex),
      padding: EdgeInsets.all(15.0 * Sizex),
      decoration: BoxDecoration(border: Border.all(color: ColorConstants.designGreen, width: 2 * Sizex)),
      child: Column(
        children: [
          Text(
            "1KM",
            style: TextStyle(backgroundColor: ColorConstants.transparentColor, color: ColorConstants.designGreen, fontSize: 42.sp * Sizex, wordSpacing: 1.7, letterSpacing: 1.6),
          ),
          kmLogoChatDistanceTextGetter(kmSystemSettings.chatDistance, userCoordinates) != "null"
              ? const SizedBox(
                  height: 8,
                )
              : const SizedBox(),
          kmLogoChatDistanceTextGetter(kmSystemSettings.chatDistance, userCoordinates) != "null"
              ? Text(
                  kmLogoChatDistanceTextGetter(kmSystemSettings.chatDistance, userCoordinates),
                  style:
                      TextStyle(backgroundColor: ColorConstants.transparentColor, color: ColorConstants.designGreen, fontSize: 12.sp * Sizex, wordSpacing: 1.7, letterSpacing: 1.6),
                )
              : const SizedBox()
        ],
      ));
}
