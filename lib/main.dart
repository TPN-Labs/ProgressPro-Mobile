import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/controller/student/meeting_controller.dart';
import 'package:progressp/controller/student/session_controller.dart';
import 'package:progressp/controller/student/student_controller.dart';
import 'package:progressp/view/home/home_screen.dart';
import 'package:progressp/view/welcome_screen.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static setColorTheme(BuildContext context, ThemeMode colorScheme) async {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setColorTheme(colorScheme);
  }

  static setLocale(BuildContext context, Locale locale) async {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
    Get.updateLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {
  final APIMeetingController _apiMeetingController = Get.put(APIMeetingController());
  final APISessionController _apiSessionController = Get.put(APISessionController());
  final APIStudentController _apiStudentController = Get.put(APIStudentController());
  final String? _authKey = GetStorage().read(StorageKeys.authKey);

  ThemeMode _colorScheme = ThemeMode.system;

  late Locale _appLocale = getLanguageFromStorage().locale;

  ThemeMode getThemeFromStorage() {
    var storageThemeMode = GetStorage().read(StorageKeys.appThemeMode);
    if (storageThemeMode == null) return ThemeMode.system;
    return ThemeMode.values.byName(storageThemeMode.toString().replaceFirst('ThemeMode.', ''));
  }

  ThemeData getThemeMode() {
    ThemeMode currentThemeMode = getThemeFromStorage();
    if (currentThemeMode == ThemeMode.light) {
      return AppTheme.lightTheme();
    } else if (currentThemeMode == ThemeMode.dark) {
      return AppTheme.darkTheme();
    } else {
      return (SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? AppTheme.darkTheme() : AppTheme.lightTheme());
    }
  }

  setColorTheme(ThemeMode schemeMode) {
    if (schemeMode == ThemeMode.system) {
      var deviceColorScheme = SchedulerBinding.instance.window.platformBrightness;
      setState(() {
        AppTheme.isLightTheme = deviceColorScheme == Brightness.dark;
      });
    } else if (schemeMode == ThemeMode.dark) {
      setState(() {
        AppTheme.isLightTheme = false;
      });
    } else if (schemeMode == ThemeMode.light) {
      setState(() {
        AppTheme.isLightTheme = true;
      });
    }
    _colorScheme = schemeMode;
    GetStorage().write(StorageKeys.appThemeMode, _colorScheme.toString());
  }

  AppLanguage getLanguageFromStorage() {
    var storageLanguage = GetStorage().read(StorageKeys.appLanguage);
    if (storageLanguage == null) return AppLanguage.system;
    return AppLanguage.values.byName(storageLanguage.toString().replaceFirst('AppLanguage.', ''));
  }

  setLocale(Locale value) {
    setState(() {
      _appLocale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_authKey != null) {
      _apiMeetingController.userGetAll();
      _apiSessionController.userGetAll();
      _apiStudentController.userGetAll();
    }

    print('locale is: $_appLocale');
    return GetMaterialApp(
      title: 'Progress Pro',
      debugShowCheckedModeBanner: false,
      theme: getThemeMode(),
      home: _authKey != null ? const HomeScreen() : const WelcomeScreen(),
      locale: _appLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        AppLanguage.english.locale, // English
        AppLanguage.romanian.locale // Romanian
      ],
    );
  }
}
