import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

Widget studentList(
  BuildContext context,
  String title,
  int avatarId,
  int i,
) {
  final l10n = AppLocalizations.of(context)!;
  return ListTile(
    trailing: Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
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
      style: Theme.of(Get.context!).textTheme.bodyText2!.copyWith(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
    ),
    subtitle: Text(
      l10n.student_latest_meeting,
      style: Theme.of(Get.context!).textTheme.bodySmall!.copyWith(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
    ),
  );
}
