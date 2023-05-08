import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/enums.dart';
import 'km_chat_message.dart';



KmChatReferenceModel kmChatReferenceModelFromJson(String str) => KmChatReferenceModel.fromJson(json.decode(str));

String kmChatReferenceModelToJson(KmChatReferenceModel data) => json.encode(data.toJson());

class KmChatReferenceModel {
  ChatSectionEnum chatSectionEnum;
  Stream<QuerySnapshot<KmChatMessage>> chatReference;
  String chatTargetNo;
  String chatTargetName;

  KmChatReferenceModel({
    required this.chatSectionEnum,
    required this.chatReference,
    required this.chatTargetNo,
    required this.chatTargetName,
  
  });

  factory KmChatReferenceModel.fromJson(Map<String, dynamic> json) => KmChatReferenceModel(
        chatSectionEnum: json["chat_section_enum"],
        chatReference: json["chat_reference"],
        chatTargetNo: json["chat_target_no"],
        chatTargetName: json["chat_target_name"],
      );

  Map<String, dynamic> toJson() => {
        "chat_section_enum": chatSectionEnum,
        "chat_reference": chatReference,
        "chat_target_no": chatTargetNo,
        "chat_target_name": chatTargetName,
      };
}
