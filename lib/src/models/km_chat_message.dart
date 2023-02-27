// To parse this JSON data, do
//
//     final kmChatMessage = kmChatMessageFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<KmChatMessage> kmChatMessageFromJson(String str) =>
    List<KmChatMessage>.from(
        json.decode(str).map((x) => KmChatMessage.fromJson(x)));

String kmChatMessageToJson(List<KmChatMessage> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KmChatMessage {
  late String userMessage;
  late Timestamp userMessageTime;
  late String userTitle;
  late String userName;
  late int userLevel;
  late List<dynamic> userBlockedList;
  late String userUid;
  late String userAvatar;
  late bool messageIsPrivate;
  late String privateMessageTarget;

  KmChatMessage(
      {required this.userMessage,
      required this.userMessageTime,
      required this.userTitle,
      required this.userName,
      required this.userLevel,
      required this.userBlockedList,
      required this.userUid,
      required this.userAvatar,
      required this.messageIsPrivate,
      required this.privateMessageTarget});

  factory KmChatMessage.fromJson(Map<String, dynamic> json) => KmChatMessage(
      userMessage: json["user_message"],
      userMessageTime: json["user_message_time"],
      userTitle: json["user_title"],
      userName: json["user_name"],
      userLevel: json["user_level"],
      userBlockedList: json["user_blocked_list"],
      userUid: json["user_uid"],
      userAvatar: json["user_avatar"],
      messageIsPrivate: json["message_is_private"],
      privateMessageTarget: json["private_message_target"]);

  Map<String, dynamic> toJson() => {
        "user_message": userMessage,
        "user_message_time": userMessageTime,
        "user_title": userTitle,
        "user_name": userName,
        "user_level": userLevel,
        "user_blocked_list": userBlockedList,
        "user_uid": userUid,
        "user_avatar": userAvatar,
        "message_is_private": messageIsPrivate,
        "private_message_target": privateMessageTarget
      };
}
