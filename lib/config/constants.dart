import 'package:flutter/material.dart';

enum AppLanguage {
  system('sys'),
  english('en'),
  romanian('ro');

  final String langCode;

  const AppLanguage(this.langCode);

  Locale get locale => langCode == 'sys'
      ? WidgetsBinding.instance.window.locales.first
      : langCode == 'en'
          ? const Locale('en')
          : const Locale('ro');
}

enum WeekStart {
  sunday,
  monday,
}

const List<String> allGenders = <String>['Male', 'Female', 'Other'];

class Constants {
  static const String apiHost = 'server.progress-pro.app';
  static const String apiEndpoint = 'https://$apiHost/api';

  // static const String apiEndpoint = 'http://127.0.0.1:3000/api';

  static const double topBarHeight = 70.0;
  static const double iconSize = 24.0;
  static const int transitionDuration = 350;

  static const EdgeInsets defaultScreenPadding = EdgeInsets.only(left: 15, right: 15);
  static RegExp regExpenseValue = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  static String Function(Match) mathFuncExpenseValue = (Match match) => '${match[1]},';

  static String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String convertMonthNumber(int month) {
    switch (month) {
      case 1:
        return 'JANUARY';
      case 2:
        return 'FEBRUARY';
      case 3:
        return 'MARCH';
      case 4:
        return 'APRIL';
      case 5:
        return 'MAY';
      case 6:
        return 'JUNE';
      case 7:
        return 'JULY';
      case 8:
        return 'AUGUST';
      case 9:
        return 'SEPTEMBER';
      case 10:
        return 'OCTOBER';
      case 11:
        return 'NOVEMBER';
      case 12:
        return 'DECEMBER';
    }
    return 'UNK';
  }
}

class StorageKeys {
  static const String appThemeMode = 'appThemeMode';
  static const String appWeekStart = 'appWeekStart';
  static const String appLanguage = 'appLanguage';
  static const String authKey = 'authKey';
  static const String allMeetings = 'allMeetings';
  static const String allStudents = 'allStudents';
  static const String allSessions = 'allSessions5';
}

enum APIMethods {
  create,
  read,
  update,
  delete,
  readNotification,
  unreadNotification,
}

enum SessionStatus {
  started(1),
  paid(2),
  closed(3);

  final int value;

  const SessionStatus(this.value);

  IconData get icon => value == 1
      ? Icons.timeline
      : value == 2
          ? Icons.payment
          : Icons.lock;

  Color get color => value == 1
      ? Colors.blue
      : value == 2
          ? Colors.green
          : Colors.red;
}
