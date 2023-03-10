// ignore_for_file: prefer_typing_uninitialized_variables, duplicate_ignore, prefer_is_empty

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:one_km/src/models/km_chat_message.dart';
import 'package:one_km/src/models/km_system_settings.dart';
import 'package:one_km/src/models/km_user.dart';
import 'package:http/http.dart' as http;
import 'package:one_km/src/models/user_coordinates.dart';
import 'package:one_km/src/services/rest_api_constants.dart';
import 'package:one_km/src/utils/basic_getters.dart';
import 'package:uuid/uuid.dart';
import 'firebase_auth_service.dart';

class FirestoreOperations {
  static Future<KmUser> getKmUser(String userUid) async {
    // ignore: prefer_typing_uninitialized_variables
    var kmUser;
    final kmUserRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .withConverter(
            fromFirestore: (snapshot, _) => KmUser.fromJson(snapshot.data()!),
            toFirestore: (kmuser, _) => kmuser.toJson());
    kmUser = await kmUserRef.get();

    return kmUser.data();
  }

  static Future<void> kmUserCoordinateUpdate(String userUid) async {
    try {
      var geoLocation;

      geoLocation = await getLocation();

      final kmUserRef =
          FirebaseFirestore.instance.collection('users').doc(userUid);

      await kmUserRef.update({
        "user_coordinates": geoLocation.toJson(),
      });

      // ignore: empty_catches
    } catch (e) {}
  }

  static Future<bool> kmUserNotificationSettingUpdate(
      KmUser kmUser, bool isPublic, bool changeIsTrue) async {
    var payLoad;
    payLoad = {
      "user_no": kmUser.userUid,
      "user_secret_password": kmUser.userSecretPassword,
      "target_notification": isPublic ? "public_message" : "private_message",
      "change_is_true": changeIsTrue.toString()
    };

    var response = await apiRequest(
        RestApiConstants.API_LINK_NOTIFICATION_SETTING_UPDATE, payLoad);

    if (response) {
      // print('COMPLETE (noti change request)');

      return true;
    } else {
      //print('ERROR (noti change request)');
      return false;
    }
  }

  static Future<KmUser> createNewUser(KmUser kmUser) async {
    var uuid = const Uuid();
    var userSecretPassword = uuid.v1();
    final kmUserRef =
        FirebaseFirestore.instance.collection('users').doc(kmUser.userUid);

    var kmUserReturn;
    var geoLocation;
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();

    geoLocation = await getLocation();

    await kmUserRef.update({
      "user_coordinates": geoLocation.toJson(),
      "user_name": kmUser.userName,
      "user_secret_password": userSecretPassword,
      "user_message_token": token ?? ""
    });
    kmUserReturn = await kmUserRef
        .withConverter(
            fromFirestore: (snapshot, _) => KmUser.fromJson(snapshot.data()!),
            toFirestore: (kmuser, _) => kmuser.toJson())
        .get();

    return kmUserReturn.data();
  }

  static Future<UserCoordinates> getLocation() async {
    var location;

    try {
      await Geolocator.requestPermission();
      location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
    } catch (e) {
      await Geolocator.openAppSettings();
    }

    double latitude = location.latitude;
    double longitude = location.longitude;
    var userPlaceMark;

    await placemarkFromCoordinates(latitude, longitude,
            localeIdentifier: 'en_US')
        .then((value) => userPlaceMark = value[0]);

    var userGeo = UserCoordinates(
      latitude: latitude,
      longitude: longitude,
      isoCountryCode: userPlaceMark.isoCountryCode,
      administrativeArea: userPlaceMark.administrativeArea,
      locality: userPlaceMark.locality,
      subLocality: userPlaceMark.subLocality,
      postalCode: userPlaceMark.postalCode,
    );

    return userGeo;
  }

