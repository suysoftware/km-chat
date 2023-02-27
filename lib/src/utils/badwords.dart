import 'package:profanity_filter/profanity_filter.dart';

Future<bool> badWordsChecker(String comingValue) async {
  final filter = ProfanityFilter();

//Check for profanity - returns a boolean (true if profanity is present)
  bool hasProfanity = filter.hasProfanity(comingValue);
  // ignore: avoid_print
  print('The string $comingValue has profanity: $hasProfanity');

  return hasProfanity;
}
