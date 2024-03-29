import 'package:cloud_firestore/cloud_firestore.dart';

class UserBlockedMap {
  late String userName;
  late Timestamp blockedDate;
  late String userUid;
  late String targetMessage;

  UserBlockedMap({
    required this.userName,
    required this.blockedDate,
    required this.userUid,
    required this.targetMessage,
  });

  factory UserBlockedMap.fromJson(Map<String, dynamic> json) => UserBlockedMap(
        userName: json["user_name"],
        blockedDate: json["blocked_date"],
        userUid: json["user_uid"],
        targetMessage: json["target_message"],
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "blocked_date": blockedDate,
        "user_uid": userUid,
        "target_message": targetMessage,
      };
}