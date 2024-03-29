import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_km/src/bloc/km_chat_reference.dart';
import 'package:one_km/src/bloc/km_user_cubit.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/models/km_chat_message.dart';
import 'package:one_km/src/models/km_system_settings.dart';
import 'package:one_km/src/models/km_user.dart';
import 'package:one_km/src/services/firestore_operations.dart';
import 'package:sizer/sizer.dart';

class AlertDialogs {
  static Future<dynamic> errorDialog(String errorText, BuildContext context) async {
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => CupertinoDialogAction(
              child: Text(
                errorText,
                maxLines: 3,
                style: TextStyle(fontFamily: "Coderstyle", fontSize: 18.sp, color: ColorConstants.adminColor),
              ),
            ));
  }

  static Future<dynamic> spamDialog(KmUser kmUser, KmChatMessage targetMessage, BuildContext context) async {
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              content: Text(
                "Do you want Spam and Block ?\n => ${targetMessage.senderUser.userName} <= ",
              ),
              actions: [
                CupertinoButton(
                    child: const Text(
                      "Yes",
                      style: TextStyle(color: ColorConstants.adminColor),
                    ),
                    onPressed: () async {
                      //spam operation

                      // ignore: prefer_typing_uninitialized_variables
                      var spamResponse;
                      spamResponse = await FirestoreOperations.spamRequest(kmUser, targetMessage.senderUser.userName, targetMessage.senderUser.userUid, targetMessage.userMessage);

                      if (spamResponse) {
                        // ignore: use_build_context_synchronously
                        context.read<KmUserCubit>().addBlocked(targetMessage.senderUser.userName, targetMessage.senderUser.userUid, targetMessage.userMessage);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      } else {}
                    }),
                CupertinoButton(
                    child: const Text(
                      "No",
                      style: TextStyle(color: ColorConstants.themeColor),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ));
  }

  static Future<dynamic> clearChatDialog(KmUser kmUser, String targetUid, BuildContext context, KmSystemSettings kmSystemSettings) async {
    return showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: const Text("ATTENTION"),
              content: const Text("Do you want to clean this chat?"),
              actions: [
                CupertinoButton(
                  child: const Text("Yes"),
                  onPressed: () async {
                    Navigator.pop(context);
                    context.read<KmChatReferenceCubit>().goPublic(kmUser.userCoordinates, kmSystemSettings);
                    await FirestoreOperations.cleanTargetPrivateChatRequest(kmUser.userUid, targetUid);
                  },
                ),
                CupertinoButton(
                  child: const Text("No"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }
}
