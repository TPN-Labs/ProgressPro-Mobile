import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/controller/student/meeting_controller.dart';
import 'package:progressp/model/student/meeting_model.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/utils/date_utils.dart';
import 'package:progressp/view/student/view_student_screen.dart';

import 'custom_button.dart';

Widget meetingList({
  required BuildContext context,
  required MeetingModel meetingData,
  required bool isOnHomeScreen,
  StudentModel? studentModel,
  Function? refreshList,
}) {
  final l10n = AppLocalizations.of(context)!;
  final APIMeetingController _apiMeetingController =
      Get.put(APIMeetingController());

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
        child: InkWell(
          onTap: () {
            isOnHomeScreen == true
                ? Get.to(
                    () => ViewStudentScreen(
                      context,
                      refreshList,
                      studentModel!,
                    ),
                    transition: Transition.rightToLeft,
                    duration: const Duration(
                      milliseconds: Constants.transitionDuration,
                    ),
                  )
                : {};
          },
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
                      Constants()
                          .convertMonthNumber(meetingData.startAt.month)
                          .substring(0, 3),
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
              isOnHomeScreen == false
                  ? SizedBox(
                      width: 40,
                      child: CustomButton(
                        type: ButtonChildType.icon,
                        icon: Icons.delete,
                        bgColor: Colors.red,
                        showBorder: false,
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext contextDialog) {
                              return AlertDialog(
                                title: Text(l10n.meeting_modal_delete_title),
                                icon: const Icon(
                                    Icons.warning_amber_rounded,
                                  color: Colors.red,
                                  size: 64.0,
                                ),
                                backgroundColor: Theme.of(contextDialog)
                                    .appBarTheme
                                    .backgroundColor,
                                content: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'Student: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              meetingData.student.fullName,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Data: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              convertDateToString(
                                                  meetingData.startAt),
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Ora: ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            Text(
                                              '${meetingData.startAt.hour}:00 -> ${meetingData.endAt.hour}:00',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: DefaultMargins.smallMargin * 2,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              l10n.meeting_modal_delete_body,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                                actions: [
                                  TextButton(
                                    child:
                                        Text(l10n.meeting_modal_delete_close),
                                    onPressed: () {
                                      Navigator.of(contextDialog).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      l10n.meeting_modal_delete_confirm,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () {
                                      _apiMeetingController.userDelete(
                                        context,
                                        studentModel!.id,
                                        meetingData.id,
                                        refreshList!,
                                      );
                                      Navigator.of(contextDialog).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    ),
  );
}