  static Future<bool> sendMessageToChat(
      String userMessage,
      KmUser kmUserForMessage,
      KmSystemSettings kmSystemSettings,
      String privateMessageTarget,
      String privateMessage,
      bool publicNotification) async {
    bool isPrivate = privateMessageTarget != "" ? true : false;

    int spaceValue = 0;

    if (isPrivate) {
      if (privateMessage.length < 1) {
        return false;
      }
      for (var i = 0; i < privateMessage.length; i++) {
        if (privateMessage[i] == " ") {
          spaceValue = spaceValue + 1;
        }
      }
      if (privateMessage.length - spaceValue <= spaceValue) {
        return false;
      }
    } else {
      if (userMessage.length < 1) {
        return false;
      }
      for (var i = 0; i < userMessage.length; i++) {
        if (userMessage[i] == " ") {
          spaceValue = spaceValue + 1;
        }
      }
      if (userMessage.length - spaceValue <= spaceValue) {
        return false;
      }
    }

    var userBlockedConvertList;
    userBlockedConvertList =
        await BasicGetters.blockedMapToList(kmUserForMessage.userBlockedMap);

    try {
      var kmChatMessage = KmChatMessage(
          userMessage: isPrivate ? privateMessage : userMessage,
          userMessageTime: Timestamp.fromMillisecondsSinceEpoch(
              DateTime.now().millisecondsSinceEpoch),
          userTitle: kmUserForMessage.userTitle,
          userName: kmUserForMessage.userName,
          userLevel: kmUserForMessage.userLevel,
          userBlockedList: userBlockedConvertList,
          userUid: kmUserForMessage.userUid,
          userAvatar: kmUserForMessage.userAvatar,
          messageIsPrivate: isPrivate,
          privateMessageTarget: privateMessageTarget);

      var chatRef = BasicGetters.chatStreamReferenceGetter(
          kmUserForMessage.userCoordinates, kmSystemSettings);

      await chatRef.add(kmChatMessage);

      if (isPrivate) {
        FirestoreOperations.notificationRequest(kmUserForMessage,
            privateMessageTarget, privateMessage, kmSystemSettings);
      } else if (publicNotification) {
        FirestoreOperations.notificationRequest(
            kmUserForMessage, 'notarget', userMessage, kmSystemSettings);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<KmSystemSettings> kmSystemSettingsGetter() async {
    var systemSettings;
    final settingsRef = FirebaseFirestore.instance
        .collection('system')
        .doc('system_settings')
        .withConverter(
            fromFirestore: (snapshot, _) =>
                KmSystemSettings.fromJson(snapshot.data()!),
            toFirestore: (kmsetting, _) => kmsetting.toJson());

    systemSettings = await settingsRef.get();

    return systemSettings.data();
  }

  static Future<bool> joinRoomRequest(
      KmUser kmUser, KmSystemSettings kmSystemSettings) async {
    var payLoad;

    payLoad = {
      "user_no": kmUser.userUid,
      "user_name": kmUser.userName,
      "system_chat_setting": kmSystemSettings.chatDistance,
      "user_country": kmUser.userCoordinates.isoCountryCode,
      "user_city": kmUser.userCoordinates.administrativeArea,
      "user_district": kmUser.userCoordinates.locality,
      "user_postal": kmUser.userCoordinates.postalCode,
    };

    var response =
        await apiRequest(RestApiConstants.API_LINK_JOIN_ROOM_MESSAGE, payLoad);

    if (response) {
      //print('COMPLETE (join room request)');

      return true;
    } else {
      //print('ERROR (join room request)');
      return false;
    }
  }

  static Future<bool> spamRequest(KmUser kmUser, String targetName,
      String targetUid, String targetMessage) async {
    var payLoad;
    payLoad = {
      "user_no": kmUser.userUid,
      "user_secret_password": kmUser.userSecretPassword,
      "target_uid": targetUid,
      "target_name": targetName,
      "target_message": targetMessage,
    };

    var response =
        await apiRequest(RestApiConstants.API_LINK_SPAM_TARGET, payLoad);

    if (response) {
      //print('COMPLETE (spam request)');

      return true;
    } else {
      //print('ERROR (spam request)');
      return false;
    }
  }

  static Future<bool> spamRemove(KmUser kmUser, String targetUid) async {
    var payLoad;
    payLoad = {
      "user_no": kmUser.userUid,
      "user_secret_password": kmUser.userSecretPassword,
      "target_uid": targetUid,
    };

    var response =
        await apiRequest(RestApiConstants.API_LINK_SPAM_REMOVE, payLoad);

    if (response) {
      //print('COMPLETE (spam remove)');

      return true;
    } else {
      //print('ERROR (spam remove)');
      return false;
    }
  }

  static Future<bool> avatarChangeRequest(
      KmUser kmUser, String chosenAvatar) async {
    var payLoad;
    payLoad = {
      "user_no": kmUser.userUid,
      "user_secret_password": kmUser.userSecretPassword,
      "chosen_avatar": chosenAvatar,
    };
    var response =
        await apiRequest(RestApiConstants.API_LINK_AVATAR_CHANGE, payLoad);

    if (response) {
      //print('COMPLETE (avatar change)');

      return true;
    } else {
      //print('ERROR (avatar change)');
      return false;
    }
  }

  static Future<bool> accountReviveRequest(
      KmUser kmUser, String reviveSecretPassword) async {
    if (kmUser.userSecretPassword == reviveSecretPassword) {
      return false;
    }
    var payLoad;
    payLoad = {
      "user_no": kmUser.userUid,
      "user_secret_password": reviveSecretPassword,
    };

    var response =
        await apiRequest(RestApiConstants.API_LINK_ACCOUNT_REVIVE, payLoad);

    if (response) {
      //print('COMPLETE (revive request)');

      return true;
    } else {
      //print('ERROR (revive request)');
      return false;
    }
  }

  static Future<void> activityControl(
      KmUser kmUser, String activityType) async {
    var payLoad;
    payLoad = {
      "user_no": kmUser.userUid,
      "user_secret_password": kmUser.userSecretPassword,
      "activity_type": activityType
    };

    await apiRequest(RestApiConstants.API_LINK_ACTIVITY_REQUEST, payLoad);

    /*if (response) {
      //print('COMPLETE (activitycontrol)');

      return true;
    } else {
      //print('ERROR (activitycontrol)');
      return false;
    }*/
  }

  static Future<void> notificationRequest(
      KmUser kmUser,
      String privateMessageTarget,
      String privateMessageText,
      KmSystemSettings kmSystemSettings) async {
    var payLoad;
    payLoad = {
      "user_no": kmUser.userUid,
      "user_name": kmUser.userName,
      "system_chat_setting": kmSystemSettings.chatDistance,
      "user_country": kmUser.userCoordinates.isoCountryCode,
      "user_city": kmUser.userCoordinates.administrativeArea,
      "user_district": kmUser.userCoordinates.locality,
      "user_postal": kmUser.userCoordinates.postalCode,
      "private_message_target": privateMessageTarget,
      "private_message_text": privateMessageText
    };

    var response = await apiRequest(
        RestApiConstants.API_LINK_NOTIFICATION_SENDER, payLoad);

    if (response) {
      //print('COMPLETE notification');
    } else {
      //print('ERROR notification');
    }
  }

  static Future<void> tokenUpdateRequest(KmUser kmUser) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    if (token != null && token != kmUser.userMessageToken) {
      var payLoad;
      payLoad = {
        "user_no": kmUser.userUid,
        "user_message_token": token,
      };

     await apiRequest(RestApiConstants.API_LINK_TOKEN_UPDATE_REQUEST, payLoad);
    }
  }

  static Future<bool> apiRequest(String apiLink, dynamic payLoad) async {
    var client = http.Client();

    var uriIE = Uri.parse(apiLink);
    var secureToken = await FirebaseAuthService.secureTokenGetter();
    if (secureToken == false) {
      return false;
    }
    String token = secureToken.toString();
    var requestHeaders = {'Authorization': 'Bearer $token'};

    var response =
        await client.put(uriIE, body: payLoad, headers: requestHeaders);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
