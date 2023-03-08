import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';

class WeekStartsDialogWidget extends StatefulWidget {
  final Function setWeekLabel;

  const WeekStartsDialogWidget(this.setWeekLabel, {super.key});

  @override
  State<WeekStartsDialogWidget> createState() => _WeekStartsDialogWidgetState();
}

class _WeekStartsDialogWidgetState extends State<WeekStartsDialogWidget> {
  late WeekStart _currentWeekStart;

  void changeTheme(WeekStart weekStart) {
    setState(() {
      _currentWeekStart = weekStart;
    });
    GetStorage().write(StorageKeys.appWeekStart, weekStart.toString().replaceFirst('WeekStart.', ''));
    widget.setWeekLabel(weekStart.toString().replaceFirst('WeekStart.', ''));
  }

  @override
  void initState() {
    var storageWeekStart = GetStorage().read(StorageKeys.appWeekStart);
    setState(() {
      if (storageWeekStart == null) {
        _currentWeekStart = WeekStart.monday;
      } else {
        _currentWeekStart = WeekStart.values.byName(storageWeekStart.toString().replaceFirst('WeekStart.', ''));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
      child: Container(
        height: 200,
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
                      'Week starts on',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
                title: Text('Monday', style: TextStyle(color: Theme.of(context).shadowColor)),
                leading: Radio<WeekStart>(
                  activeColor: Theme.of(context).shadowColor,
                  fillColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).shadowColor),
                  value: WeekStart.monday,
                  groupValue: _currentWeekStart,
                  onChanged: (WeekStart? value) {
                    changeTheme(value!);
                  },
                ),
                onTap: () {
                  changeTheme(WeekStart.monday);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Sunday', style: TextStyle(color: Theme.of(context).shadowColor)),
                leading: Radio<WeekStart>(
                  activeColor: Theme.of(context).shadowColor,
                  fillColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).shadowColor),
                  value: WeekStart.sunday,
                  groupValue: _currentWeekStart,
                  onChanged: (WeekStart? value) {
                    changeTheme(value!);
                  },
                ),
                onTap: () {
                  changeTheme(WeekStart.sunday);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
