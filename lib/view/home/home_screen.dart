import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/controller/student/meeting_controller.dart';
import 'package:progressp/controller/student/student_controller.dart';
import 'package:progressp/controller/user/auth_controller.dart';
import 'package:progressp/model/student/meeting_model.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/view/student/all_meetings_screen.dart';
import 'package:progressp/view/student/all_sessions_screen.dart';
import 'package:progressp/view/student/all_students_screen.dart';
import 'package:progressp/widget/custom_meeting_list.dart';
import 'package:progressp/widget/custom_quick.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final APIStudentController _apiStudentController = Get.put(APIStudentController());
  final APIMeetingController _apiMeetingController = Get.put(APIMeetingController());
  final APIAuthController _apiAuthController = Get.put(APIAuthController());

  List<StudentModel>? _allStudents;
  List<MeetingModel>? _allMeetings;

  @override
  void initState() {
    _apiStudentController.userGetAll();
    _apiMeetingController.userGetAll();

    setState(() {
      _allStudents = _apiStudentController.getAllStudents();
      _allMeetings = _apiMeetingController.getAllMeetings();
    });
    super.initState();
  }

  MeetingModel? getLatestMeeting(String studentId) {
    List<MeetingModel> studentMeetings = _allMeetings!.where((e) => e.student.id == studentId).toList();
    studentMeetings.sortBy((element) => element.startAt);
    return studentMeetings.lastOrNull;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            width: Get.width,
            color: HexColor(AppTheme.primaryColorString),
            child: Padding(
              padding: Constants.defaultScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${l10n.home_title},',
                            style: Theme.of(context).textTheme.headline1!.copyWith(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _apiAuthController.getUsernameFromToken(),
                            style: Theme.of(context).textTheme.headline2!.copyWith(
                                  fontSize: 32,
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 72,
                          width: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).appBarTheme.backgroundColor,
                            border: Border.all(
                              color: HexColor(AppTheme.primaryColorString),
                              width: 2,
                            ),
                          ),
                          child: SizedBox(
                            width: 72,
                            height: 72,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(72),
                              child: Icon(
                                Icons.person,
                                color: HexColor(AppTheme.primaryColorString),
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => const AllMeetingsScreen(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: Constants.transitionDuration),
                              );
                            },
                            child: quickAccessContainer(
                              context,
                              l10n.home_quick_1,
                              Icon(
                                Icons.calendar_month,
                                color: Theme.of(context).primaryColor,
                                size: 36,
                              ),
                              null,
                            ),
                          ),
                          const SizedBox(width: 25),
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => const AllSessionsScreen(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: Constants.transitionDuration),
                              );
                            },
                            child: quickAccessContainer(
                              context,
                              l10n.home_quick_2,
                              Icon(
                                Icons.sports_handball,
                                color: Theme.of(context).primaryColor,
                                size: 36,
                              ),
                              null,
                            ),
                          ),
                          const SizedBox(width: 25),
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => const AllStudentsScreen(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: Constants.transitionDuration),
                              );
                            },
                            child: quickAccessContainer(
                              context,
                              l10n.home_quick_3,
                              Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                                size: 36,
                              ),
                              null,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: Constants.defaultScreenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        l10n.home_latest,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 20,
                            ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          if (_allStudents != null) ...[
                            for (var i = 0; i < _allStudents!.length; i++)
                              if (getLatestMeeting(_allStudents!.elementAt(i).id) != null)
                                meetingList(
                                  context,
                                  getLatestMeeting(_allStudents!.elementAt(i).id)!,
                                  true,
                                ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget circleCard(BuildContext context, IconData icon, String text, Color color) {
  return SizedBox(
    width: (Get.width - 50) / 4,
    child: Column(
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Icon(
              icon,
              size: 40,
              color: HexColor(AppTheme.secondaryColorString),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
