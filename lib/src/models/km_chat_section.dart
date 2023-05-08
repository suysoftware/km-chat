import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatSectionEnum { bot, club, private, public }

KmChatSection kmChatSectionFromJson(String str) => KmChatSection.fromJson(json.decode(str));

String kmChatSectionToJson(KmChatSection data) => json.encode(data.toJson());

class KmChatSection {
  ChatSectionEnum chatSectionEnum;
  int messageLength;
  String targetName;
  String targetUid;
  Timestamp lastActivityDate;
  String targetAvatar;

  KmChatSection({
    required this.chatSectionEnum,
    required this.messageLength,
    required this.targetName,
    required this.targetUid,
    required this.lastActivityDate,
    required this.targetAvatar,
  });

  factory KmChatSection.fromJson(Map<String, dynamic> json) => KmChatSection(
        chatSectionEnum: json["chat_section_enum"],
        messageLength: json["message_length"],
        targetName: json["target_name"],
        targetUid: json["target_uid"],
        lastActivityDate: json["last_activity_date"],
        targetAvatar: json["target_avatar"],
      );

  Map<String, dynamic> toJson() => {
        "chat_section_enum": chatSectionEnum,
        "message_length": messageLength,
        "target_name": targetName,
        "target_uid": targetUid,
        "last_activity_date": lastActivityDate,
        "target_avatar": targetAvatar,
      };
}


