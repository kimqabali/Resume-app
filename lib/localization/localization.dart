import 'package:flutter/material.dart';
import 'package:flutter_application_1/utill/app_constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Localization  {
   SharedPreferences? sharedPreferences;
   Locale _locale = Locale(AppConstants.languages[0].languageCode!, AppConstants.languages[0].countryCode);
  bool _isLtr = true;
  int? _languageIndex;

  Locale get locale => _locale;
  bool get isLtr => _isLtr;
  int? get languageIndex => _languageIndex;

   Future<void> loadCurrentLanguage() async {
     sharedPreferences = await SharedPreferences.getInstance();
     _locale = Locale(
       sharedPreferences!.getString(AppConstants.languageCode) ?? AppConstants.languages[0].languageCode!,
       sharedPreferences!.getString(AppConstants.countryCode) ?? AppConstants.languages[0].countryCode,
     );
     _isLtr = _locale.languageCode != 'ar';
     for (int index = 0; index < AppConstants.languages.length; index++) {
       if (AppConstants.languages[index].languageCode == locale.languageCode) {
         _languageIndex = index;
         break;
       }
     }
   }

   Future<void> saveLanguage(Locale locale) async {
     sharedPreferences = await SharedPreferences.getInstance();
     await sharedPreferences!.setString(AppConstants.languageCode, locale.languageCode);
     await sharedPreferences!.setString(AppConstants.countryCode, locale.countryCode!);
     // _locale = locale;
   }

  Future<String?> getCurrentLanguage() async{
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences!.getString(AppConstants.countryCode) ?? "US";
  }
}