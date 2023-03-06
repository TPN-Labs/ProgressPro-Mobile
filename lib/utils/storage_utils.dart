import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';
import 'package:progressp/config/constants.dart';

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

bool isThemeDark() {
  var storageThemeMode = GetStorage().read(StorageKeys.appThemeMode);
  if (storageThemeMode == null) return SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
  ThemeMode currentThemeMode = ThemeMode.values.byName(storageThemeMode.toString().replaceFirst('ThemeMode.', ''));
  if (currentThemeMode == ThemeMode.light) {
    return false;
  } else if (currentThemeMode == ThemeMode.dark) {
    return true;
  } else {
    return SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
  }
}

String _decodeBase64(String str) {
  String output = str.replaceAll('-', '+').replaceAll('_', '/');
  switch (output.length % 4) {
    case 0:
      break;
    case 2:
      output += '==';
      break;
    case 3:
      output += '=';
      break;
    default:
      throw Exception('Illegal base64url string!"');
  }
  return utf8.decode(base64Url.decode(output));
}

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  if (parts.length != 3) {
    throw Exception('invalid token');
  }
  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  if (payloadMap is! Map<String, dynamic>) {
    throw Exception('invalid payload');
  }
  return payloadMap;
}
