import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';

Widget studentList(
  BuildContext context,
  String title,
  int avatarId,
  int i,
  DateTime? lastMeeting,
) {
  final l10n = AppLocalizations.of(context)!;
  return ListTile(
    trailing: Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).shadowColor,
        borderRadius: BorderRadius.circular(70),
        image: DecorationImage(
          image: AssetImage(
            'assets/avatars/avatar_${i % 15}.png',
          ),
        ),
      ),
    ),
    title: Text(
      title,
      style: Theme.of(Get.context!).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).shadowColor,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
    ),
    subtitle: (lastMeeting != null)
        ? Text(
            '${l10n.student_latest_meeting}: '
            '${lastMeeting.day.toString().padLeft(2, '0')} '
            '${Constants().convertMonthNumber(lastMeeting.month).toLowerCase()}',
            style: Theme.of(Get.context!).textTheme.bodySmall!.copyWith(
                  color: Theme.of(context).shadowColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
          )
        : null,
  );
}
