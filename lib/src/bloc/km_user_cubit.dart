import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_km/src/models/km_user.dart';
import 'package:one_km/src/models/user_blocked_map.dart';
import 'package:one_km/src/models/user_notification_settings.dart';

class KmUserCubit extends Cubit<KmUser> {
  KmUserCubit() : super(KmUser());

  void changeUser(KmUser kmUser) {
    emit(kmUser);
  }

  void changeUserAvatar(String chosenAvatar) {
    var newKmUser = KmUser();
    newKmUser.userAvatar = chosenAvatar;
    newKmUser.userBlockedMap = state.userBlockedMap;
    newKmUser.userCoordinates = state.userCoordinates;
    newKmUser.userExperiencePoints = state.userExperiencePoints;
    newKmUser.userHasBanned = state.userHasBanned;
    newKmUser.userIsOnline = state.userIsOnline;
    newKmUser.userLevel = state.userLevel;
    newKmUser.userName = state.userName;
    newKmUser.userSecretPassword = state.userSecretPassword;
    newKmUser.userTitle = state.userTitle;
    newKmUser.userUid = state.userUid;
    newKmUser.userLastActivityDate = state.userLastActivityDate;
    newKmUser.userMessageToken = state.userMessageToken;
    newKmUser.userNotificationSettings = state.userNotificationSettings;

    emit(newKmUser);
  }

  void addBlocked(String targetName, String targetUid, String targetMessage) {
    var newKmUser = KmUser();
    var newUserBlockedMap = state.userBlockedMap;

    newUserBlockedMap[targetUid] = UserBlockedMap(
        userName: targetName,
        blockedDate: Timestamp.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch),
        userUid: targetUid,
        targetMessage: targetMessage);

    newKmUser.userBlockedMap = newUserBlockedMap;
    newKmUser.userAvatar = state.userAvatar;
    newKmUser.userCoordinates = state.userCoordinates;
    newKmUser.userExperiencePoints = state.userExperiencePoints;
    newKmUser.userHasBanned = state.userHasBanned;
    newKmUser.userIsOnline = state.userIsOnline;
    newKmUser.userLevel = state.userLevel;
    newKmUser.userName = state.userName;
    newKmUser.userSecretPassword = state.userSecretPassword;
    newKmUser.userTitle = state.userTitle;
    newKmUser.userUid = state.userUid;
    newKmUser.userLastActivityDate = state.userLastActivityDate;
    newKmUser.userMessageToken = state.userMessageToken;
    newKmUser.userNotificationSettings = state.userNotificationSettings;

    emit(newKmUser);
  }

  void removeBlocked(
    String targetUid,
  ) {
    var newKmUser = KmUser();
    var newUserBlockedMap = state.userBlockedMap;

    newUserBlockedMap.remove(targetUid);

    newKmUser.userBlockedMap = newUserBlockedMap;
    newKmUser.userAvatar = state.userAvatar;
    newKmUser.userCoordinates = state.userCoordinates;
    newKmUser.userExperiencePoints = state.userExperiencePoints;
    newKmUser.userHasBanned = state.userHasBanned;
    newKmUser.userIsOnline = state.userIsOnline;
    newKmUser.userLevel = state.userLevel;
    newKmUser.userName = state.userName;
    newKmUser.userSecretPassword = state.userSecretPassword;
    newKmUser.userTitle = state.userTitle;
    newKmUser.userUid = state.userUid;
    newKmUser.userLastActivityDate = state.userLastActivityDate;
    newKmUser.userMessageToken = state.userMessageToken;
    newKmUser.userNotificationSettings = state.userNotificationSettings;

    emit(newKmUser);
  }

  void notificationSettingChange(bool private, bool public) {
    var newKmUser = KmUser();
    newKmUser.userBlockedMap = state.userBlockedMap;
    newKmUser.userAvatar = state.userAvatar;
    newKmUser.userCoordinates = state.userCoordinates;
    newKmUser.userExperiencePoints = state.userExperiencePoints;
    newKmUser.userHasBanned = state.userHasBanned;
    newKmUser.userIsOnline = state.userIsOnline;
    newKmUser.userLevel = state.userLevel;
    newKmUser.userName = state.userName;
    newKmUser.userSecretPassword = state.userSecretPassword;
    newKmUser.userTitle = state.userTitle;
    newKmUser.userUid = state.userUid;
    newKmUser.userLastActivityDate = state.userLastActivityDate;
    newKmUser.userMessageToken = state.userMessageToken;
    newKmUser.userNotificationSettings = UserNotificationSettings(
        privateMessage: private, publicMessage: public);
    emit(newKmUser);
  }
}
