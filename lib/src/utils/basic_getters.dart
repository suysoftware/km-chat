import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:one_km/src/constants/style_constants.dart';
import 'package:one_km/src/models/km_chat_message.dart';
import 'package:one_km/src/models/km_chat_section.dart';
import 'package:one_km/src/models/km_system_settings.dart';
import 'package:one_km/src/models/km_user.dart';
import 'package:one_km/src/models/user_coordinates.dart';
import 'package:one_km/src/widgets/app_logo.dart';
import 'package:vibration/vibration.dart';

import '../screens/options/profile/profile_dialog.dart';

class BasicGetters {
  static CollectionReference<KmChatMessage> chatStreamReferenceGetter(UserCoordinates userCoordinates, KmSystemSettings kmSystemSettings) {
    var collectionName = "public_chat";
    switch (kmSystemSettings.chatDistance) {
      case 'world':
        return FirebaseFirestore.instance
            .collection(collectionName)
            .doc('WORLD')
            .collection('world_chat')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson());

      case 'country':
        return FirebaseFirestore.instance
            .collection(collectionName)
            .doc(userCoordinates.isoCountryCode)
            .collection('country_chat')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson());

      case 'city':
        return FirebaseFirestore.instance
            .collection(collectionName)
            .doc(userCoordinates.isoCountryCode)
            .collection('cities')
            .doc(userCoordinates.administrativeArea)
            .collection('city_chat')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson());

      case 'district':
        return FirebaseFirestore.instance
            .collection(collectionName)
            .doc(userCoordinates.isoCountryCode)
            .collection('cities')
            .doc(userCoordinates.administrativeArea)
            .collection('districts')
            .doc(userCoordinates.locality)
            .collection('district_chat')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson());
      case 'postal':
        return FirebaseFirestore.instance
            .collection(collectionName)
            .doc(userCoordinates.isoCountryCode)
            .collection('cities')
            .doc(userCoordinates.administrativeArea)
            .collection('districts')
            .doc(userCoordinates.locality)
            .collection('postals')
            .doc(userCoordinates.postalCode)
            .collection('postal_chat')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson());
      default:
        return FirebaseFirestore.instance
            .collection(collectionName)
            .doc(userCoordinates.isoCountryCode)
            .collection('cities')
            .doc(userCoordinates.administrativeArea)
            .collection('districts')
            .doc(userCoordinates.locality)
            .collection('postals')
            .doc(userCoordinates.postalCode)
            .collection('postal_chat')
            .withConverter(fromFirestore: (snapshot, _) => KmChatMessage.fromJson(snapshot.data()!), toFirestore: (kmchat, _) => kmchat.toJson());
    }
  }

  static String chatTargetNameSwitch(UserCoordinates userCoordinates, KmSystemSettings kmSystemSettings) {
    switch (kmSystemSettings.chatDistance) {
      case 'world':
        return "World";

      case 'country':
        return userCoordinates.isoCountryCode;

      case 'city':
        return userCoordinates.administrativeArea;

      case 'district':
        return userCoordinates.locality;
      case 'postal':
        return userCoordinates.postalCode;
      default:
        return userCoordinates.postalCode;
    }
  }

  static TextStyle chatTextStyleGetter(KmChatMessage kmChatMessage, String myUid) {
    switch (kmChatMessage.senderUser.userTitle) {
      case "system":
        return StyleConstants.systemTextStyle;
      case "admin":
        return StyleConstants.adminTextStyle;
      case "master":
        return StyleConstants.masterTextStyle;
      case "pleb":
        return StyleConstants.plebTextStyle;
      default:
        return StyleConstants.plebTextStyle;
    }
  }

  static TextStyle chatNameStyleGetter(
    KmChatMessage kmChatMessage,
  ) {
    switch (kmChatMessage.senderUser.userTitle) {
      case "system":
        return StyleConstants.systemNameTextStyle;
      case "admin":
        return StyleConstants.adminNameTextStyle;
      case "master":
        return StyleConstants.masterNameTextStyle;
      case "pleb":
        return StyleConstants.plebNameTextStyle;
      default:
        return StyleConstants.plebNameTextStyle;
    }
  }

  static TextStyle profileTitleTextStyleGetter(
    String title,
  ) {
    switch (title) {
      case "admin":
        return StyleConstants.profileTitleAdminTextStyle;
      case "master":
        return StyleConstants.profileTitleMasterTextStyle;
      case "pleb":
        return StyleConstants.profileTitlePlebTextStyle;
      default:
        return StyleConstants.profileTitlePlebTextStyle;
    }
  }

  static Future<List<KmChatMessage>> chatFilteredMessagesGetter(List<KmChatMessage> kmChatList, KmUser myUserModel) async {
    var kmChatFilteredList = <KmChatMessage>[];
    var dateTime = DateTime.now().millisecondsSinceEpoch;

    for (var chatMessage in kmChatList) {
      if (myUserModel.userBlockedMap.keys.contains(chatMessage.senderUser.userUid)) {
        kmChatFilteredList.removeWhere((element) => element.senderUser.userUid == chatMessage.senderUser.userUid);
      } else if (myUserModel.userBlockedMap.keys.contains(chatMessage.recieverUser.userUid)) {
        kmChatFilteredList.removeWhere((element) => element.recieverUser.userUid == chatMessage.recieverUser.userUid);
      } else if (chatMessage.recieverUser.userBlockedMap.keys.contains(myUserModel.userUid)) {
        kmChatFilteredList.removeWhere((element) => element.recieverUser.userUid == chatMessage.recieverUser.userUid);
      } else if (chatMessage.senderUser.userBlockedMap.keys.contains(myUserModel.userUid)) {
        kmChatFilteredList.removeWhere((element) => element.senderUser.userUid == chatMessage.senderUser.userUid);
      } else {
        /*  if (chatMessage.data().messageIsPrivate &&
            chatMessage.data().privateMessageTarget == myUserModel.userUid &&
            dateTime - chatMessage.data().userMessageTime.millisecondsSinceEpoch < 2000) {
          Vibration.vibrate(duration: 40);
        }*/

        if (chatMessage.senderUser.userTitle == "system" && dateTime - chatMessage.userMessageTime.millisecondsSinceEpoch > 30000) {
          // ignore: prefer_is_empty
          if (kmChatFilteredList.length < 1) {
            kmChatFilteredList.add(chatMessage);
          }
        } else {
          kmChatFilteredList.add(chatMessage);
        }
      }
    }

    kmChatFilteredList.sort((b, a) => a.userMessageTime.compareTo(b.userMessageTime));

    return kmChatFilteredList;
  }

  static List<KmChatMessage> chatMessageQuerySnapshotToList(QuerySnapshot<KmChatMessage> querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
  }

  static String kmLogoChatDistanceTextGetter(String chatDistance, UserCoordinates userCoordinates) {
    switch (chatDistance) {
      case "world":
        return "World";
      case "country":
        return userCoordinates.isoCountryCode;
      case "city":
        return userCoordinates.administrativeArea;
      case 'district':
        return userCoordinates.locality;
      case 'postal':
        return "null";
      default: //postal
        return "null";
    }
  }

  static String sectionBarIconGetter(String chatSectionEnum) {
    switch (chatSectionEnum) {
      case "public":
        return "assets/svg/earth.svg";
      case "private":
        return "assets/svg/earth.svg";
      case "club":
        return "assets/svg/earth.svg";
      case 'bot':
        return "assets/svg/ai_icon.svg";
      default: //postal
        return "assets/svg/earth.svg";
    }
  }

  static Future<List<KmChatSection>> kmChatSectionListCreator(List<KmChatMessage> kmChatList, KmUser myUserModel, KmSystemSettings kmSystemSettings) async {
    var kmChatSectionList = <KmChatSection>[];
    var dateTime = DateTime.now().millisecondsSinceEpoch;

    kmChatSectionList.add(KmChatSection(
        chatSectionEnum: ChatSectionEnum.bot,
        messageLength: 0,
        targetName: "KM-BOT",
        targetUid: "bot",
        lastActivityDate: Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch - 1),
        targetAvatar: ""));
    kmChatSectionList.add(KmChatSection(
        chatSectionEnum: ChatSectionEnum.public,
        messageLength: 0,
        targetName: kmLogoChatDistanceTextGetter(kmSystemSettings.chatDistance, myUserModel.userCoordinates).length < 5
            ? "${kmLogoChatDistanceTextGetter(kmSystemSettings.chatDistance, myUserModel.userCoordinates)} - Public"
            : kmLogoChatDistanceTextGetter(kmSystemSettings.chatDistance, myUserModel.userCoordinates),
        targetUid: "Public",
        lastActivityDate: Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch),
        targetAvatar: ""));
    for (var chatMessage in kmChatList) {
      if (myUserModel.userBlockedMap.keys.contains(chatMessage.senderUser.userUid) || myUserModel.userBlockedMap.keys.contains(chatMessage.recieverUser.userUid)) {
        print("banli user");
      } else {
        if (chatMessage.senderUser.userUid != myUserModel.userUid && dateTime - chatMessage.userMessageTime.millisecondsSinceEpoch < 2000) {
          Vibration.vibrate(duration: 40);
        }

        if (chatMessage.senderUser.userTitle == "system" && dateTime - chatMessage.userMessageTime.millisecondsSinceEpoch > 30000) {
          // ignore: prefer_is_empty
          //  if (kmChatFilteredList.length < 1) {
          //  kmChatFilteredList.add(chatMessage.data());
          //}
        } else {
          if (chatMessage.senderUser.userTitle != "system") {
            var targetUserUid;
            var firstModel;
            if (chatMessage.senderUser.userUid == myUserModel.userUid) {
              targetUserUid = chatMessage.recieverUser.userUid;
              firstModel = KmChatSection(
                  chatSectionEnum: ChatSectionEnum.private,
                  messageLength: 0,
                  targetName: chatMessage.recieverUser.userName,
                  targetUid: chatMessage.recieverUser.userUid,
                  lastActivityDate: chatMessage.userMessageTime,
                  targetAvatar: chatMessage.recieverUser.userAvatar);
            } else {
              targetUserUid = chatMessage.senderUser.userUid;
              firstModel = KmChatSection(
                  chatSectionEnum: ChatSectionEnum.private,
                  messageLength: 0,
                  targetName: chatMessage.senderUser.userName,
                  targetUid: chatMessage.senderUser.userUid,
                  lastActivityDate: chatMessage.userMessageTime,
                  targetAvatar: chatMessage.senderUser.userAvatar);
            }
            if (kmChatSectionList.any((element) => element.targetUid == targetUserUid) == false) {
              kmChatSectionList.add(firstModel);
            } else {
              int sectionLine = kmChatSectionList.indexWhere((element) => element.targetUid == targetUserUid);
              var targetSection = kmChatSectionList[sectionLine];
              targetSection.messageLength + 1;
              if (targetSection.lastActivityDate.millisecondsSinceEpoch < chatMessage.userMessageTime.millisecondsSinceEpoch) {
                targetSection.lastActivityDate = chatMessage.userMessageTime;
              }
              kmChatSectionList[sectionLine] = targetSection;
            }
          }
        }
      }
    }

    kmChatSectionList.sort((b, a) => a.lastActivityDate.compareTo(b.lastActivityDate));

    return kmChatSectionList;
  }

  static Future<List<dynamic>> blockedMapToList(dynamic blockedMap) async {
    final blockedList = blockedMap.keys.toList();

    return blockedList;
  }

  static Widget textWidgetGetter(KmChatMessage kmChatMessage, String myUid, BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          recognizer: LongPressGestureRecognizer()
            ..onLongPress = () {
              HapticFeedback.vibrate();
              if (kmChatMessage.senderUser.userTitle != "system" && kmChatMessage.senderUser.userTitle != "admin" && kmChatMessage.senderUser.userUid != myUid&&kmChatMessage.senderUser.userTitle!="bot") {
                showCupertinoDialog(barrierDismissible: true, context: context, builder: (context) => ProfileDialog(kmChatMessage: kmChatMessage));
              }
            },
          text: "${kmChatMessage.senderUser.userName}: ",
          style: chatNameStyleGetter(kmChatMessage)),
      TextSpan(text: kmChatMessage.userMessage, style: chatTextStyleGetter(kmChatMessage, myUid)),
    ]));
  }
}
