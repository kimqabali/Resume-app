import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/localization/app_localization.dart';
import 'package:flutter_application_1/localization/language_constrants.dart';
import 'package:flutter_application_1/localization/localization.dart';
import 'package:flutter_application_1/utill/app_constants.dart';
import 'dart:convert';
import 'package:flutter_application_1/utill/color_resources.dart';
import 'package:flutter_application_1/utill/common.dart';
import 'package:flutter_application_1/utill/images.dart';
import 'package:flutter_application_1/utill/styles.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() => runApp(const MyApp());
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final LocalizationProvider localizationProvider = LocalizationProvider();
//   await localizationProvider.loadCurrentLanguage();
//   runApp(MyApp(localizationProvider: localizationProvider));
// }
//

// class MyApp extends StatelessWidget {
//   MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     final localizationProvider = LocalizationProvider();
//     localizationProvider.loadCurrentLanguage();
//     return MaterialApp(
//       home: const ResumeScreen(),
//       debugShowCheckedModeBanner: false,
//       locale: localizationProvider.locale,
//       localizationsDelegates: const [
//         AppLocalization.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: const [
//         Locale('ar', 'YE'),
//         Locale('en', 'US'),
//       ],
//     );
//   }
// }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localizationProvider = Localization();
    localizationProvider.loadCurrentLanguage();

    return FutureBuilder(
      future: localizationProvider.loadCurrentLanguage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return MaterialApp(
            home: const ResumeScreen(),
            debugShowCheckedModeBanner: false,
            locale: localizationProvider.locale,
            localizationsDelegates: const [
              AppLocalization.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar', 'YE'),
              Locale('en', 'US')
            ],
          );
        }
      },
    );
  }
}


class ResumeScreen extends StatefulWidget {
  const ResumeScreen({super.key});

