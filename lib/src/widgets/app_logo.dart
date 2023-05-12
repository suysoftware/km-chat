import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/models/km_system_settings.dart';
import 'package:one_km/src/models/user_coordinates.dart';
import 'package:sizer/sizer.dart';

Widget kmLogoChatBottomTextGetter(String chatDistance, UserCoordinates userCoordinates, String chatSectionEnum, String targetName) {
  var text = "";

  switch (chatSectionEnum) {
    case "public":
      switch (chatDistance) {
        case "world":
          text = "World";
          break;
        case "country":
          text = userCoordinates.isoCountryCode;
          break;
        case "city":
          text = userCoordinates.administrativeArea;
          break;
        case 'district':
          text = userCoordinates.locality;
          break;
        case 'postal':
          return const SizedBox();
        default: //postal
          return const SizedBox();
      }
      break;
    case "private":
      text = targetName;
      break;

    case "club":
      text = targetName;
      break;
    case "bot":
      return Text(
        "ben botum",
        style: TextStyle(backgroundColor: ColorConstants.transparentColor, color: ColorConstants.designGreen, fontSize: 12.sp, wordSpacing: 1.7, letterSpacing: 1.6),
      );
    default:
      return const SizedBox();
  }

  return Text(
    text,
    style: TextStyle(backgroundColor: ColorConstants.transparentColor, color: ColorConstants.designGreen, fontSize: 12.sp, wordSpacing: 1.7, letterSpacing: 1.6),
  );
}

// ignore: non_constant_identifier_names
Widget appLogo(double Sizex, KmSystemSettings kmSystemSettings, UserCoordinates userCoordinates, String chatSectionEnum, String targetName,String botGifLink) {
  return chatSectionEnum == "bot"
      ? Padding(
          padding: EdgeInsets.only(top: 4.h),
          child: Image.asset(
            botGifLink,
            height: 100,
            width: 100,
          ),
          /*Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
                //lerp border
                border: Border.lerp(Border(bottom: BorderSide()), Border(bottom: BorderSide()), 0.5),
                borderRadius: BorderRadius.circular(200)),
            child: SvgPicture.asset(
              "assets/svg/ai_icon.svg",
              height: 100,
              width: 100,
            ),
          ),*/
        )
      : Container(
          margin: EdgeInsets.all(8.0 * Sizex),
          padding: EdgeInsets.all(15.0 * Sizex),
          decoration: BoxDecoration(border: Border.all(color: ColorConstants.designGreen, width: 2 * Sizex)),
          child: Column(
            children: [
              Text(
                "1KM",
                style:
                    TextStyle(backgroundColor: ColorConstants.transparentColor, color: ColorConstants.designGreen, fontSize: 42.sp * Sizex, wordSpacing: 1.7, letterSpacing: 1.6),
              ),
              Text(
                "MENU",
                style: TextStyle(
                    backgroundColor: ColorConstants.transparentColor, color: ColorConstants.designGreen, fontSize: 13.sp * Sizex, wordSpacing: 1.7, letterSpacing: 1.6, height: 1),
              ),
              // kmLo
              //logoChatBottomTextGetter(kmSystemSettings.chatDistance, userCoordinates, chatSectionEnum,targetName)
              /*    kmLogoChatDistanceTextGetter(kmSystemSettings.chatDistance, userCoordinates) != "null"
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
              : const SizedBox()*/
            ],
          ));
}
