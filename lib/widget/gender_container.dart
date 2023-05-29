import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progressp/config/textstyle.dart';

Widget genderContainer(
    BuildContext context,
    String? title,
    Icon icon,
    bool isSelected,
    ) {
  return Container(
    width: (Get.width - 100) / 3,
    height: 100,
    decoration: BoxDecoration(
      color: isSelected != false ? HexColor(AppTheme.primaryColorString) : Theme.of(context).bottomAppBarTheme.color,
      borderRadius: BorderRadius.circular(100),
      border: Border.all(
        color: Theme.of(context).shadowColor,
        width: 1.5,
      ),
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
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontSize: 14,
            color: isSelected != false ? Colors.white : Theme.of(context).shadowColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}