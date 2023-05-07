// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:one_km/src/bloc/km_user_cubit.dart';
import 'package:one_km/src/constants/color_constants.dart';
import 'package:one_km/src/dialogs/terms_of_use.dart';
import 'package:one_km/src/models/km_user.dart';
import 'package:one_km/src/services/firebase_auth_service.dart';
import 'package:one_km/src/services/firestore_operations.dart';
import 'package:one_km/src/validation/login_validator.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  var loginValidator = LoginValidationMixin();
  var t1 = TextEditingController();
  late AnimationController animationController;
  late AnimationController animationController2;
  late Animation<double> alphaAnimationValue;
  late Animation<double> checkBoxOpacity;
  var formKey = GlobalKey<FormState>();
  var loginUserName;

  bool checkbox = false;

  checkBox() {
    if (animationController2.isCompleted) {
      animationController2.reverse();
      checkbox = false;
    } else {
      animationController2.forward();
      checkbox = true;
    }
  }

  @override
  void initState() {
    super.initState();
      
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);
    animationController2 = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);

    alphaAnimationValue =
        Tween(begin: 0.0, end: 1.0).animate(animationController)
          ..addListener(() {
            setState(() {});
          });
    animationController.repeat(reverse: true);
    checkBoxOpacity = Tween(begin: 0.0, end: 1.0).animate(animationController2)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    animationController.dispose();
    animationController2.dispose();
    t1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants.themeColor,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 2.h,
              ),
              temetNosceTextBuild(),
              SizedBox(
                height: 10.h,
              ),
              nickNameTextFieldBuild(),
              SizedBox(
                height: 8.h,
              ),
              loginButtoBuild(),
              SizedBox(
                height: 3.h,
              ),
              privacyBoxBuild(),
              termsOfUseBuild(),
            ],
          ),
        ));
  }

  Text temetNosceTextBuild() {
    return Text(
      "Temet Nosce",
      style: TextStyle(fontFamily: "Noscefont", fontSize: 40.sp),
    );
  }

  Widget nickNameTextFieldBuild() {
    return SizedBox(
      width: 50.w,
      child: CupertinoTextFormFieldRow(
        validator: loginValidator.validateUserName,
        style: const TextStyle(color: ColorConstants.designGreen),
        keyboardType: TextInputType.name,
        maxLines: 1,
        maxLength: 15,
        textCapitalization: TextCapitalization.words,
        onSaved: (String? value) {
          if (value != null) {
            loginUserName = value;
          }
        },
        placeholderStyle: TextStyle(
            color: ColorConstants.designGreen,
            fontFamily: "Noscefont",
            fontSize: 9.sp),
        placeholder: "Choose Nickname",
        padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
        cursorColor: ColorConstants.designGreen,
        cursorHeight: 20,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: ColorConstants.designGreen, width: 1),
          ),
        ),
        controller: t1,
      ),
    );
  }

  Widget loginButtoBuild() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
            top: Radius.elliptical(20.0, 0.0), bottom: Radius.circular(50.0)),
        border: Border.all(color: ColorConstants.designGreen, width: 2),
      ),
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      child: CupertinoButton(
        child: Opacity(
          opacity: alphaAnimationValue.value,
          child: Text(
            "Scribo\n Ergo\n Sum",
            style: TextStyle(
                fontFamily: "Noscefont",
                color: ColorConstants.designGreen,
                fontSize: 18.sp),
          ),
        ),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            /*final settingsRef = FirebaseFirestore.instance
                .collection('system')
                .doc('system_settings')
                .withConverter(
                    fromFirestore: (snapshot, _) =>
                        KmSystemSettings.fromJson(snapshot.data()!),
                    toFirestore: (kmsetting, _) => kmsetting.toJson());
            */

            var settingsData =
                await FirestoreOperations.kmSystemSettingsGetter();

            if (settingsData.allUserNames.contains(t1.text)) {
              t1.text = "alreadyexist";
              formKey.currentState!.validate();
              t1.clear();
            } else {
              if (checkbox != false) {
                bool isLocationOkay = true;

                try {
                  await Geolocator.requestPermission();
                  await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high,
                  );
                } catch (e) {
                  isLocationOkay = false;
                  showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                            content: const Text(
                                '1 KM need your location, Give permission on settings'),
                            actions: [
                              CupertinoButton(
                                  child: const Text('Okay'),
                                  onPressed: () async {
                                    try {
                                      await Geolocator.requestPermission();
                                      await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.high,
                                      );
                                    } catch (e) {
                                      await Geolocator.openAppSettings();
                                    }

                                    Navigator.pop(context);
                                  })
                            ],
                          ));
                }
                if (isLocationOkay) {
                  formKey.currentState!.save();

                  User? user = await FirebaseAuthService.loginFirebase(context);
                  if (user != null) {
                    var kmUserStart = KmUser();
                    kmUserStart.userName = t1.text.toLowerCase();
                    kmUserStart.userUid = user.uid;

                    showCupertinoDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) => Dialog(
                              backgroundColor: CupertinoColors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(200.sp))),
                              child: Image.asset(
                                'assets/images/matrix_world.gif',
                              ),
                            ));

                    await Future.delayed(const Duration(milliseconds: 8000),
                        () async {
                      var kmUser =
                          await FirestoreOperations.createNewUser(kmUserStart);

                      context.read<KmUserCubit>().changeUser(kmUser);

                      await Navigator. pushReplacementNamed(context, "/Chat");
                    });
                  }
                }
              } else {
                var rememberName = t1.text;
                t1.text = "checkbox";
                formKey.currentState!.validate();
                t1.text = rememberName;
              }
            }
          } else {
            t1.clear();
          }
        },
      ),
    );
  }

  Widget privacyBoxBuild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "I agree Terms & Conditions and Privacy Policy ",
          style: TextStyle(fontSize: 13.sp),
        ),
        GestureDetector(
          onTap: () {
            checkBox();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 6.w,
                width: 6.w,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5.0)),
                        border: Border.all(
                            color: ColorConstants.designGreen, width: 1.0)),
                    child: Opacity(
                        opacity: checkBoxOpacity.value,
                        child: const Icon(
                          CupertinoIcons.check_mark,
                          color: ColorConstants.designGreen,
                        )))),
          ),
        ),
      ],
    );
  }

  Widget termsOfUseBuild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        const TermsOfUse(),
      ],
    );
  }
}
