import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/main.dart';

class LanguageDialogWidget extends StatefulWidget {
  final Function setLanguageLabel;

  const LanguageDialogWidget(this.setLanguageLabel, {super.key});

  @override
  State<LanguageDialogWidget> createState() => _LanguageDialogWidgetState();
}

class _LanguageDialogWidgetState extends State<LanguageDialogWidget> {
  late AppLanguage _currentAppLanguage;

  void changeLanguage(AppLanguage language) {
    setState(() {
      _currentAppLanguage = language;
    });
    GetStorage().write(StorageKeys.appLanguage, language.toString().replaceFirst('AppLanguage.', ''));
    MyApp.setLocale(context, language.locale);
    widget.setLanguageLabel(language.toString().replaceFirst('AppLanguage.', ''));
  }

  @override
  void initState() {
    var storageLanguage = GetStorage().read(StorageKeys.appLanguage);
    setState(() {
      if (storageLanguage == null) {
        _currentAppLanguage = AppLanguage.system;
      } else {
        _currentAppLanguage = AppLanguage.values.byName(storageLanguage.toString().replaceFirst('AppLanguage.', ''));
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
          color: Theme.of(context).scaffoldBackgroundColor,
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
                      'Language',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).shadowColor,
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
                title: Text(
                  '⚙️ System',
                  style: TextStyle(color: Theme.of(context).shadowColor),
                ),
                leading: Radio<AppLanguage>(
                  activeColor: Theme.of(context).shadowColor,
                  fillColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).shadowColor),
                  value: AppLanguage.system,
                  groupValue: _currentAppLanguage,
                  onChanged: (AppLanguage? value) {
                    changeLanguage(value!);
                  },
                ),
                onTap: () {
                  changeLanguage(AppLanguage.system);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '🇺🇸 English',
                  style: TextStyle(color: Theme.of(context).shadowColor),
                ),
                leading: Radio<AppLanguage>(
                  activeColor: Theme.of(context).shadowColor,
                  fillColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).shadowColor),
                  value: AppLanguage.english,
                  groupValue: _currentAppLanguage,
                  onChanged: (AppLanguage? value) {
                    changeLanguage(value!);
                  },
                ),
                onTap: () {
                  changeLanguage(AppLanguage.english);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '🇷🇴 Romanian',
                  style: TextStyle(color: Theme.of(context).shadowColor),
                ),
                leading: Radio<AppLanguage>(
                  activeColor: Theme.of(context).shadowColor,
                  fillColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).shadowColor),
                  value: AppLanguage.romanian,
                  groupValue: _currentAppLanguage,
                  onChanged: (AppLanguage? value) {
                    changeLanguage(value!);
                  },
                ),
                onTap: () {
                  changeLanguage(AppLanguage.romanian);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
