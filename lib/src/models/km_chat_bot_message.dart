// To parse this JSON data, do
//
//     final kmChatBotMessage = kmChatBotMessageFromJson(jsonString);

import 'dart:convert';

List<KmChatBotMessage> kmChatBotMessageFromJson(String str) => List<KmChatBotMessage>.from(json.decode(str).map((x) => KmChatBotMessage.fromJson(x)));

String kmChatBotMessageToJson(List<KmChatBotMessage> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class KmChatBotMessage {
    String role;
    String content;

    KmChatBotMessage({
        required this.role,
        required this.content,
    });

    factory KmChatBotMessage.fromJson(Map<String, dynamic> json) => KmChatBotMessage(
        role: json["role"],
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
    };
}
