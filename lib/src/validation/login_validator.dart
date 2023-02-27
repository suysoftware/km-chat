import 'package:one_km/src/utils/badwords.dart';

class LoginValidationMixin {
  // ignore: body_might_complete_normally_nullable
  String? validateUserName(String? value) {



    
    if (value!.length < 4 || value.length > 12) {
      return "Must be 4-12 characters";
    }

    if (value.contains(" ")) {
      //t1.clear();
      return " Dont Use Space !";
    }
    if (value == "checkbox") {
      return "Please agree our Terms!!";
    }
    if (value == "alreadyexist") {
      return "Name Alread Exist !";
    }
    badWordsChecker(value).then((value) {
      if (value == true) {
        //   t1.clear();
        return "You Can't Use Profanity!!";
      }
    });
  }
}