  @override
  _ResumeScreenState createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  int selectedIndex = 0;
  final localizationProvider = Localization();
  Future<Map<String, dynamic>> loadResumeData() async {
    String fileName = localizationProvider.locale.languageCode == 'ar'
        ? 'assets/json/resume_data_ar.json'
        : 'assets/json/resume_data_en.json';
    final String response = await rootBundle.loadString(fileName);
    return json.decode(response);
  }
  @override
  void initState() {
    super.initState();
    localizationProvider.loadCurrentLanguage().then((_) {
      setState(() {
        selectedIndex = localizationProvider.languageIndex ?? 0;
      });
    });
  }
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          title: Text(getTranslated('change_language', context) ?? 'تغيير اللغة'),
          content: SizedBox(
            width: 300,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: AppConstants.languages.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(AppConstants.languages[index].languageName!),
                          leading: SizedBox(
                            width: 24,
                            height: 24,
                            child: Image.asset(AppConstants.languages[index].imageUrl!),
                          ),
                          trailing: selectedIndex == index ? const Icon(Icons.check) : null,
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final locale = Locale(
                          AppConstants.languages[selectedIndex].languageCode!,
                          AppConstants.languages[selectedIndex].countryCode,
                        );
                        await localizationProvider.saveLanguage(locale);
                        localizationProvider.loadCurrentLanguage();
                        Navigator.pop(context);
                        // إعادة تحميل الشاشة
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyApp(),
                          ),
                        );
                      },
                      child: Text(getTranslated('save', context) ?? 'حفظ'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(getTranslated('cancel', context) ?? 'إلغاء'),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated('resume', context) ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _showLanguageDialog,
          ),
        ],
      ),
      backgroundColor: ColorResources.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: loadResumeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text( '${getTranslated('Error', context) ?? ''}: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final resumeData = snapshot.data!;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      color: ColorResources.white,
                      boxShadow: const [
                        BoxShadow(
                          color: ColorResources.hintTextColor,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                color: ColorResources.grey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // const CircleAvatar(
                                    //   radius: 50,
                                    //   backgroundImage: AssetImage(Images.profile),
                                    // ),
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        image: const DecorationImage(
                                          image: AssetImage(Images.profile),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    space(20),
                                    customTextWidget(name: resumeData['profile']['name'],style: style24Bold()),
                                    space(5),
                                    customTextWidget(name: resumeData['profile']['title'],style: style18Regular(color: ColorResources.hintTextColor)),
                                    space(20),
                                    Row(
                                      children: [
                                        const Icon(Icons.phone, size: 16),
                                        space(0,width: 10),
                                        customTextWidget(name: resumeData['profile']['phone']),
                                      ],
                                    ),
                                    space(10),
                                    Row(
                                      children: [
                                        const Icon(Icons.email, size: 16),
                                        space(0,width: 10),
                                        customTextWidget(name: resumeData['profile']['email']),
                                      ],
                                    ),
                                    space(30),
                                    customTextWidget(name: getTranslated('skills', context) ?? '',style: style18Bold()),
                                    space(10),
                                    for (var skill in resumeData['profile']['skills'])
                                      skillBar(skill['skill'], skill['level']),
                                    space(30),
                                    customTextWidget(name: getTranslated('work_experiences', context) ?? '',style: style18Bold()),
                                    space(10),
                                    for (var experience in resumeData['experience'])
                                      experienceItem(
                                          experience['years'],
                                          experience['company'],
                                          experience['position']),
                                    space(30),
                                    customTextWidget(name: getTranslated('education', context) ?? '',style: style18Bold()),
                                    space(10),
                                    for (var education in resumeData['education'])
                                      educationItem(education['years'],
                                          education['degree'], education['school']),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    customTextWidget(name: getTranslated('awards', context) ?? '',style: style18Bold()),
                                    space(10),
                                    for (var award in resumeData['awards'])
                                      awardItem(award['year'], award['title']),
                                    space(30),
                                    customTextWidget(name: getTranslated('expertise', context) ?? '',style: style18Bold()),
                                    space(10),
                                    for (var expertise in resumeData['expertise'])
                                      expertiseItem(expertise),
                                    space(30),
                                    customTextWidget(name: getTranslated('references', context) ?? '',style: style18Bold()),
                                    space(10),
                                    for (var reference in resumeData['references'])
                                      referenceItem(
                                          reference['name'],
                                          reference['position'],
                                          reference['phone'],
                                          reference['email']),
                                    space(30),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return  Center(child: customTextWidget(name: getTranslated('no_data_available', context) ?? ''));
          }
        },
      ),
    );
  }

  Widget skillBar(String skill, double level) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          customTextWidget(name: skill),
          space(0,width: 10),
          Expanded(
            child: LinearProgressIndicator(
              value: level,
              backgroundColor: ColorResources.hintTextColor,
              color: ColorResources.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget experienceItem(String years, String company, String position) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customTextWidget(name: years,style:  style16Bold()),
          customTextWidget(name: company,style: style16Regular(color: ColorResources.hintTextColor)),
          customTextWidget(name: position),
        ],
      ),
    );
  }

  Widget educationItem(String years, String degree, String school) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customTextWidget(name: years, style:  style16Bold()),
          customTextWidget(name: degree, style: style16Regular(color: ColorResources.hintTextColor)),
          customTextWidget(name: school),
        ],
      ),
    );
  }

  Widget awardItem(String year, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customTextWidget(name: year, style:  style16Bold()),
          customTextWidget(name: title),
        ],
      ),
    );
  }

  Widget expertiseItem(String expertise) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: customTextWidget(name: expertise),

    );
  }

  Widget referenceItem(
      String name, String position, String phone, String email) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customTextWidget(name: name, style:  style16Bold()),
          customTextWidget(name: position, style: style16Regular(color: ColorResources.hintTextColor)),
          customTextWidget(name: phone),
          customTextWidget(name: email),
        ],
      ),
    );
  }

  Widget interestIcon(String icon, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Icon(IconData(icon.codeUnitAt(0)), size: 32, color: Colors.black),
          space(5),
          customTextWidget(name: label),
        ],
      ),
    );
  }
}
