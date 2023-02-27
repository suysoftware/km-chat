// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_km/src/bloc/km_system_settings_cubit.dart';
import 'package:one_km/src/bloc/km_user_cubit.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/constants/style_constants.dart';
import 'package:one_km/src/models/km_user.dart';
import 'package:one_km/src/services/firestore_operations.dart';
import 'package:one_km/src/widgets/mini_widget.dart';
import 'package:sizer/sizer.dart';

class AvatarEditDialog extends StatelessWidget {
  final KmUser kmUser;

  const AvatarEditDialog(this.kmUser, {super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: ColorConstants.themeColor,
        child: Stack(
          children: [
            kmCloseButton(context),
            kmAvatarsGridView(context),
          ],
        ));
  }

  Widget kmCloseButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.sp),
      child: Align(
        alignment: Alignment.topRight,
        child: MiniWidgets.closeButton(context, null),
      ),
    );
  }

  Widget kmAvatarsGridView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Align(
        alignment: Alignment.center,
        child: GridView.builder(
          itemCount: context
              .read<KmSystemSettingsCubit>()
              .state
              .avatarMap
              .entries
              .length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (context, index) {
            return gridViewItem(
                context
                    .read<KmSystemSettingsCubit>()
                    .state
                    .avatarMap
                    .values
                    .toList()[index],
                context
                    .read<KmSystemSettingsCubit>()
                    .state
                    .avatarMap
                    .keys
                    .toList()[index],
                kmUser,
                context);
          },
        ),
      ),
    );
  }

  Widget gridViewItem(String avatarLink, String avatarName, KmUser kmUser,
      BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var response =
            await FirestoreOperations.avatarChangeRequest(kmUser, avatarName);

        if (response) {
          context.read<KmUserCubit>().changeUserAvatar(avatarLink);
          Navigator.pop(context);
        } else {}
      },
      child: SizedBox(
        height: 14.h,
        width: 30.w,
        child: Column(
          children: [
            Image.network(
              avatarLink,
              width: 60.sp,
              height: 60.sp,
            ),
            SizedBox(
              height: 1.h,
            ),
            Text(
              avatarName,
              style: StyleConstants.plebNameTextStyle,
            )
          ],
        ),
      ),
    );
  }
}
