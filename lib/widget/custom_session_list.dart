import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/model/student/student_model.dart';

Widget sessionList(
  BuildContext context,
  String title,
  SessionStatus sessionStatus,
  StudentModelShort student,
) {
  final l10n = AppLocalizations.of(context)!;
  return ListTile(
    trailing: Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: sessionStatus.color,
        borderRadius: BorderRadius.circular(70),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Icon(
        sessionStatus.icon,
        color: Colors.white,
        size: 42,
      ),
    ),
    title: Text(
      title,
      style: Theme.of(Get.context!).textTheme.bodyText2!.copyWith(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
    ),
    subtitle: Text(
      "Student: ${student.fullName}",
      style: Theme.of(Get.context!).textTheme.bodySmall!.copyWith(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
    ),
  );
}
