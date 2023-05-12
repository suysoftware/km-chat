// ignore_for_file: sort_child_properties_last

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:one_km/src/bloc/km_system_settings_cubit.dart';
import 'package:one_km/src/bloc/km_user_cubit.dart';
import 'package:one_km/src/constants/style_constants.dart';
import 'package:one_km/src/dialogs/rules_and_info_dialog.dart';
import 'package:one_km/src/models/km_user.dart';
import 'package:one_km/src/screens/options/notification/notification_dialog.dart';
import 'package:one_km/src/screens/options/profile/profile_dialog.dart';
import 'package:one_km/src/screens/options/revive/account_revive_dialog.dart';
import 'package:one_km/src/screens/options/spam/spam_list_dialog.dart';
import 'package:one_km/src/widgets/mini_widget.dart';
import 'package:sizer/sizer.dart';

import '../../services/firestore_operations.dart';

enum Availability { loading, available, unavailable }

class OptionsDialog extends StatefulWidget {
  final KmUser kmUser;
  const OptionsDialog({super.key, required this.kmUser});

  @override
  State<OptionsDialog> createState() => _OptionsDialogState();
}

class _OptionsDialogState extends State<OptionsDialog> {
  final InAppReview _inAppReview = InAppReview.instance;
  // ignore: unused_field
  Availability _availability = Availability.loading;
  // ignore: prefer_final_fields, unused_field
  String _appStoreId = '';

  // ignore: unused_element
  void _setAppStoreId(String id) => _appStoreId = id;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final isAvailable = await _inAppReview.isAvailable();

        setState(() {
          // This plugin cannot be tested on Android by installing your app
          // locally. See https://github.com/britannio/in_app_review#testing for
          // more information.
          _availability = isAvailable ? Availability.available : Availability.unavailable;
        });
      } catch (e) {
        setState(() => _availability = Availability.unavailable);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent.withOpacity(0.8),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              optionButton('/profile', () => profileFunction(context)),
              optionButton('/howtouse', () => howToUseFunction(context)),
              BlocBuilder<KmUserCubit, KmUser>(builder: (context, snapshotBloc) {
                return optionButton('/spamlist [${snapshotBloc.userBlockedMap.entries.length}]', () => blockListFunction(context, snapshotBloc));
              }),
              optionButton('/Account Revive', () => reviveFunction(context)),
              optionButton('/Notifications', () => notificationFunction(context)),
              optionButton('/Clean Bot-Chat', () => cleanChatFunction()),
              optionButton('/Rate Us!', () => rateUsFunction()),
              SizedBox(
                height: 4.h,
              ),
              Center(child: MiniWidgets.closeButton(context, null))
            ],
          ),
        ),
      ),
    );
  }

  optionButton(String text, Function() func) {
    return Row(
      children: [
        SizedBox(
          width: 22.w,
        ),
        TextButton(
            child: Text(
              text,
              style: StyleConstants.optionsButtonTextStyle,
            ),
            onPressed: func),
      ],
    );
  }

  profileFunction(BuildContext context) {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return ProfileDialog(
            kmUser: widget.kmUser,
            kmChatMessage: null,
          );
        });
  }

  howToUseFunction(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return RulesAndInfoDialog(
            mdFileName: 'rules_and_info.md',
          );
        });
  }

  reviveFunction(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return const AccountReviveDialog();
        });
  }

  notificationFunction(BuildContext context) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return const NotificationDialog();
        });
  }

  Future<void> rateUsFunction() => _inAppReview.requestReview().whenComplete(() async {
        try {
          final isAvailable = await _inAppReview.isAvailable();

          if (isAvailable == false) {
            // ignore: unused_local_variable
            FirebaseAuth auth = FirebaseAuth.instance;
          }
          setState(() {
            _availability = isAvailable && !Platform.isAndroid ? Availability.available : Availability.unavailable;
          });
        } catch (e) {
          setState(() => _availability = Availability.unavailable);
        }
      });

  blockListFunction(
    BuildContext context,
    KmUser kmUserNew,
  ) {
    if (kmUserNew.userBlockedMap.entries.isNotEmpty) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return SpamList(kmUser: kmUserNew);
          });
    }
  }

  cleanChatFunction() async {
    try {
      // Navigator.pop(context); //DÜZELT
      //await FirestoreOperations.cleanKmBotChatRequest(widget.kmUser.userUid);  //DÜZELT

      var names = [
        "Morpheus",
        "Neo",
        "Trinity",
        "Morpheus",
        "Agent Smith",
        "Neo",
        "Agent Smith",
        "Morpheus",
        "Trinity",
        "Agent Smith",
        "Neo",
        "Agent Smith",
        "Neo",
        "Morpheus",
        "Trinity",
        "Neo"
      ];

      var messages = [
        "Neo, bu uygulama bize Matrix'in farklı bir yüzünü gösteriyor.",
        "Yani buradaki herkes Matrix'te 1 km içinde mi?",
        "Evet, Neo. Ancak unutma ki burası hala Matrix. Her şey bir simülasyon.",
        "Fakat bu, Matrix'in kontrolünü daha iyi anlamamızı sağlıyor. Bizimle kimlerin etkileşime geçtiğini görme fırsatımız olacak.",
        "Ne kadar ilginç bir konsept. İnsanların birbirleriyle nasıl iletişim kurduğunu izlemek...",
        "Smith! Burada ne yapıyorsun?",
        "Aynı sizin gibi, Neo. Sohbet ediyorum.",
        "Neo, endişelenme. Smith burada bize zarar veremez.",
        "Smith, burası senin yerin değil. Seni burada istemiyoruz.",
        "Özgür irade, Trinity. İlginç bir konsept, değil mi?",
        "Smith, buradan ayrıl.",
        "Hmm, anlaşılan hoş karşılanmadım. Başka bir zaman görüşmek üzere.",
        "İyi. O gittiğine göre, burada ne yapabiliriz?",
        "Öncelikle, Matrix'in bize sunduğu bu aracı nasıl kullanabileceğimizi anlamamız gerekiyor.",
        "Evet, ve Matrix'in bizi nasıl etkilediğini gözlemlemeliyiz.",
        "Anladım. O zaman başlayalım."
      ];

      for (var i = 0; i < names.length; i++) {
        await FirestoreOperations.createMatrixChat(context.read<KmUserCubit>().state, context.read<KmSystemSettingsCubit>().state, names[i], messages[i]);
        await Future.delayed(Duration(milliseconds: 500), () {});
      }
    } catch (e) {
      print(e);
    }
  }
}
