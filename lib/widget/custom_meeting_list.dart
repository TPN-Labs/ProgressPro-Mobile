import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/model/student/meeting_model.dart';

Widget meetingList(
  BuildContext context,
  MeetingModel meetingData,
  bool showAvatar,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      height: 80,
      width: Get.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).shadowColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
        color: HexColor(AppTheme.primaryColorString).withOpacity(0.2),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 64,
              width: 48,
              decoration: BoxDecoration(
                color: HexColor(AppTheme.primaryColorString),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    meetingData.startAt.day.toString().padLeft(2, '0'),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    Constants().convertMonthNumber(meetingData.startAt.month).substring(0, 3),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${meetingData.startAt.hour.toString().padLeft(2, '0')}:${meetingData.startAt.minute.toString().padLeft(2, '0')} '
                  '- ${meetingData.endAt.hour.toString().padLeft(2, '0')}:${meetingData.endAt.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 20,
                        color: Theme.of(context).shadowColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  meetingData.student.fullName,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).shadowColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(width: 50),
            if (showAvatar) ...[
              Container(
                height: 64,
                width: 48,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/avatars/avatar_${meetingData.student.avatar % 15}.png',
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
