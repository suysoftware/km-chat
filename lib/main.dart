// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:one_km/src/bloc/km_chat_reference.dart';
import 'package:one_km/src/bloc/km_system_settings_cubit.dart';
import 'package:one_km/src/bloc/km_user_cubit.dart';
import 'package:one_km/src/screens/login_screen.dart';
import 'package:one_km/src/services/firestore_operations.dart';
import 'package:one_km/src/utils/shared_preferences_helper.dart';
import 'package:sizer/sizer.dart';
import 'src/constants/color_constants.dart';
import 'src/screens/chat/chat_screen.dart';
import 'src/services/firebase_auth_service.dart';
import 'src/services/firebase_options.dart';

bool isLogged = false;
var kmUser;
var systemSettings;
SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> appTracking() async {
  if (await AppTrackingTransparency.trackingAuthorizationStatus == TrackingStatus.notDetermined) {
    // Show a custom explainer dialog before the system dialog
    //  await showCustomTrackingDialog(context);
    // Wait for dialog popping animation
    await Future.delayed(const Duration(milliseconds: 200));
    // Request system's tracking authorization dialog
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //print('Handling a background message ${message.messageId}');

  await Firebase.initializeApp();
}

Future<void> main() async {
  await init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const KmApp());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: FirebaseOptionsClass.firebaseConfig);
  await FirebaseAuthService.loggedCheck().then((value) => kmUser = value);
  await FirestoreOperations.kmSystemSettingsGetter().then((value) => systemSettings = value);
  await appTracking();
}

class KmApp extends StatelessWidget {
  const KmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return GestureDetector(
        onTap: () {
          WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
        },
        child: MultiBlocProvider(providers: [
          BlocProvider(
            create: (context) => KmUserCubit(),
          ),
          BlocProvider(
            create: (context) => KmSystemSettingsCubit(),
          ),
          BlocProvider(
            create: (context) => KmChatReferenceCubit(),
          ),
        ], child: const _cupertinoApp()),
      );
    }));
  }
}

class _cupertinoApp extends StatefulWidget {
  const _cupertinoApp();

  @override
  State<_cupertinoApp> createState() => __cupertinoAppState();
}

class __cupertinoAppState extends State<_cupertinoApp> with WidgetsBindingObserver {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> _firebaseMessagingOnMessageHandler(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    messaging.setForegroundNotificationPresentationOptions(alert: false, badge: false, sound: false);
//uygulamada iken
  }

  Future<void> _firebaseMessagingOpenedAppHandler(RemoteMessage message) async {
    if (message.data["notiCategoryDetail"] == "private_message") {
      var senderUid = message.data["senderUserUid"];
      var senderName = message.data["senderUserName"];

      context.read<KmChatReferenceCubit>().goPrivate(context.read<KmUserCubit>().state.userUid, senderUid, senderName);
      prefsHelper.removeUnreadUser(senderUid);
    } else if (message.data["notiCategoryDetail"] == "public_message") {
      context.read<KmChatReferenceCubit>().goPublic(context.read<KmUserCubit>().state.userCoordinates, context.read<KmSystemSettingsCubit>().state);
    }

//mesaj açıldığında
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    if (systemSettings != null) {
      context.read<KmSystemSettingsCubit>().changeSettings(systemSettings);
    }
    if (kmUser != null && kmUser.userName != "") {
      isLogged = true;
      context.read<KmUserCubit>().changeUser(kmUser);

      FirebaseMessaging.onMessage.listen(_firebaseMessagingOnMessageHandler);
      FirebaseMessaging.onMessageOpenedApp.listen(_firebaseMessagingOpenedAppHandler);
    } else {
      isLogged = false;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive) {
      if (kmUser != null && kmUser.userName != "") {
        await FirestoreOperations.activityControl(kmUser, 'offline');
      }

      messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    if (state == AppLifecycleState.paused) {
      messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      if (kmUser != null && kmUser.userName != "") {
        await FirestoreOperations.activityControl(kmUser, 'offline');
      }
    }

    if (state == AppLifecycleState.resumed) {
      messaging.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: false,
        sound: false,
      );
      if (kmUser != null && kmUser.userName != "") {
        await FirestoreOperations.activityControl(kmUser, 'online');
      }
    }

    if (state == AppLifecycleState.detached) {
      if (kmUser != null && kmUser.userName != "") {
        await FirestoreOperations.activityControl(kmUser, 'offline');
      }

      messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      color: CupertinoColors.activeGreen,
      routes: {
        "/": (BuildContext context) => isLogged == false ? const LoginScreen() : const ChatScreen(),
        "/Login": (BuildContext context) => const LoginScreen(),
        "/Chat": (BuildContext context) => const ChatScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
          brightness: Brightness.dark,
          textTheme: CupertinoTextThemeData(
              textStyle: TextStyle(
            color: ColorConstants.designGreen,
            fontFamily: "Coderstyle",
            fontSize: 24,
            letterSpacing: 0.3,
            wordSpacing: 0.03,
          ))),
    );
  }
}
