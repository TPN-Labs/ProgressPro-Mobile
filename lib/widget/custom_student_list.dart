import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget studentList(
  String title,
) {
  return ListTile(
    leading: Icon(
      Icons.person,
      color: Theme.of(Get.context!).textTheme.headline6!.color!,
      size: 48,
    ),
    title: Text(
      title,
      style: Theme.of(Get.context!).textTheme.bodyText2!.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
    ),
    trailing: Wrap(
      children: [
        Container(
          height: 48,
          width: 48,
          decoration: const BoxDecoration(
            color: Colors.indigoAccent,
          ),
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        Container(
          height: 48,
          width: 48,
          decoration: const BoxDecoration(
            color: Colors.red,
          ),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 32,
          ),
        ),
      ],
    )
  );
}
