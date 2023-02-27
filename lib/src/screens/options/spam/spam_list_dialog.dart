// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_km/src/bloc/km_user_cubit.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/constants/style_constants.dart';
import 'package:one_km/src/models/user_blocked_map.dart';
import 'package:one_km/src/services/firestore_operations.dart';
import 'package:one_km/src/widgets/mini_widget.dart';
import 'package:sizer/sizer.dart';
import '../../../models/km_user.dart';

class SpamList extends StatelessWidget {
  KmUser kmUser;
  SpamList({super.key, required this.kmUser});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: Colors.transparent.withOpacity(0.90),
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
            SizedBox(height: 5.h),
            Container(
              width: 80.w,
              height: 60.h,
              decoration: BoxDecoration(
                  border: Border.all(color: ColorConstants.juniorColor)),
              child: ListView.builder(
                  itemCount: kmUser.userBlockedMap.entries.length,
                  itemBuilder: (context, indeks) {
                    return spamListItem(
                        kmUser.userBlockedMap.values.toList()[indeks], context);
                  }),
            ),
          ],
        ));
  }

  Widget spamListItem(UserBlockedMap userBlockedMap, BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 0.0.h, bottom: 0.0.h, left: 5.w, right: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '/${userBlockedMap.userName}',
            style: StyleConstants.optionsButtonTextStyle,
          ),
          const Spacer(),
          SizedBox(
              height: 40.sp,
              width: 40.sp,
              child: MiniWidgets.closeButton(context, () async {
                var response = await FirestoreOperations.spamRemove(
                    kmUser, userBlockedMap.userUid);
                if (response) {
                  context
                      .read<KmUserCubit>()
                      .removeBlocked(userBlockedMap.userUid);
                  Navigator.pop(context);
                }
              }))
        ],
      ),
    );
  }
}
