import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget studentList(
  BuildContext context,
  String title,
  int avatarId,
  int i,
) {
  return ListTile(
    trailing: Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
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
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
    ),
    subtitle: Text(
      'Ultima vizita: ',
      style: Theme.of(Get.context!).textTheme.bodySmall!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w300,
          ),
    ),
  );
}
