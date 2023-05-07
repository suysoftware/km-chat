class UserNotificationSettings {
  late bool privateMessage;
  late bool publicMessage;
  late bool clubMessage;

  UserNotificationSettings({
    required this.privateMessage,
    required this.publicMessage,
    required this.clubMessage,
  });

  factory UserNotificationSettings.fromJson(Map<String, dynamic> json) =>
      UserNotificationSettings(
        privateMessage: json["private_message"],
        publicMessage: json["public_message"],
        clubMessage: json["club_message"],
      );

  Map<String, dynamic> toJson() => {
        "private_message": privateMessage,
        "public_message": publicMessage,
        "club_message": clubMessage,
      };
}
