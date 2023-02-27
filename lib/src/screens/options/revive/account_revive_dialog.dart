// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_km/src/bloc/km_user_cubit.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/constants/style_constants.dart';
import 'package:one_km/src/services/firestore_operations.dart';
import 'package:one_km/src/widgets/mini_widget.dart';
import 'package:sizer/sizer.dart';

class AccountReviveDialog extends StatefulWidget {
  const AccountReviveDialog({super.key});

  @override
  State<AccountReviveDialog> createState() => _AccountReviveDialogState();
}

class _AccountReviveDialogState extends State<AccountReviveDialog> {
  var t1 = TextEditingController();
  bool isError = false;
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
                height: 20.h,
              ),
              const Text('Fill account secret password!'),
              SizedBox(
                height: 2.h,
              ),
              secretPasswordTextFieldBuild(),
              SizedBox(
                height: isError ? 2.h : 0.h,
              ),
              isError ? const Text('ERROR') : const SizedBox(),
              SizedBox(
                height: 4.h,
              ),
              reviveButtoBuild(),
            ],
          ),
        ));
  }

  Widget reviveButtoBuild() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
            top: Radius.elliptical(20.0, 0.0), bottom: Radius.circular(50.0)),
        border: Border.all(color: ColorConstants.designGreen, width: 2),
      ),
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.all(4.0),
      child: CupertinoButton(
        child: Text(
          "Scribo\n Ergo\n Sum",
          style: TextStyle(
              fontFamily: "Noscefont",
              color: ColorConstants.designGreen,
              fontSize: 10.sp),
        ),
        onPressed: () async {
          showCupertinoDialog(
              barrierDismissible: true,
              context: context,
              builder: (context) => Dialog(
                    backgroundColor: CupertinoColors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.all(Radius.circular(200.sp))),
                    child: Image.asset(
                      'assets/images/matrix_world.gif',
                    ),
                  ));

          var response = await FirestoreOperations.accountReviveRequest(
              context.read<KmUserCubit>().state, t1.text);
          await Future.delayed(const Duration(milliseconds: 3000), () async {});
          if (response) {
            var userWithRevived = await FirestoreOperations.getKmUser(
                context.read<KmUserCubit>().state.userUid);

            if (userWithRevived.userHasBanned == false) {
              context.read<KmUserCubit>().changeUser(userWithRevived);
              Navigator.pop(context);
              Navigator.pop(context);
            }
          } else {
            setState(() {
              isError = true;
            });
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget secretPasswordTextFieldBuild() {
    return SizedBox(
      width: 65.w,
      child: CupertinoTextFormFieldRow(
        autofocus: true,
        style: StyleConstants.profileSecretPasswordTextStyle,
        keyboardType: TextInputType.name,
        maxLines: 1,
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        cursorColor: ColorConstants.designGreen,
        cursorHeight: 20,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: ColorConstants.designGreen, width: 0.4),
          ),
        ),
        controller: t1,
      ),
    );
  }
}
