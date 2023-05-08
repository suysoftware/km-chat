
// To parse this JSON data, do
//
//     final KmChatMessage = KmChatMessageFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:one_km/src/models/km_user.dart';

List<KmChatMessage> KmChatMessageFromJson(String str) => List<KmChatMessage>.from(json.decode(str).map((x) => KmChatMessage.fromJson(x)));

String KmChatMessageToJson(List<KmChatMessage> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KmChatMessage {
  late String userMessage;
  late Timestamp userMessageTime;
  late KmUser senderUser;
  late KmUser recieverUser;

  KmChatMessage(
      {required this.userMessage,
      required this.userMessageTime,
      required this.senderUser,
      required this.recieverUser,
    });

  factory KmChatMessage.fromJson(Map<String, dynamic> json) => KmChatMessage(
        userMessage: json["user_message"],
        userMessageTime: json["user_message_time"],
     senderUser: KmUser.fromJson(json["sender_user"]),
      recieverUser: KmUser.fromJson(json["reciever_user"]),
      );

  Map<String, dynamic> toJson() => {
        "user_message": userMessage,
        "user_message_time": userMessageTime.toDate().toIso8601String(),
        "sender_user": senderUser.toJson(),
        "reciever_user": recieverUser.toJson(),
      };

      
 
}








/*// To parse this JSON data, do
//
//     final kmChatMessage = kmChatMessageFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

List<KmChatMessage> kmChatMessageFromJson(String str) => List<KmChatMessage>.from(json.decode(str).map((x) => KmChatMessage.fromJson(x)));

String kmChatMessageToJson(List<KmChatMessage> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KmChatMessage {
  late String userMessage;
  late Timestamp userMessageTime;
  late String userTitle;
  late String userName;
  late int userLevel;
  late List<dynamic> userBlockedList;
  late String userUid;
  late String userAvatar;
  late List<dynamic> userClubs;

  KmChatMessage(
      {required this.userMessage,
      required this.userMessageTime,
      required this.userTitle,
      required this.userName,
      required this.userLevel,
      required this.userBlockedList,
      required this.userUid,
      required this.userAvatar,
      required this.userClubs
      });

  factory KmChatMessage.fromJson(Map<String, dynamic> json) => KmChatMessage(
      userMessage: json["user_message"],
      userMessageTime: json["user_message_time"],
      userTitle: json["user_title"],
      userName: json["user_name"],
      userLevel: json["user_level"],
      userBlockedList: json["user_blocked_list"],
      userUid: json["user_uid"],
      userAvatar: json["user_avatar"],
      userClubs: json["user_clubs"],);

  Map<String, dynamic> toJson() => {
        "user_message": userMessage,
        "user_message_time": userMessageTime,
        "user_title": userTitle,
        "user_name": userName,
        "user_level": userLevel,
        "user_blocked_list": userBlockedList,
        "user_uid": userUid,
        "user_avatar": userAvatar,
        "user_clubs": userClubs,
      };
}
*/