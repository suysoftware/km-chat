// To parse this JSON data, do
//
//     final kmSystemSettings = kmSystemSettingsFromJson(jsonString);

import 'dart:convert';

KmSystemSettings kmSystemSettingsFromJson(String str) =>
    KmSystemSettings.fromJson(json.decode(str));

String kmSystemSettingsToJson(KmSystemSettings data) =>
    json.encode(data.toJson());

class KmSystemSettings {
  late String chatDistance;
  late dynamic avatarMap;
  late int messagesAmount;
  late bool eventIsActive;
  late dynamic eventAssets;
  late List<dynamic> allUserNames;

  KmSystemSettings();
  KmSystemSettings.withInfo(
      {required this.chatDistance,
      required this.avatarMap,
      required this.messagesAmount,
      required this.eventIsActive,
      required this.eventAssets,
      required this.allUserNames});

  factory KmSystemSettings.fromJson(Map<String, dynamic> json) =>
      KmSystemSettings.withInfo(
          chatDistance: json["chat_distance"] as String,
          avatarMap: json["avatar_map"] as dynamic,
          messagesAmount: json["messages_amount"] as int,
          eventIsActive: json["event_is_active"] as bool,
          eventAssets: json["event_assets"] as dynamic,
          allUserNames: json["all_user_names"] as List<dynamic>);

  Map<String, dynamic> toJson() => {
        "chat_distance": chatDistance,
        "avatar_map": avatarMap,
        "messages_amount": messagesAmount,
        "event_is_active": eventIsActive,
        "event_assets": eventAssets,
        "all_user_names": allUserNames
      };
}
