import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progressp/config/body_measurements.dart';

Widget measurementContainer(
  BuildContext context,
  BodyMeasurementType measurementType,
  String title,
  String value,
  String day,
  String month,
) {
  return Container(
    width: (Get.width - 90) / 3,
    height: 100,
    decoration: BoxDecoration(
      color: measurementType.color,
      border: Border.all(
        color: Theme.of(context).shadowColor,
        width: 2,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    measurementType.icon,
                    color: Colors.white,
                    size: 36,
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.caption!.copyWith(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.caption!.copyWith(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    month,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    day,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
