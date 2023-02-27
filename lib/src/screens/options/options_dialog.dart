// ignore_for_file: sort_child_properties_last

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
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
          _availability =
              isAvailable ? Availability.available : Availability.unavailable;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            optionButton('/profile       ', () => profileFunction(context)),
            optionButton('/howtouse      ', () => howToUseFunction(context)),
            BlocBuilder<KmUserCubit, KmUser>(builder: (context, snapshotBloc) {
              return optionButton(
                  '/spamlist [${snapshotBloc.userBlockedMap.entries.length}]  ',
                  () => blockListFunction(context, snapshotBloc));
            }),
            optionButton('/Account Revive', () => reviveFunction(context)),
            optionButton('/Notifications', () => notificationFunction(context)),
            optionButton('/Rate Us!     ', () => rateUsFunction()),
            SizedBox(
              height: 4.h,
            ),
            MiniWidgets.closeButton(context, null)
          ],
        ),
      ),
    );
  }

  TextButton optionButton(String text, Function() func) {
    return TextButton(
        child: Text(
          text,
          style: StyleConstants.optionsButtonTextStyle,
        ),
        onPressed: func);
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

  Future<void> rateUsFunction() =>
      _inAppReview.requestReview().whenComplete(() async {
        try {
          final isAvailable = await _inAppReview.isAvailable();

          if (isAvailable == false) {
            // ignore: unused_local_variable
            FirebaseAuth auth = FirebaseAuth.instance;
          }
          setState(() {
            _availability = isAvailable && !Platform.isAndroid
                ? Availability.available
                : Availability.unavailable;
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
}
