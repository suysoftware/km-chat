import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_km/src/bloc/km_user_cubit.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/services/firestore_operations.dart';
import 'package:one_km/src/widgets/mini_widget.dart';
import 'package:sizer/sizer.dart';

class NotificationDialog extends StatefulWidget {
  const NotificationDialog({super.key});

  @override
  State<NotificationDialog> createState() => _NotificationDialogState();
}

class _NotificationDialogState extends State<NotificationDialog> {
  bool publicSwitchValue = false;
  bool privateSwitchValue = false;

  @override
  void initState() {
    super.initState();
    publicSwitchValue = context
        .read<KmUserCubit>()
        .state
        .userNotificationSettings
        .publicMessage;
    privateSwitchValue = context
        .read<KmUserCubit>()
        .state
        .userNotificationSettings
        .privateMessage;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.transparent.withOpacity(0.90),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MiniWidgets.closeButton(context, null),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              const Text('Set your notifications!'),
              SizedBox(
                height: 5.h,
              ),
              notificationSwitch(publicSwitchValue, true),
              SizedBox(
                height: 2.h,
              ),
              notificationSwitch(privateSwitchValue, false)
            ],
          ),
        ));
  }

  Widget notificationSwitch(bool switchValue, bool isPublic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(isPublic ? 'Public ' : 'Private'),
        SizedBox(
          width: 10.w,
        ),
        CupertinoSwitch(
          value: switchValue,
          onChanged: (value) async {
            var requestResult =
                await FirestoreOperations.kmUserNotificationSettingUpdate(
                    context.read<KmUserCubit>().state, isPublic, value);
            if (requestResult) {
              if (isPublic && requestResult) {
                setState(() {
                  context
                      .read<KmUserCubit>()
                      .notificationSettingChange(privateSwitchValue, value);
                  publicSwitchValue = value;
                });
              } else if (isPublic != true && requestResult) {
                setState(() {
                     context
                      .read<KmUserCubit>()
                      .notificationSettingChange(value, publicSwitchValue);
                  privateSwitchValue = value;
                });
              }
            }
          },
          activeColor: ColorConstants.designGreen,
          trackColor: ColorConstants.systemColor,
          thumbColor: const Color.fromARGB(255, 237, 227, 227),
        ),
      ],
    );
  }
}
