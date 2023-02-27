// ignore_for_file: constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class RestApiConstants {
  static  String API_LINK_AUTH =dotenv.env['API_LINK_AUTH'].toString();
  static  String API_LINK_TEST =dotenv.env['API_LINK_TEST'].toString();
  static  String API_LINK_JOIN_ROOM_MESSAGE =dotenv.env['API_LINK_JOIN_ROOM_MESSAGE'].toString();
  static  String API_LINK_SPAM_TARGET =dotenv.env['API_LINK_SPAM_TARGET'].toString();
  static  String API_LINK_AVATAR_CHANGE =dotenv.env['API_LINK_AVATAR_CHANGE'].toString();
  static  String API_LINK_SPAM_REMOVE =dotenv.env['API_LINK_SPAM_REMOVE'].toString();
  static  String API_LINK_ACCOUNT_REVIVE =dotenv.env['API_LINK_ACCOUNT_REVIVE'].toString();
  static  String API_LINK_ACTIVITY_REQUEST =dotenv.env['API_LINK_ACTIVITY_REQUEST'].toString();
  static  String API_LINK_NOTIFICATION_SENDER =dotenv.env['API_LINK_NOTIFICATION_SENDER'].toString();
  static  String API_LINK_TOKEN_UPDATE_REQUEST =dotenv.env['API_LINK_TOKEN_UPDATE_REQUEST'].toString();
  static  String API_LINK_NOTIFICATION_SETTING_UPDATE =dotenv.env['API_LINK_NOTIFICATION_SETTING_UPDATE'].toString();
}
