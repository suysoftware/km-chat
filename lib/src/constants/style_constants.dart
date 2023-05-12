
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'color_constants.dart';

class StyleConstants {
  static var systemTextStyle = TextStyle(
      color: ColorConstants.systemColor,
      fontFamily: "CoderStyle",
      fontSize: 14.sp,
      letterSpacing: 0.5,
      wordSpacing: 0.05,
      height: 0.8,
      fontWeight: FontWeight.normal);

  static var adminTextStyle = TextStyle(
    color: ColorConstants.adminColor,
    fontFamily: "CoderStyle",
    fontSize: 17.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );

  static var masterTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "CoderStyle",
    fontSize: 17.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );

  static var plebTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "CoderStyle",
    fontSize: 17.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );
  static const matrixtTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "MatrixCodeMix",
    fontSize: 15,
    letterSpacing: 0.5,
    wordSpacing: 0.03,
  );
  static TextStyle systemNameTextStyle = TextStyle(
      color: ColorConstants.systemColor,
      fontFamily: "CoderStyle",
      fontSize: 14.sp,
      letterSpacing: 0.5,
      wordSpacing: 0.05,
      height: 0.8,
      fontWeight: FontWeight.normal);

  static var adminNameTextStyle = TextStyle(
      color: ColorConstants.adminColor,
      fontFamily: "CoderStyle",
      fontSize: 17.sp,
      letterSpacing: 0.5,
      wordSpacing: 0.05,
      height: 0.8,
      fontWeight: FontWeight.bold);

  static var masterNameTextStyle = TextStyle(
      color: ColorConstants.masterColor,
      fontFamily: "CoderStyle",
      fontSize: 17.sp,
      letterSpacing: 0.5,
      wordSpacing: 0.05,
      height: 0.8,
      fontWeight: FontWeight.bold);

  static var plebNameTextStyle = TextStyle(
      color: ColorConstants.designGreen,
      fontFamily: "CoderStyle",
      fontSize: 17.sp,
      letterSpacing: 0.5,
      wordSpacing: 0.05,
      height: 0.8,
      fontWeight: FontWeight.bold);

  static var privateMessageTextStyle = TextStyle(
    color: ColorConstants.privateMessageColor,
    fontFamily: "CoderStyle",
    fontSize: 17.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );

  static var botMessageTextStyle = TextStyle(
    color: ColorConstants.systemColor,
    fontFamily: "CoderStyle",
    fontSize: 17.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );

  static var optionsXTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    //fontFamily: "Nosce",
    fontWeight: FontWeight.bold,
    fontSize: 34.sp,
  );
  static var optionsButtonTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "CoderStyle",
    fontSize: 30.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );

  static var profileNameTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "CoderStyle",
    fontSize: 34.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );
  static var profileLevelTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "CoderStyle",
    fontSize: 27.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );
  static var profileTitlePlebTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "CoderStyle",
    fontSize: 28.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );
  static var profileTitleMasterTextStyle = TextStyle(
    color: ColorConstants.masterColor,
    fontFamily: "CoderStyle",
    fontSize: 28.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );
  static var profileTitleAdminTextStyle = TextStyle(
    color: ColorConstants.adminColor,
    fontFamily: "CoderStyle",
    fontSize: 28.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );

  static var profileSecretPasswordTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "CoderStyle",
    fontSize: 10.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );

 
/*  static TextStyle textFieldTextStyleGetter(bool isPrivate) {
    print(userTitle);
    switch (userTitle) {
      case "system":
        return systemTextStyle;
      case "admin":
        return adminTextStyle;
      case "master":
        return masterTextStyle;
      case "pleb":
        return plebTextStyle;
      default:
        return plebTextStyle;
    }
  } */
}

/*import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'color_constants.dart';

class StyleConstants {
  static const double height = 1.7;
  static const double wordSpacing = 5;
  static const double letterSpacing = 2;
  static var systemTextStyle =
      TextStyle(color: ColorConstants.systemColor, fontFamily: "CoderStyle", fontSize: 7.sp, letterSpacing: letterSpacing, wordSpacing: wordSpacing, height: height, fontWeight: FontWeight.normal);

  static var adminTextStyle = TextStyle(
    color: ColorConstants.adminColor,
    fontFamily: "CoderStyle",
    fontSize: 12.sp,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    height: height,
  );

  static var masterTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "CoderStyle",
    fontSize: 6.sp,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    height: height,
  );

  static var plebTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "CoderStyle",
    fontSize: 7.sp,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    height: height,
  );
  static var matrixtTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "MatrixCodeMix",
    fontSize: 9.sp,
    letterSpacing: letterSpacing,
    wordSpacing: wordSpacing,
    height: height,
  );
  static TextStyle systemNameTextStyle =
      TextStyle(color: ColorConstants.systemColor, fontFamily: "CoderStyle", fontSize: 7.sp, letterSpacing: letterSpacing, wordSpacing:wordSpacing, height: height, fontWeight: FontWeight.normal);

  static var adminNameTextStyle =
      TextStyle(color: ColorConstants.adminColor, fontFamily: "CoderStyle", fontSize: 12.sp, letterSpacing: letterSpacing, wordSpacing: wordSpacing, height: height, fontWeight: FontWeight.bold);

  static var masterNameTextStyle =
      TextStyle(color: ColorConstants.masterColor, fontFamily: "CoderStyle", fontSize: 12.sp, letterSpacing: letterSpacing, wordSpacing: wordSpacing, height: height, fontWeight: FontWeight.bold);

  static var plebNameTextStyle =
      TextStyle(color: ColorConstants.designGreen, fontFamily: "CoderStyle", fontSize: 7.sp, letterSpacing: letterSpacing, wordSpacing:wordSpacing, height: height, fontWeight: FontWeight.bold);

  static var privateMessageTextStyle = TextStyle(
    color: ColorConstants.privateMessageColor,
    fontFamily: "CoderStyle",
    fontSize: 17.sp,
    letterSpacing:letterSpacing,
    wordSpacing: wordSpacing,
    height: height,
  );

  static var optionsXTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    //fontFamily: "Nosce",
    fontWeight: FontWeight.bold,
    fontSize: 34.sp,
  );
  static var optionsButtonTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "CoderStyle",
    fontSize: 30.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );

  static var profileNameTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "CoderStyle",
    fontSize: 34.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );
  static var profileLevelTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "CoderStyle",
    fontSize: 27.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );
  static var profileTitlePlebTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "CoderStyle",
    fontSize: 28.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );
  static var profileTitleMasterTextStyle = TextStyle(
    color: ColorConstants.masterColor,
    fontFamily: "CoderStyle",
    fontSize: 28.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );
  static var profileTitleAdminTextStyle = TextStyle(
    color: ColorConstants.adminColor,
    fontFamily: "CoderStyle",
    fontSize: 28.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );

  static var profileSecretPasswordTextStyle = TextStyle(
    color: ColorConstants.designGreen,
    fontFamily: "CoderStyle",
    fontSize: 10.sp,
    letterSpacing: 0.5,
    wordSpacing: 0.05,
    height: 0.8,
  );

/*  static TextStyle textFieldTextStyleGetter(bool isPrivate) {
    print(userTitle);
    switch (userTitle) {
      case "system":
        return systemTextStyle;
      case "admin":
        return adminTextStyle;
      case "master":
        return masterTextStyle;
      case "pleb":
        return plebTextStyle;
      default:
        return plebTextStyle;
    }
  } */
}
 */