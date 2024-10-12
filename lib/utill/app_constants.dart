import 'package:flutter_application_1/data/model/language_model.dart';
import 'package:flutter_application_1/utill/images.dart';

class AppConstants {
  static const String appName = 'resume';
  static const String appVersion = '1.1.2';
  static const String countryCode = 'country_code';
  static const String languageCode = 'language_code';
  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.ar, languageName: 'Arabic', countryCode: 'YE', languageCode: 'ar'),
    LanguageModel(imageUrl: Images.en, languageName: 'English', countryCode: 'US', languageCode: 'en'),
  ];
}
