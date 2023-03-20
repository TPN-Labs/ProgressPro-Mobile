import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget quickAccessContainer(BuildContext context, String? title, Icon icon, String? highlightColor) {
  return Container(
    width: (Get.width - 90) / 3,
    height: 100,
    decoration: BoxDecoration(
      color: Theme.of(context).bottomAppBarTheme.color,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Colors.black,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [icon],
        ),
        const SizedBox(height: 14),
        Text(
          title!,
          style: Theme.of(context).textTheme.caption!.copyWith(
            fontSize: 14,
            color: Theme.of(context).shadowColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}