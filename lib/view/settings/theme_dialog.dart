import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/main.dart';
import 'package:progressp/utils/storage_utils.dart';

class ThemeDialogWidget extends StatefulWidget {
  final Function setThemeLabel;

  const ThemeDialogWidget(this.setThemeLabel, {super.key});

  @override
  State<ThemeDialogWidget> createState() => _ThemeDialogWidgetState();
}

class _ThemeDialogWidgetState extends State<ThemeDialogWidget> {
  late ThemeMode _currentThemeMode;

  void changeTheme(ThemeMode mode) {
    setState(() {
      _currentThemeMode = mode;
    });
    GetStorage().write(StorageKeys.appThemeMode, mode);
    widget.setThemeLabel(mode);
    MyApp.setColorTheme(context, mode);
  }

  @override
  void initState() {
    var storageThemeMode = GetStorage().read(StorageKeys.appThemeMode);
    setState(() {
      if (storageThemeMode == null) {
        _currentThemeMode = ThemeMode.system;
      } else {
        _currentThemeMode = ThemeMode.values.byName(storageThemeMode.toString().replaceFirst('ThemeMode.', ''));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
      child: Container(
        height: 250,
        width: Get.width,
        decoration: BoxDecoration(
          color: isThemeDark() == true ? const Color(0xff211F32) : const Color(0xfff1efff),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).shadowColor,
                        size: 20,
                      ),
                    ),
                    Text(
                      'Theme Settings',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: isThemeDark() == true ? Colors.white : Colors.black,
                          ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.transparent,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('System', style: TextStyle(color: isThemeDark() == true ? Colors.white : Colors.black)),
                leading: Radio<ThemeMode>(
                  activeColor: Theme.of(context).shadowColor,
                  fillColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).shadowColor),
                  value: ThemeMode.system,
                  groupValue: _currentThemeMode,
                  onChanged: (ThemeMode? value) {
                    changeTheme(value!);
                  },
                ),
                onTap: () {
                  changeTheme(ThemeMode.system);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Dark', style: TextStyle(color: isThemeDark() == true ? Colors.white : Colors.black)),
                leading: Radio<ThemeMode>(
                  activeColor: Theme.of(context).shadowColor,
                  fillColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).shadowColor),
                  value: ThemeMode.dark,
                  groupValue: _currentThemeMode,
                  onChanged: (ThemeMode? value) {
                    changeTheme(value!);
                  },
                ),
                onTap: () {
                  changeTheme(ThemeMode.dark);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Light', style: TextStyle(color: isThemeDark() == true ? Colors.white : Colors.black)),
                leading: Radio<ThemeMode>(
                  activeColor: Theme.of(context).shadowColor,
                  fillColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).shadowColor),
                  value: ThemeMode.light,
                  groupValue: _currentThemeMode,
                  onChanged: (ThemeMode? value) {
                    changeTheme(value!);
                  },
                ),
                onTap: () {
                  changeTheme(ThemeMode.light);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
