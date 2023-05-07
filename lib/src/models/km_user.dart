// To parse this JSON data, do
//
//     final kmUser = kmUserFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:one_km/src/models/user_coordinates.dart';

import 'user_blocked_map.dart';
import 'user_notification_settings.dart';

KmUser kmUserFromJson(String str) => KmUser.fromJson(json.decode(str));

String kmUserToJson(KmUser data) => json.encode(data.toJson());

class KmUser {
  late UserCoordinates userCoordinates;
  late String userName;
  late String userSecretPassword;
  late String userTitle;
  late String userUid;
  late int userExperiencePoints;
  late int userLevel;
  late Map<String, UserBlockedMap> userBlockedMap;
  late bool userHasBanned;
  late String userAvatar;
  late bool userIsOnline;
  late Timestamp userLastActivityDate;
  late String userMessageToken;
  late UserNotificationSettings userNotificationSettings;
  late List<dynamic> userClubs;

  KmUser();

  KmUser.withInfo(
    this.userCoordinates,
    this.userName,
    this.userSecretPassword,
    this.userTitle,
    this.userUid,
    this.userExperiencePoints,
    this.userLevel,
    this.userBlockedMap,
    this.userHasBanned,
    this.userAvatar,
    this.userIsOnline,
    this.userLastActivityDate,
    this.userMessageToken,
    this.userNotificationSettings,
    this.userClubs,
  );

  factory KmUser.fromJson(Map<String, dynamic> json) => KmUser.withInfo(
        UserCoordinates.fromJson(json["user_coordinates"]),
        json["user_name"],
        json["user_secret_password"],
        json["user_title"],
        json["user_uid"],
        json["user_experience_points"],
        json["user_level"],
        Map.from(json["user_blocked_map"]).map((k, v) =>
            MapEntry<String, UserBlockedMap>(k, UserBlockedMap.fromJson(v))),
        json["user_has_banned"],
        json["user_avatar"],
        json["user_is_online"],
        json["user_last_activity_date"],
        json["user_message_token"],
        UserNotificationSettings.fromJson(json["user_notification_settings"]),
        json["user_clubs"],
      );

  Map<String, dynamic> toJson() => {
        "user_coordinates": userCoordinates.toJson(),
        "user_name": userName,
        "user_secret_password": userSecretPassword,
        "user_title": userTitle,
        "user_uid": userUid,
        "user_experience_points": userExperiencePoints,
        "user_level": userLevel,
        "user_blocked_map": Map.from(userBlockedMap)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "user_has_banned": userHasBanned,
        "user_avatar": userAvatar,
        "user_is_online": userIsOnline,
        "user_last_activity_date": userLastActivityDate.toDate().toIso8601String(),
        "user_message_token": userMessageToken,
        "user_notification_settings": userNotificationSettings.toJson(),
        "user_clubs": userClubs,
      };
}
