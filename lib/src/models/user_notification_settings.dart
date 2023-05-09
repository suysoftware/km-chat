class UserNotificationSettings {
  late bool privateMessage;
  late bool publicMessage;


  UserNotificationSettings({
    required this.privateMessage,
    required this.publicMessage,

  });

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
