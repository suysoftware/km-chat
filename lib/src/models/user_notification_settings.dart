import 'dart:convert';

class UserNotificationSettings {
  late bool privateMessage;
  late bool publicMessage;


  UserNotificationSettings({
    required this.privateMessage,
    required this.publicMessage,

  });
    factory UserNotificationSettings.fromRawJson(String str) => UserNotificationSettings.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());
  factory UserNotificationSettings.fromJson(Map<String, dynamic> json) =>
      UserNotificationSettings(
        privateMessage: json["private_message"],
        publicMessage: json["public_message"],
      );

  Map<String, dynamic> toJson() => {
        "private_message": privateMessage,
        "public_message": publicMessage,
      };
}
