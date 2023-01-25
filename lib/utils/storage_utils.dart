import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:progressp/config/constants.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

bool isThemeDark() {
  var storageThemeMode = GetStorage().read(StorageKeys.appThemeMode);
  if (storageThemeMode == null) return false;
  ThemeMode currentThemeMode = ThemeMode.values
      .byName(storageThemeMode.toString().replaceFirst('ThemeMode.', ''));
  if (currentThemeMode == ThemeMode.light) {
    return false;
  } else if (currentThemeMode == ThemeMode.dark) {
    return true;
  } else {
    return SchedulerBinding.instance.window.platformBrightness ==
        Brightness.dark;
  }
}
